//
//  APIManager.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

//import Foundation
//
//class MovieAPIManager {
//    static func fetchDataFromAPI(completion: @escaping ([MovieDataModel]) -> Void) {
//        guard let apiKey = getApiKey(keyName: "API_KEY_MOVIE") else {
//            print("Movie API key not found.")
//            return
//        }
//        
////        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&watch_region=KR&language=ko&page=5"
//        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchString)&language=ko&page=1"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error)")
//            } else if let data = data {
//                do {
//                    let decoder = JSONDecoder()
//                    let response = try decoder.decode(MovieApiResponse.self, from: data)
//                    completion(response.results)
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//            }
//        }.resume()
//    }
//
//    static private func getApiKey(keyName: String) -> String? {
//        guard let path = Bundle.main.path(forResource: "ApiKey", ofType: "plist") else {
//            print("ApiKey.plist not found.")
//            return nil
//        }
//
//        guard let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
//            print("Invalid format of ApiKey.plist.")
//            return nil
//        }
//
//        guard let apiKey = dict[keyName] as? String else {
//            print("ApiKey '\(keyName)' not found in ApiKey.plist.")
//            return nil
//        }
//
//        return apiKey
//    }
//}

import Foundation

class MovieAPIManager {
    static func fetchDataFromAPI(searchString: String, completion: @escaping ([MovieDataModel]) -> Void) {
        guard let apiKey = getApiKey(keyName: "API_KEY_MOVIE") else {
            print("Movie API key not found.")
            return
        }
        
        let encodedSearchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchString)&language=ko&page=1"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MovieApiResponse.self, from: data)
                    completion(response.results)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }

    static private func getApiKey(keyName: String) -> String? {
        guard let path = Bundle.main.path(forResource: "ApiKey", ofType: "plist") else {
            print("ApiKey.plist not found.")
            return nil
        }

        guard let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            print("Invalid format of ApiKey.plist.")
            return nil
        }

        guard let apiKey = dict[keyName] as? String else {
            print("ApiKey '\(keyName)' not found in ApiKey.plist.")
            return nil
        }

        return apiKey
    }
}
