//
//  RecordingListViewModel.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation


/// ViewModel for managing a list of recorded audio files.
///
/// This class provides functionality to fetch, rename, and delete recorded audio files
/// stored in the document directory.
///
/// - Author: Arepu Pavan Kumar
class RecordingsListViewModel: ObservableObject {
    /// Published property to observe changes in the list of recorded audio file URLs.
    @Published var recordings: [URL] = []
    
    /// Initializes the `RecordingsListViewModel` and fetches recorded audio files.
    init() {
        fetchRecordings()
    }
    
    /// Fetches the list of recorded audio files from the document directory.
    func fetchRecordings() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            recordings = files.filter { $0.pathExtension == "m4a" }
        } catch {
            print("Error fetching recordings: \(error.localizedDescription)")
        }
    }
    
    /// Renames the recorded audio file at a specified index.
    /// - Parameters:
    ///   - index: Index of the recording in the `recordings` array.
    ///   - newName: New name to assign to the recording.
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
    
    /// Deletes the recorded audio file at a specified index.
    /// - Parameter index: Index of the recording in the `recordings` array.
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
