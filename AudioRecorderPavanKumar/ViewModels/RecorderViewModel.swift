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

class RecorderViewModel: NSObject, ObservableObject {
    /// Enum representing the possible states of audio recording., ofcouse, we can keep enum outside of class also
    enum RecordingState: String {
        case idle, recording, paused
    }
    
    /// Published property to observe changes in recording state.
    @Published var recordingState: RecordingState = .idle
    /// Published property to observe changes in recording duration.
    @Published var recordingDuration: TimeInterval = 0.0
    /// Array to store URLs of recorded audio files.
    @Published var recordings: [URL] = []
    
    /// Private property to manage `AVAudioRecorder` instance.
    private var audioRecorder: AVAudioRecorder?
    /// Timer to update recording duration and audio levels.
    private var timer: Timer?
    
    /// Closure to handle actions after recording finishes.
    var onRecordingFinished: (() -> Void)?
    
    /// Initializes the `RecorderViewModel` and sets up necessary observers.
    override init() {
        super.init()
        loadRecordingState()
        NotificationCenter.default.addObserver(self, selector: #selector(stopRecording), name: Notification.Name("stopRecording"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveRecordingState), name: Notification.Name("saveRecordingState"), object: nil)
    }
    
    /// Formatted string representation of the recording duration (HH:mm:ss).
    var recordingDurationFormatted: String {
        let hours = Int(recordingDuration) / 3600
        let minutes = (Int(recordingDuration) % 3600) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    /// Array to store audio levels for volume meter visualization.
    @Published var audioLevels: [Float] = []
    
    // MARK: - Recording Actions
    
    /// Starts recording audio.
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth, .allowAirPlay, .mixWithOthers])
            try audioSession.setActive(true)
            
            let audioSettings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let timestamp = dateFormatter.string(from: Date())
            let audioFileURL = documentsPath.appendingPathComponent("recording_\(timestamp).m4a")
            
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: audioSettings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true // Enable metering
            audioRecorder?.record()
            recordingState = .recording
            
            startTimer()
            saveRecordingState()
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }
    
    /// Renames the recorded audio file at a specified index.
    /// - Parameters:
    ///   - index: Index of the recording in the `recordings` array.
    ///   - newName: New name to assign to the recording.
    func renameRecording(at index: Int, to newName: String) {
        let oldURL = recordings[index]
        let newURL = oldURL.deletingLastPathComponent().appendingPathComponent("\(newName).m4a")
        
        do {
            try FileManager.default.moveItem(at: oldURL, to: newURL)
            recordings[index] = newURL
            print("Recording renamed to: \(newURL.lastPathComponent)")
        } catch {
            print("Error renaming recording: \(error.localizedDescription)")
        }
    }
    
    /// Deletes the recorded audio file at a specified index.
    /// - Parameter index: Index of the recording in the `recordings` array.
    func deleteRecording(at index: Int) {
        let recordingURL = recordings[index]
        
        do {
            try FileManager.default.removeItem(at: recordingURL)
            recordings.remove(at: index)
            print("Recording deleted: \(recordingURL.lastPathComponent)")
        } catch {
            print("Error deleting recording: \(error.localizedDescription)")
        }
    }
    
    /// Pauses the current audio recording.
    func pauseRecording() {
        audioRecorder?.pause()
        recordingState = .paused
        timer?.invalidate()
        saveRecordingState()
    }
    
    /// Resumes the paused audio recording.
    func resumeRecording() {
        audioRecorder?.record()
        recordingState = .recording
        startTimer()
        saveRecordingState()
    }
    
    /// Stops the current audio recording.
    @objc func stopRecording() {
        audioRecorder?.stop()
        recordingState = .idle
        timer?.invalidate()
        
        saveRecording()
        clearRecordingState()
        onRecordingFinished?()
    }
    
    // MARK: - Private Methods
    
    /// Starts a timer to update recording duration and audio levels.
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingDuration += 0.1
            
            // Update audio level
            self.audioRecorder?.updateMeters()
            let level = self.audioRecorder?.averagePower(forChannel: 0) ?? -160.0
            self.audioLevels.append(level)
            
            // Keep only the latest 50 levels for display
            if self.audioLevels.count > 50 {
                self.audioLevels.removeFirst()
            }
        }
    }
    
    /// Saves the recorded audio file to the document directory.
    private func saveRecording() {
        guard let audioRecorder = audioRecorder else { return }
        
        audioRecorder.stop()
        
        let sourceURL = audioRecorder.url
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(sourceURL.lastPathComponent)
        
        do {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
            print("Recording saved to FileManager: \(destinationURL)")
        } catch {
            print("Error saving recording: \(error.localizedDescription)")
        }
    }
    
    /// Saves the current recording state to `UserDefaults`.
    @objc private func saveRecordingState() {
        guard let audioRecorder = audioRecorder else { return }
        
        let recordingStateDict: [String: Any] = [
            "recordingState": recordingState.rawValue,
            "recordingDuration": recordingDuration,
            "audioFileURL": audioRecorder.url.absoluteString
        ]
        
        UserDefaults.standard.set(recordingStateDict, forKey: "recordingState")
    }
    
    /// Loads the previous recording state from `UserDefaults`.
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
    
    /// Clears the saved recording state from `UserDefaults`.
    private func clearRecordingState() {
        UserDefaults.standard.removeObject(forKey: "recordingState")
    }
}

// MARK: - AVAudioRecorderDelegate

extension RecorderViewModel: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("**** APK: Error during recording", error.debugDescription)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("#### Recording finished successfully")
        } else {
            print("**** APK: Recording finished with failure")
        }
    }
}
