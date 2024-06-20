//
//  NoRecordingsView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 20/06/24.
//

import Foundation
import SwiftUI

struct NoRecordingsView: View {
    var body: some View {
        VStack {
            Image("norecordingsyet")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding()

            Text("No recordings yet!\nStart your first recording.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

/// Previews for `RecordingsListView`.
struct NoRecordingsView_Previews: PreviewProvider {
    static var previews: some View {
        NoRecordingsView()
    }
}
