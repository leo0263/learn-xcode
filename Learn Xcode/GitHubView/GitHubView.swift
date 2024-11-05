//
//  ContentView.swift
//  Learn Xcode
//
//  Created by Leonardi on 05/11/24.
//

import SwiftUI

struct GitHubView: View {
    
    @State private var user: GitHubUser?
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 120, height: 120)
            
            VStack(alignment: .leading) {
                Text(user?.login ?? "Login placeHolder")
                    .bold()
                    .font(.title3)
                    .padding(.top, 10)
                
                Text(user?.bio ?? "Bio placeHolder")
                    .padding(.top, 1)
            }
            Spacer()
        }
        .padding()
        .task {
            do {
                user = try await getGitHubUser()
            } catch GitHubError.invalidURL {
                print("Invalid URL")
            } catch GitHubError.invalidResponse {
                print("Invalid response")
            } catch GitHubError.invalidData {
                print("Invalid data")
            } catch {
                print("Unexpected error!")
            }
        }
    }
    
    func getGitHubUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/leo0263"
        guard let url = URL(string: endpoint) else {
            throw GitHubError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let respose = response as? HTTPURLResponse, respose.statusCode == 200 else {
            throw GitHubError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GitHubError.invalidData
        }
    }
}

#Preview {
    GitHubView()
}

struct GitHubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}

enum GitHubError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
