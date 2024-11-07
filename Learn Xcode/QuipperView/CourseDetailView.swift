//
//  CourseDetailView.swift
//  Learn Xcode
//
//  Created by Leonardi on 07/11/24.
//

import SwiftUI
import SwiftData

struct CourseDetailView: View {
    @Query(sort: \CourseObject.id) var courses: [CourseObject]
    
    var courseId: Int

    var body: some View {
        if let course = courses.first(where: { $0.id == courseId }) {
            HStack(alignment: .center) {
                if let imageData = course.thumbnailData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color.gray)
                        .frame(width: 130, height: 70)
                } else {
                    Image(systemName: "video")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color.gray)
                        .frame(width: 130, height: 70)
                }
                
                VStack(alignment: .leading) {
                    Text(course.title)
                        .font(.body)
                        .bold()
                    
                    Text(course.presenterName)
                        .font(.caption)
                        .padding(.bottom, 1)
                    
                    Text(course.desc)
                        .font(.subheadline)
                    
                    //Text(String(course.video_duration))
                }
            }
            .padding(3)
        } else {
            Text("Course not found")
                .foregroundColor(.red)
                .navigationTitle("Error")
        }
    }
}
