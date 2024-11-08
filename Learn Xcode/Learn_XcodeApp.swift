//
//  Learn_XcodeApp.swift
//  Learn Xcode
//
//  Created by Leonardi on 05/11/24.
//

import SwiftUI
import SwiftData

@main
struct Learn_XcodeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [CourseObject.self])
    }
}
