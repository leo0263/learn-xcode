//
//  QuipperViewModel.swift
//  Learn Xcode
//
//  Created by Leonardi on 05/11/24.
//

import Foundation
import SwiftData

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

class QuipperWebService {
    @MainActor
    func updateDataInDatabase(modelContext: ModelContext) async {
        do {
            let courses: [CourseDTO] = try await fetchData(urlStr: "https://quipper.github.io/native-technical-exam/playlist.json")
            for (courseIndex, course) in courses.enumerated() {
                let courseObject = CourseObject(dto: course, index: courseIndex)
                modelContext.insert(courseObject)
                print(String(courseIndex) + ": " + course.video_url)
            }
            try modelContext.save()
        } catch {
            print("Error fetching data")
        }
    }
    
    private func fetchData<T: Codable>(urlStr: String) async throws -> [T] {
        guard let fetchedData: [T] = await QuipperWebService().downloadData(urlStr: urlStr)  else {return []}
        return fetchedData
    }
    
    private func downloadData<T: Codable>(urlStr: String) async -> T? {
        do {
            guard let url = URL(string: urlStr) else { throw NetworkError.badUrl }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            
            return decodedResponse
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        } catch {
            print("An error occured downloading the data")
        }
        
        return nil
    }
}
