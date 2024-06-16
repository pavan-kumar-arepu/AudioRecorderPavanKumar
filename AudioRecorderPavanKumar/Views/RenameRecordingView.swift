//
//  RenameRecordingView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI

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
