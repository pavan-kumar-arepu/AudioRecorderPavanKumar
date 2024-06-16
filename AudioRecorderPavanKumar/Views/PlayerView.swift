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

struct PlayerView: View {
    @ObservedObject private var viewModel: PlayerViewModel
    var renameAction: () -> Void // Closure to trigger rename action
    
    init(audioURL: URL, renameAction: @escaping () -> Void) {
        _viewModel = ObservedObject(wrappedValue: PlayerViewModel(audioURL: audioURL))
        self.renameAction = renameAction
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("playing")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 175, height: 175) // Adjust size as needed
                .padding()
            
            if let audioURL = viewModel.audioURL {
                Text(audioURL.lastPathComponent)
                    .font(.headline)
                    .padding()
            }
            
            Spacer()
            
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
        .navigationTitle("Player")
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(audioURL: URL(fileURLWithPath: "path_to_recording"), renameAction: {})
    }
}
