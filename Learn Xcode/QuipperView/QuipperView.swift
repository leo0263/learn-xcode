//
//  QuipperView.swift
//  Learn Xcode
//
//  Created by Leonardi on 05/11/24.
//

import SwiftUI
import SwiftData

struct QuipperView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \CourseObject.id) var courses: [CourseObject]
    
    var body: some View {
        NavigationView {
            List {
                //ForEach(courses.sorted(by: {$0.id < $1.id})) { course in
                ForEach(courses) { course in
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
                }
            }
            .navigationTitle("Quipper Courses")
            .overlay {
                if courses.isEmpty {
                    VStack {
                        ProgressView("Fetching from the API...")
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.8))
                }
            }
            .task {
                if courses.isEmpty {
                    await QuipperWebService().updateDataInDatabase(modelContext: modelContext)
                }
            }
            .refreshable {
                await QuipperWebService().updateDataInDatabase(modelContext: modelContext)
            }
        }
    }
}

#Preview {
    QuipperView()
}

