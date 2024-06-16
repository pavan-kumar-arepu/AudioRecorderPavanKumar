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

class RecorderViewModel: NSObject, ObservableObject {
    enum RecordingState {
        case idle, recording, paused
    }
    
    @Published var recordingState: RecordingState = .idle
    @Published var recordingDuration: TimeInterval = 0.0
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    func startRecording() {
        // Which takes case about Recording
    }
    
    func pauseRecording() {
        // Which Pauses the recording
    }
    
    func resumeRecording() {
        // Which Resume the ongoing recording
    }
    
    func stopRecording() {
        // Which Stops and save the recording
        
    }

    private func startTimer() {
        // Which takes case about the recording duration
    }
}


extension RecorderViewModel: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        <#code#>
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        <#code#>
    }
}
