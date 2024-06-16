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
class RecorderViewModel: NSObject, ObservableObject {
    enum RecordingState {
        case idle, recording, paused
    }
    
    @Published var recordingState: RecordingState = .idle
    @Published var recordingDuration: TimeInterval = 0.0
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    // MARK: - Recording Actions

    func startRecording() {
        // Which takes case about Recording
        let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setCategory(.record, mode: .default)
                try audioSession.setActive(true)
                
                let audioSettings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100.0,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let audioFileURL = documentsPath.appendingPathComponent("recording.m4a")
                
                audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: audioSettings)
                audioRecorder?.delegate = self
                audioRecorder?.record()
                recordingState = .recording
                
                startTimer()
            } catch {
                print("Error starting recording: \(error.localizedDescription)")
            }
    }
    
    func pauseRecording() {
        // Which Pauses the recording
        audioRecorder?.pause()
        recordingState = .paused
        timer?.invalidate()
    }
    
    func resumeRecording() {
        // Which Resume the ongoing recording
        audioRecorder?.record()
        recordingState = .recording
        startTimer()
    }
    
    func stopRecording() {
        // Which Stops and save the recording
        audioRecorder?.stop()
        recordingState = .idle
        timer?.invalidate()
        
        saveRecording()
    }

    private func startTimer() {
        // Which takes case about the recording duration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingDuration += 1.0
        }
    }
    
    private func saveRecording() {
        guard let audioRecorder = audioRecorder else { return }
        
        audioRecorder.stop()
        
        let sourceURL = audioRecorder.url
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent("savedRecording.m4a")
        
        do {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
            print("Recording saved to FileManager: \(destinationURL)")
            
            // Optionally, you can update your data model or trigger any necessary UI updates here
            
        } catch {
            print("Error saving recording: \(error.localizedDescription)")
        }
    }
}


extension RecorderViewModel: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("*** APK: Error during recording", error.debugDescription)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // Handle successful recording finish if needed
        } else {
            // Handle recording finish failure if needed
        }
    }
}
