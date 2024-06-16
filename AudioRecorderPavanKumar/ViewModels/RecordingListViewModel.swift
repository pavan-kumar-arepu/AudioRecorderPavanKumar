//
//  RecordingListViewModel.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation

class RecordingsListViewModel: ObservableObject {
    @Published var recordings: [URL] = []
    
    init() {
        fetchRecordings()
    }
    
    func fetchRecordings() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            recordings = files.filter { $0.pathExtension == "m4a" }
        } catch {
            print("Error fetching recordings: \(error.localizedDescription)")
        }
    }
    
    func renameRecording(at index: Int, to newName: String) {
        let oldURL = recordings[index]
        let newURL = oldURL.deletingLastPathComponent().appendingPathComponent("\(newName).m4a")
        
        do {
            try FileManager.default.moveItem(at: oldURL, to: newURL)
            recordings[index] = newURL
            print("Recording renamed to: \(newURL.lastPathComponent)")
        } catch {
            print("Error renaming recording: \(error.localizedDescription)")
        }
    }
    
    func deleteRecording(at index: Int) {
        let recordingURL = recordings[index]
        
        do {
            try FileManager.default.removeItem(at: recordingURL)
            recordings.remove(at: index)
            print("Recording deleted: \(recordingURL.lastPathComponent)")
        } catch {
            print("Error deleting recording: \(error.localizedDescription)")
        }
    }
}
