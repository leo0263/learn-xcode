//
//  QuipperView.swift
//  Learn Xcode
//
//  Created by Leonardi on 05/11/24.
//

import SwiftUI
import SwiftData

struct QuipperView: View {
    @Environment(\.modelContext) var context
    @StateObject var viewModel = QuipperViewModel()
    @Query(sort: \CourseModel.videoUrl) var courses: [CourseModel]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(courses) { course in
                    HStack(alignment: .center) {
                        AsyncImage(url: URL(string: course.thumbnailUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .background(Color.gray)
                        } placeholder: {
                            Image(systemName: "video")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .background(Color.gray)
                        }
                        .frame(width: 130, height: 70)

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
            .onAppear {
                viewModel.initialize(context: context)
                viewModel.fetch()
                print("onAppear!!!")
            }
        }
    }
}

#Preview {
    QuipperView()
}

