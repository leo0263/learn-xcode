//
//  Course.swift
//  Learn Xcode
//
//  Created by Leonardi on 06/11/24.
//

import Foundation
import SwiftData

@Model
class CourseObject {
    @Attribute(.unique) var videoUrl: String
    var title: String
    var presenterName: String
    var desc: String
    var thumbnailUrl: String
    var videoDuration: Int
    
    init(title: String, presenterName: String, desc: String, thumbnailUrl: String, videoUrl: String, videoDuration: Int) {
        self.title = title
        self.presenterName = presenterName
        self.desc = desc
        self.thumbnailUrl = thumbnailUrl
        self.videoUrl = videoUrl
        self.videoDuration = videoDuration
    }
    
    convenience init(dto: CourseDTO) {
        self.init(
            title: dto.title,
            presenterName: dto.presenter_name,
            desc: dto.description,
            thumbnailUrl: dto.thumbnail_url,
            videoUrl: dto.video_url,
            videoDuration: dto.video_duration
        )
    }
}
