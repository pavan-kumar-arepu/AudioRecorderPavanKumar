//
//  StorageManager.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import Foundation


/// `StorageManager` handles disk space management and notifications for low disk space.
///
/// This class provides methods to retrieve available disk space and notify when disk space is low.
///
/// - Author: Arepu Pavan Kumar

/// `StorageManager` handles disk space management and notifications for low disk space.
///

class StorageManager {
    /// Shared instance of `StorageManager` to provide a singleton access.
    static let shared = StorageManager()
    
    /// Private initializer to prevent creating instances of `StorageManager` directly.
    private init() {}
    
    /// Retrieves the available free disk space in bytes for the application's home directory.
    ///
    /// - Returns: An `Int64` value representing the available free space in bytes.
    func getAvailableDiskSpace() -> Int64 {
        if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let freeSize = attributes[.systemFreeSize] as? Int64 {
            return freeSize
        }
        return 0
    }
    
    /// Notifies if the available disk space is below a specified threshold (500MB).
    ///
    /// This method posts a notification to the default notification center if the free disk
    /// space falls below 500MB. The notification name is "lowDiskSpace".
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
