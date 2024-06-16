//
//  StorageManager.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    func getAvailableDiskSpace() -> Int64 {
        if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let freeSize = attributes[.systemFreeSize] as? Int64 {
            return freeSize
        }
        return 0
    }
    
    func notifyIfLowDiskSpace() {
        let freeSpace = getAvailableDiskSpace()
        let threshold: Int64 = 500 * 1024 * 1024 // 500MB
        
        if freeSpace < threshold {
            // Notify the user about low disk space
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("lowDiskSpace"), object: nil)
            }
        }
    }
}
