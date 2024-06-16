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
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text(viewModel.recordingDurationFormatted)
                .font(.largeTitle)
                .padding()
            
            VolumeMeterView(levels: viewModel.audioLevels)
                .frame(height: 100)
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
            NotificationCenter.default.addObserver(forName: Notification.Name("lowDiskSpace"), object: nil, queue: .main) { _ in
                self.showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Low Disk Space"), message: Text("Your device is running low on disk space. Please free up some space."), dismissButton: .default(Text("OK")))
        }
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(viewModel: RecorderViewModel())
    }
}
