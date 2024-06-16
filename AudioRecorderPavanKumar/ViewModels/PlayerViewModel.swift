//
//  PlayerViewModel.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import AVFoundation

/// ViewModel for playing audio from a specified URL.
///
/// This class provides methods to play and pause audio using `AVAudioPlayer`. It manages the
/// state of audio playback (`isPlaying`) and interacts with the audio player delegate to handle
/// playback completion events.
///
/// - Author: Arepu Pavan Kumar
/// 
class PlayerViewModel: NSObject, ObservableObject {
    /// Published property to observe changes in the playback state.
    @Published var isPlaying = false
    
    /// URL of the audio file to be played.
    var audioURL: URL?
    
    private var audioPlayer: AVAudioPlayer?
    
    /// Initializes the `PlayerViewModel` with the specified audio URL.
    /// - Parameter audioURL: URL of the audio file to play.
    init(audioURL: URL) {
        self.audioURL = audioURL
    }
    
    /// Starts playing the audio file specified by `audioURL`.
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
    
    /// Pauses the currently playing audio.
    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
    }
}

// MARK: - AVAudioPlayerDelegate

extension PlayerViewModel: AVAudioPlayerDelegate {
    /// Called when the audio player finishes playing the audio file.
    ///
    /// Updates `isPlaying` to `false` when playback completes successfully or encounters an error.
    /// - Parameters:
    ///   - player: The audio player that finished playing the audio.
    ///   - flag: Indicates whether the playback completed successfully.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
