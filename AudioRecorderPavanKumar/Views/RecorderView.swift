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
    
    var body: some View {
        VStack {
            Text(viewModel.recordingState == .recording ? "Recording..." : "Tap to Record")
                .padding()
            
            Text("\(formattedDuration())")
                .foregroundColor(.gray)
            
            HStack {
                Button(action: {
                    if self.viewModel.recordingState == .recording {
                        self.viewModel.pauseRecording()
                    } else {
                        self.viewModel.startRecording()
                    }
                }) {
                    Image(systemName: viewModel.recordingState == .recording ? "pause.circle.fill" : "circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    self.viewModel.stopRecording()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
    
    private func formattedDuration() -> String {
        let duration = Int(viewModel.recordingDuration)
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(viewModel: RecorderViewModel())
    }
}
