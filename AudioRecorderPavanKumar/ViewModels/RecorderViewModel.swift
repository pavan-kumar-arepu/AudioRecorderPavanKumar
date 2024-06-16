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

/*
 In Swift, classes must inherit from NSObject to interoperate with Objective-C protocols.
 */
import Foundation
import AVFoundation

class RecorderViewModel: NSObject, ObservableObject {
    enum RecordingState: String {
        case idle, recording, paused
    }
    
    @Published var recordingState: RecordingState = .idle
    @Published var recordingDuration: TimeInterval = 0.0
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    var onRecordingFinished: (() -> Void)?
    
    override init() {
        super.init()
        loadRecordingState()
        NotificationCenter.default.addObserver(self, selector: #selector(stopRecording), name: Notification.Name("stopRecording"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveRecordingState), name: Notification.Name("saveRecordingState"), object: nil)
    }
    
    var recordingDurationFormatted: String {
        let hours = Int(recordingDuration) / 3600
        let minutes = (Int(recordingDuration) % 3600) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
//    @Published var audioLevel: Float = 0.0
    @Published var audioLevels: [Float] = []
    
    // MARK: - Recording Actions

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
     
    
    func pauseRecording() {
        audioRecorder?.pause()
        recordingState = .paused
        timer?.invalidate()
        saveRecordingState()
    }
    
    func resumeRecording() {
        audioRecorder?.record()
        recordingState = .recording
        startTimer()
        saveRecordingState()
    }
    
    @objc func stopRecording() {
        audioRecorder?.stop()
        recordingState = .idle
        timer?.invalidate()
        
        saveRecording()
        clearRecordingState()
        onRecordingFinished?()
    }
    
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
    
    @objc private func saveRecordingState() {
        guard let audioRecorder = audioRecorder else { return }
        
        let recordingStateDict: [String: Any] = [
            "recordingState": recordingState.rawValue,
            "recordingDuration": recordingDuration,
            "audioFileURL": audioRecorder.url.absoluteString
        ]
        
        UserDefaults.standard.set(recordingStateDict, forKey: "recordingState")
    }
    
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
    
    private func clearRecordingState() {
        UserDefaults.standard.removeObject(forKey: "recordingState")
    }
}

extension RecorderViewModel: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("**** APK: Error during recording", error.debugDescription)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("#### Recording finished successfully")
        } else {
            print("**** Recording finished with failure")
        }
    }
}
