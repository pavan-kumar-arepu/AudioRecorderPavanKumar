//
//  VolumeMeterView.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation
import SwiftUI

/// SwiftUI view for displaying audio volume levels as vertical bars.
///
/// This view visualizes audio volume levels using a series of vertical bars, where each bar's height represents a volume level.
///
/// - Parameters:
///   - levels: An array of floating-point values representing audio volume levels. Each value should range between -160 and 0, where -160 is the minimum and 0 is the maximum volume level.
///
/// - Author: Arepu Pavan Kumar
struct VolumeMeterView: View {
    var levels: [Float]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 2) {
                ForEach(levels, id: \.self) { level in
                    Rectangle()
                        .fill(Color.green) // Color of the volume bar
                        .frame(width: 4, height: CGFloat(level + 160) * geometry.size.height / 160) // Dynamically adjusts bar height based on volume level
                }
            }
        }
    }
}

