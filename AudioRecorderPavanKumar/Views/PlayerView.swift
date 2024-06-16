//
//  PlayerView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI
import AVFoundation
import SwiftUI

/// SwiftUI view for playing audio with playback controls and renaming option.
///
/// This view displays an image indicating playback, the name of the audio file being played,
/// playback controls (play/pause), and a button to trigger renaming of the audio file.
///
/// - Author: Arepu Pavan Kumar
/// 
struct PlayerView: View {
    @ObservedObject private var viewModel: PlayerViewModel
    var renameAction: () -> Void // Closure to trigger rename action
    
    /// Initializes the PlayerView with an audio URL and a closure to trigger renaming.
    ///
    /// - Parameters:
    ///   - audioURL: The URL of the audio file to be played.
    ///   - renameAction: A closure to be executed when the rename button is tapped.
    init(audioURL: URL, renameAction: @escaping () -> Void) {
        _viewModel = ObservedObject(wrappedValue: PlayerViewModel(audioURL: audioURL))
        self.renameAction = renameAction
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            // Image indicating audio playback
            Image("playing")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 175, height: 175) // Adjust size as needed
                .padding()
            
            // Display the name of the audio file being played
            if let audioURL = viewModel.audioURL {
                Text(audioURL.lastPathComponent)
                    .font(.headline)
                    .padding()
            }
            
            Spacer()
            
            // Playback controls (Play/Pause)
            HStack {
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
                
                // Button to trigger renaming of the audio file
                Button(action: {
                    renameAction() // Trigger rename action
                }) {
                    Text("Rename")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Player") // Navigation title for PlayerView
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(audioURL: URL(fileURLWithPath: "path_to_recording"), renameAction: {})
    }
}
