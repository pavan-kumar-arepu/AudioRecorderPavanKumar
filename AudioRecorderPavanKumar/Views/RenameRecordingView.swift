//
//  RenameRecordingView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI

/// SwiftUI view for renaming a recording with user-provided input.
///
/// This view allows users to enter a new name for a recording and provides options to confirm or cancel the renaming action.
///
/// - Parameters:
///   - isPresented: A binding to control the presentation of the view.
///   - newName: A binding to store the user-provided new name for the recording.
///   - confirmAction: A closure to execute when the user confirms the renaming action.
///
/// - Author: Arepu Pavan Kumar

struct RenameRecordingView: View {
    @Binding var isPresented: Bool
    @Binding var newName: String
    let confirmAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Rename") // Title text
                .font(.title)
                .padding()
            
            Spacer()
            
            // Image indicating audio playback
            Image("edit")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 175, height: 175) // Adjust size as needed
                .padding()
            
            Spacer()
            
            TextField("New Name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Spacer()
            
            HStack {
                Button(action: {
                    confirmAction()
                    isPresented = false
                }) {
                    Text("Rename")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
