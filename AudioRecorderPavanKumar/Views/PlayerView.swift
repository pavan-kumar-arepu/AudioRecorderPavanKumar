//
//  PlayerView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI
import AVFoundation

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var player: AVAudioPlayer?
    @Published var isPlaying = false
    
    func startPlayback(audioURL: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.delegate = self
            player?.play()
            isPlaying = true
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func pausePlayback() {
        player?.pause()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}

/*
struct PlayerView: View {
    @ObservedObject var audioPlayerManager = AudioPlayerManager()
    let audioURL: URL
    
    var body: some View {
        VStack {
            Text("Recording Player")
                .font(.title)
                .padding()
            
            Button(action: {
                if self.audioPlayerManager.isPlaying {
                    self.audioPlayerManager.pausePlayback()
                } else {
                    self.audioPlayerManager.startPlayback(audioURL: self.audioURL)
                }
            }) {
                Image(systemName: audioPlayerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .onDisappear {
            self.audioPlayerManager.pausePlayback()
        }
    }
}
 */

struct PlayerView: View {
    @StateObject private var viewModel: PlayerViewModel
    
    init(audioURL: URL) {
        _viewModel = StateObject(wrappedValue: PlayerViewModel(audioURL: audioURL))
    }
    
    var body: some View {
        VStack {
            if let audioURL = viewModel.audioURL {
                Text(audioURL.lastPathComponent)
                    .font(.headline)
                    .padding()
            }
            
            if viewModel.isPlaying {
                Button(action: {
                    viewModel.pauseAudio()
                }) {
                    Text("Pause")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            } else {
                Button(action: {
                    viewModel.playAudio()
                }) {
                    Text("Play")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .navigationTitle("Player")
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(audioURL: URL(fileURLWithPath: "path_to_recording"))
    }
}
