//
//  PlayerViewModel.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import AVFoundation

class PlayerViewModel: NSObject, ObservableObject {
    @Published var isPlaying = false
    var audioURL: URL?
    
    private var audioPlayer: AVAudioPlayer?
    
    init(audioURL: URL) {
        self.audioURL = audioURL
    }
    
    func playAudio() {
        guard let audioURL = audioURL else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
    }
}

extension PlayerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
