//
//  RecordingsListView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI

struct RecordingsListView: View {
    let recordings: [URL]  // Assuming URLs of saved recordings
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recordings, id: \.self) { url in
                    NavigationLink(destination: PlayerView(audioURL: url)) {
                        Text("\(url.lastPathComponent)")
                    }
                }
            }
            .navigationTitle("Recordings")
        }
    }
}

struct RecordingsListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsListView(recordings: [
            URL(fileURLWithPath: "path_to_recording_1"),
            URL(fileURLWithPath: "path_to_recording_2")
        ])
    }
}
