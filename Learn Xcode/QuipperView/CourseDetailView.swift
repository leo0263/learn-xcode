//
//  CourseDetailView.swift
//  Learn Xcode
//
//  Created by Leonardi on 07/11/24.
//

import SwiftUI
import SwiftData
import AVKit
import Combine

struct CourseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \CourseObject.id) var courses: [CourseObject]
    @State private var player = AVPlayer()
    
    var courseId: Int
    private var course: CourseObject? {
        courses.first { $0.id == courseId }
    }

    var body: some View {
        if let course = course, let videoUrl = URL(string: course.videoUrl) {
            VStack(alignment: .leading, spacing: 10) {
                VideoPlayerView(videoUrl: videoUrl, player: player)
                
                Text(course.title)
                    .font(.title)
                    .bold()

                Text(course.presenterName)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(course.desc)
                    .font(.body)
                    .lineLimit(nil)

                Spacer()
            }
            .padding(10)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        player.pause()
                        player.replaceCurrentItem(with: nil)
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                        Text("Quipper Courses")
                    }
                }
            }
        } else {
            Text("Course not found")
                .foregroundColor(.red)
                .navigationTitle("Error")
        }
    }
}


struct VideoPlayerView: View {
    var videoUrl: URL
    var player: AVPlayer
    @State private var isLoading = true
    @State private var hasError = false
    @State private var isInitialized = false
    
    var body: some View {
        ZStack {
            CustomPlayerView(player: player)
                .aspectRatio(16/9, contentMode: .fit)
                .onAppear {
                    if !isInitialized {
                        setupPlayer(url: videoUrl)
                    }
                }
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
                
            if hasError {
                Text("Failed to load video, check your internet connection...")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)

            }
        }
    }
    
    private func setupPlayer(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        
        playerItem.publisher(for: \.status)
            .sink { status in
                switch status {
                case .readyToPlay:
                    isLoading = false
                    hasError = false
                    isInitialized = true
                    player.replaceCurrentItem(with: playerItem)
                    player.play()
                case .failed:
                    isLoading = false
                    hasError = true
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        player.replaceCurrentItem(with: playerItem)
    }
    
    @State private var cancellables: Set<AnyCancellable> = []
}

struct CustomPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = true
        return playerViewController
    }

    func updateUIViewController(
        _ uiViewController: AVPlayerViewController,
        context: Context
    ) {
        uiViewController.player = player
    }
}

