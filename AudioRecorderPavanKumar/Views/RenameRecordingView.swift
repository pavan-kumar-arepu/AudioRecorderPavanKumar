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
               
            
            
            TextField("New Name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button(action: {
                    confirmAction()
                    isPresented = false
                }) {
                    Text("Rename")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
    }
}
