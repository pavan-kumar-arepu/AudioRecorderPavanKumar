//
//  AudioRecorderPavanKumarApp.swift
//  AudioRecorderPavanKumar
//
//  Created by Pavankumar Arepu on 16/06/24.
//

import SwiftUI

//@main
//struct AudioRecorderPavanKumarApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

import SwiftUI

@main
struct AudioRecorderPavanKumarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("stopRecording"), object: nil)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("saveRecordingState"), object: nil)
    }
}
