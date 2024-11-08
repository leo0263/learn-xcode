//
//  QuipperView.swift
//  Learn Xcode
//
//  Created by Leonardi on 05/11/24.
//

import SwiftUI
import SwiftData

struct CourseView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \CourseObject.id) var courses: [CourseObject]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(courses) { course in
                    NavigationLink(destination: CourseDetailView(courseId: course.id)) {
                        HStack(alignment: .top, spacing: 10) {
                            VStack(alignment: .leading, spacing: 4) {
                                ZStack(alignment: .bottomTrailing) {
                                    if let imageData = course.thumbnailData, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 70)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray, lineWidth: 0.5)
                                            )
                                            .clipped()
                                    } else {
                                        Image(systemName: "video")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 120, height: 70)
                                            .foregroundColor(.gray)
                                            .background(Color.gray.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray, lineWidth: 0.5)
                                            )
                                    }

                                    let duration = formatDuration(milliseconds: course.videoDuration)
                                    Text(duration)
                                        .font(.system(size: 8))
                                        .foregroundColor(.white)
                                        .padding(1)
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Capsule())
                                        .padding([.bottom, .trailing], 1)
                                }
                                
                                Text(course.presenterName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(course.title)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .lineLimit(2)

                                Text(course.desc)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                                    .padding(.top, 2)
                            }
                            .padding(.leading, 5)
                        }
                        .padding(8)
                    }
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

func formatDuration(milliseconds: Int) -> String {
    let totalSeconds = milliseconds / 1000
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60

    return String(format: "%02d:%02d", minutes, seconds)
}


#Preview {
    CourseView()
}

