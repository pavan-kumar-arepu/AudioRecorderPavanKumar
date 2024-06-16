//
//  RecorderView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//
import Foundation
import SwiftUI

struct RecorderView: View {
    @ObservedObject var viewModel: RecorderViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("I am listening") // Title text
                      .font(.title)
                      .padding()
                  
                  Spacer()
            
            // Hearing indicator image
                      Image("eavesdropping")
                          .resizable()
                          .aspectRatio(contentMode: .fit)
                          .frame(width: 175, height: 175) // Adjust size as needed
                          .padding()
                      
            
            Text(viewModel.recordingDurationFormatted)
                .font(.largeTitle)
                .padding()
            
            VolumeMeterView(levels: viewModel.audioLevels)
                    .frame(height: 100)
                    .padding()
            
            Spacer()
            
            HStack {
                if viewModel.recordingState == .idle {
                    Button(action: {
                        viewModel.startRecording()
                    }) {
                        Text("Record")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else if viewModel.recordingState == .recording {
                    Button(action: {
                        viewModel.pauseRecording()
                    }) {
                        Text("Pause")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                } else if viewModel.recordingState == .paused {
                    Button(action: {
                        viewModel.resumeRecording()
                    }) {
                        Text("Resume")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                if viewModel.recordingState != .idle {
                    Button(action: {
                        viewModel.stopRecording()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Stop")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationTitle("Recording") // Title for the RenameRecordingView
        }
        .onDisappear {
            viewModel.stopRecording() // Ensure recording stops when view disappears
        }
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(viewModel: RecorderViewModel())
    }
}
