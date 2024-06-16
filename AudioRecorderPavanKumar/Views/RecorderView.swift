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
            Text(viewModel.recordingDurationFormatted)
                .font(.largeTitle)
                .padding()
            
            HStack {
                if viewModel.recordingState == .idle {
                    Button(action: {
                        viewModel.startRecording()
                    }) {
                        Text("Record")
                            .font(.headline)
                            .padding()
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
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.onRecordingFinished = {
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(viewModel: RecorderViewModel())
    }
}
