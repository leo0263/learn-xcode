//
//  CourseDTO.swift
//  Learn Xcode
//
//  Created by Leonardi on 07/11/24.
//
import Foundation

struct CourseDTO: Hashable, Codable {
    let title: String
    let presenter_name: String
    let description: String
    let thumbnail_url: String
    let video_url: String
    let video_duration: Int
}
