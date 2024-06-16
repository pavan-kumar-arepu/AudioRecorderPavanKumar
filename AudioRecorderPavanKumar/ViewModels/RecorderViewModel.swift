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
    enum RecordingState {
        case idle, recording, paused
    }
    
    @Published var recordingState: RecordingState = .idle
    @Published var recordingDuration: TimeInterval = 0.0
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    override init() {
        super.init()
    }
    
    var recordingDurationFormatted: String {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Recording Actions

    func startRecording() {
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let timestamp = dateFormatter.string(from: Date())
            let audioFileURL = documentsPath.appendingPathComponent("recording_\(timestamp).m4a")
            
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: audioSettings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            recordingState = .recording
            
            startTimer()
        } catch {
            print("**** Error starting recording: \(error.localizedDescription)")
        }
    }
    
    func pauseRecording() {
        audioRecorder?.pause()
        recordingState = .paused
        timer?.invalidate()
    }
    
    func resumeRecording() {
        audioRecorder?.record()
        recordingState = .recording
        startTimer()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        recordingState = .idle
        timer?.invalidate()
        
        saveRecording()
    }
    
    private func startTimer() {
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
        let destinationURL = documentsPath.appendingPathComponent(sourceURL.lastPathComponent)
        
        do {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
            print("#### Recording saved to FileManager: \(destinationURL)")
        } catch {
            print("**** Error saving recording: \(error.localizedDescription)")
        }
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
