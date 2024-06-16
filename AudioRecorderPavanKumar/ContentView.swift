//
//  ContentView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RecorderView(viewModel: RecorderViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
