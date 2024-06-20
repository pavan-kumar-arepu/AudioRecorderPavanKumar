//
//  RecorderViewModel.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
/// Manages audio recording state and operations.
///
/// This class encapsulates audio recording functionality using `AVAudioRecorder`.
/// It provides methods to start, pause, resume, stop, rename, and delete recordings,
/// as well as managing the recording state and duration.
///
/// - Author: Arepu Pavan Kumar
 
 /*
 Changes Made:
 Interruption Handling: Added setupInterruptionHandling() method to observe and handle AVAudioSession interruptions.
 Timer: Modified the timer to calculate the duration more accurately.
 Thread Safety: Added @objc for methods that are called via NotificationCenter and ensured proper thread handling using DispatchQueue.
 Duration Calculation: Used a precise method to calculate the recording duration.
 */
import AVFoundation
import Combine

/// ViewModel for managing voice memo recording.
class RecorderViewModel: NSObject, ObservableObject {
    /// Enum representing the recording state.
    enum RecordingState: String {
        case idle, recording, paused
    }

    /// Published property to indicate the current recording state.
    @Published var recordingState: RecordingState = .idle
    /// Published property to indicate the recording duration.
    @Published var recordingDuration: TimeInterval = 0.0
    /// Published property to hold the list of recorded audio URLs.
    @Published var recordings: [URL] = []
    /// Published property to hold the audio levels for visual representation.
    @Published var audioLevels: [Float] = []

    /// AVAudioRecorder instance for audio recording.
    private var audioRecorder: AVAudioRecorder?
    
    /// AVAudioEngine instance for advanced audio processing and interruptions handling.
    private var audioEngine: AVAudioEngine?
    
    /// AVAudioInputNode instance for capturing audio input.
    private var inputNode: AVAudioInputNode?
    
    /// AVAudioFile instance for handling audio file operations.
    private var audioFile: AVAudioFile?
    
    /// The start time of the current recording.
    private var recordingStartTime: Date?
    
    /// Timer to update the recording duration.
    private var timer: Timer?
    
    /// Set of Combine cancellables for handling subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// Closure to handle actions after recording finishes.
    var onRecordingFinished: (() -> Void)?

    /// Initializes the ViewModel.
    override init() {
        super.init()
        loadRecordingState()
        setupInterruptionHandling()
        setupAudioEngine() // Initialize AVAudioEngine
        
        // Automatically start recording when ViewModel is initialized
        startRecording()
    }

    /// Deinitializes the ViewModel.
    deinit {
        NotificationCenter.default.removeObserver(self)
        audioEngine?.stop()
    }

    /// Returns the formatted recording duration.
    var recordingDurationFormatted: String {
        let hours = Int(recordingDuration) / 3600
        let minutes = (Int(recordingDuration) % 3600) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    /// Starts recording a voice memo.
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth, .allowAirPlay, .mixWithOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let timestamp = dateFormatter.string(from: Date())
            let audioFileURL = documentsPath.appendingPathComponent("recording_\(timestamp).m4a")

            let audioSettings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: audioSettings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()

            recordingState = .recording
            recordingStartTime = Date()

            startTimer()
            saveRecordingState()
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }

    /// Pauses the current recording.
    func pauseRecording() {
        audioRecorder?.pause()
        recordingState = .paused
        timer?.invalidate()
        saveRecordingState()
    }

    /// Resumes the paused recording.
    func resumeRecording() {
        audioRecorder?.record()
        recordingState = .recording
        startTimer()
        saveRecordingState()
    }

    /// Stops the current recording.
    @objc func stopRecording() {
        audioRecorder?.stop()
        recordingState = .idle
        timer?.invalidate()
        recordingStartTime = nil

        saveRecording()
        clearRecordingState()
        onRecordingFinished?()
    }

