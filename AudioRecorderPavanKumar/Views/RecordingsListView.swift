//
//  RecordingsListView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI

struct RenameIndex: Identifiable {
    let id: Int
}

struct RecordingsListView: View {
    @StateObject var viewModel = RecordingsListViewModel()
    @State private var showingRecorder = false
    @State private var renameIndex: Int?
    @State private var newName = ""
    @State private var isRenameViewPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.recordings.indices, id: \.self) { index in
                        let url = viewModel.recordings[index]
                        NavigationLink(destination: PlayerView(audioURL: url, renameAction: {
                            renameIndex = index
                            isRenameViewPresented = true
                        })) {
                            VStack(alignment: .leading) {
                                Text(url.lastPathComponent)
                                Text(self.formatDate(from: url))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteRecordings)
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
            .sheet(isPresented: $isRenameViewPresented) {
                RenameRecordingView(isPresented: $isRenameViewPresented, newName: $newName) {
                    viewModel.renameRecording(at: renameIndex!, to: newName)
                }
                .onDisappear {
                    newName = "" // Reset newName after dismiss
                }
            }
            .sheet(isPresented: $showingRecorder, onDismiss: {
                viewModel.fetchRecordings()
            }) {
                RecorderView(viewModel: RecorderViewModel())
            }
        }
    }
    
    private func deleteRecordings(at offsets: IndexSet) {
        offsets.forEach { index in
            viewModel.deleteRecording(at: index)
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
