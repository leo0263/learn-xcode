//
//  QuipperViewModel.swift
//  Learn Xcode
//
//  Created by Leonardi on 05/11/24.
//

import Foundation
import SwiftUI
import SwiftData

private struct Course: Hashable, Codable {
    let title: String
    let presenter_name: String
    let description: String
    let thumbnail_url: String
    let video_url: String
    let video_duration: Int
}

class QuipperViewModel: ObservableObject {
    private var context: ModelContext? = nil
    
    func initialize(context: ModelContext) {
        self.context = context
    }
        
    func fetch() {
        guard let url = URL(string: "https://quipper.github.io/native-technical-exam/playlist.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                
                DispatchQueue.main.async {
                    for course in courses {
                        let courseModel = CourseModel(
                            title: course.title,
                            presenterName: course.presenter_name,
                            desc: course.description,
                            thumbnailUrl: course.thumbnail_url,
                            videoUrl: course.video_url,
                            videoDuration: course.video_duration
                        )
                        self?.context?.insert(courseModel)
                    }
                }
            } catch {
                print (error)
            }
        }
        
        task.resume()
    }
}