    /// Starts a timer to update the recording duration.
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.recordingStartTime else { return }
            self.recordingDuration = Date().timeIntervalSince(startTime)
            self.updateAudioLevels()
        }
    }

    /// Updates the audio levels for visual representation.
    private func updateAudioLevels() {
        audioRecorder?.updateMeters()
        let level = audioRecorder?.averagePower(forChannel: 0) ?? -160.0
        audioLevels.append(level)
        if audioLevels.count > 50 {
            audioLevels.removeFirst()
        }
    }

    /// Sets up handling for audio session interruptions.
    private func setupInterruptionHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
    }

    /// Handles audio session interruptions.
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        switch type {
        case .began:
            if recordingState == .recording {
                pauseRecording()
            }
        case .ended:
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    resumeRecording()
                }
            }
        @unknown default:
            break
        }
    }

    /// Saves the current recording to the file system.
    private func saveRecording() {
        guard let audioRecorder = audioRecorder else { return }
        audioRecorder.stop()

        let sourceURL = audioRecorder.url
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(sourceURL.lastPathComponent)

        do {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
            print("Recording saved to FileManager: \(destinationURL)")
            recordings.append(destinationURL) // Append recorded URL to recordings array
        } catch {
            print("Error saving recording: \(error.localizedDescription)")
        }
    }

    /// Saves the current recording state to UserDefaults.
    private func saveRecordingState() {
        guard let audioRecorder = audioRecorder else { return }
        let recordingStateDict: [String: Any] = [
            "recordingState": recordingState.rawValue,
            "recordingDuration": recordingDuration,
            "audioFileURL": audioRecorder.url.absoluteString
        ]
        UserDefaults.standard.set(recordingStateDict, forKey: "recordingState")
    }

    /// Loads the saved recording state from UserDefaults.
    private func loadRecordingState() {
        if let recordingStateDict = UserDefaults.standard.dictionary(forKey: "recordingState") as? [String: Any] {
            if let recordingStateRawValue = recordingStateDict["recordingState"] as? String,
               let recordingState = RecordingState(rawValue: recordingStateRawValue),
               let recordingDuration = recordingStateDict["recordingDuration"] as? TimeInterval,
               let audioFileURLString = recordingStateDict["audioFileURL"] as? String,
               let audioFileURL = URL(string: audioFileURLString) {
                self.recordingState = recordingState
                self.recordingDuration = recordingDuration

                if recordingState == .recording || recordingState == .paused {
                    do {
                        let audioSettings: [String: Any] = [
                            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 44100.0,
                            AVNumberOfChannelsKey: 2,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                        ]
                        audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: audioSettings)
                        audioRecorder?.delegate = self
                        if recordingState == .recording {
                            audioRecorder?.record()
                            startTimer()
                        }
                    } catch {
                        print("Error loading recording state: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    /// Clears the saved recording state from UserDefaults.
    private func clearRecordingState() {
        UserDefaults.standard.removeObject(forKey: "recordingState")
    }

    /// Sets up the AVAudioEngine for interruption handling and audio processing.
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()

        // Setup an AVAudioInputNode to capture audio from the microphone
        guard let inputNode = audioEngine?.inputNode else {
            print("Input node not available")
            return
        }

        // Set up the audio format for the input node
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        // Install an audio tap on the input node
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, time) in
            guard let self = self else { return }

            // Process the audio buffer here if needed
            let averagePower = self.averagePower(from: buffer)
            DispatchQueue.main.async {
                self.audioLevels.append(averagePower)
                if self.audioLevels.count > 50 {
                    self.audioLevels.removeFirst()
                }
            }
        }

        // Start the AVAudioEngine
        do {
            try audioEngine?.start()
        } catch {
            print("Error starting AVAudioEngine: \(error.localizedDescription)")
        }
    }

    /// Calculates the average power level from an audio buffer.
    private func averagePower(from buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.floatChannelData?[0] else { return -160.0 }

        var totalPower: Float = 0.0
        let frameLength = Int(buffer.frameLength)

        for i in 0..<frameLength {
            totalPower += pow(channelData[i], 2.0)
        }

        let averagePower = 10.0 * log10(totalPower / Float(frameLength))
        return averagePower.isFinite ? averagePower : -160.0
    }
}

// MARK: - AVAudioRecorderDelegate
extension RecorderViewModel: AVAudioRecorderDelegate {
    /// Handles recording encode errors.
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error during recording: \(error.debugDescription)")
    }

    /// Handles the completion of recording.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording finished successfully")
        } else {
            print("Recording finished with failure")
        }
    }
}
