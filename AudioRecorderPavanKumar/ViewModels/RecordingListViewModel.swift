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
}
