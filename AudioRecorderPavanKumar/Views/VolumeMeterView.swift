//
//  VolumeMeterView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct VolumeMeterView: View {
    var levels: [Float]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 2) {
                ForEach(levels, id: \.self) { level in
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 4, height: CGFloat(level + 160) * geometry.size.height / 160)
                }
            }
        }
    }
}
