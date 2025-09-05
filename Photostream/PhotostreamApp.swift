//
//  PhotostreamApp.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 3/9/25.
//

import SwiftUI

@main
struct PhotostreamApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
        }
    }
}
