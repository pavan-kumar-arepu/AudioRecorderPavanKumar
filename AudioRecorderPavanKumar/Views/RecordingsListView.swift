//
//  RecordingsListView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI
import SwiftUI

struct RecordingsListView: View {
    @StateObject var viewModel = RecordingsListViewModel()
    @State private var showingRecorder = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.recordings, id: \.self) { url in
                        NavigationLink(destination: PlayerView(audioURL: url)) {
                            VStack(alignment: .leading) {
                                Text(url.lastPathComponent)
                                Text(self.formatDate(from: url))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .navigationTitle("Recordings")
                
                Button(action: {
                    showingRecorder = true
                }) {
                    Text("Start New Recording")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .sheet(isPresented: $showingRecorder) {
                RecorderView(viewModel: RecorderViewModel())
            }
        }
    }
    
    private func formatDate(from url: URL) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let fileName = url.lastPathComponent
        let timestampString = fileName.replacingOccurrences(of: "recording_", with: "").replacingOccurrences(of: ".m4a", with: "")
        
        if let date = dateFormatter.date(from: timestampString) {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        }
        
        return "Unknown date"
    }
}

struct RecordingsListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsListView()
    }
}
