//
//  QuipperViewModel.swift
//  Learn Xcode
//
//  Created by Leonardi on 05/11/24.
//

import Foundation
import SwiftUI

struct Course: Hashable, Codable {
    let title: String
    let presenter_name: String
    let description: String
    let thumbnail_url: String
    let video_url: String
    let video_duration: Int
}

class QuipperViewModel: ObservableObject {
    @Published var courses: [Course] = []
    
    func fetch() {
        guard let url = URL(string: "https://quipper.github.io/native-technical-exam/playlist.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self?.courses = courses
                }
            } catch {
                print (error)
            }
        }
        
        task.resume()
    }
}
