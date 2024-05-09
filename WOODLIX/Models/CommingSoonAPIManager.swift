//
//  CommingSoonAPIManager.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/7/24.
//

import Foundation

class CommingSoonAPIManager {
    static func fetchDataFromAPI(completion: @escaping ([CommingSoonDataModel]) -> Void) {
        guard let apiKeyBoxOffice = getApiKey(keyName: "API_KEY_BOXOFFICE") else {
            print("Movie API key not found.")
            return
        }
        
        let boxofficeList = "movie"
        
        var allCommingSoonData: [CommingSoonDataModel] = []
        
        let group = DispatchGroup()
        
        for curPage in 1...10 {
            let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/\(boxofficeList)/searchMovieList.json?key=\(apiKeyBoxOffice)&curPage=\(curPage)"
            
            if let url = URL(string: urlString) {
                group.enter()
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    defer {
                        group.leave()
                    }
                    if let error = error {
                        print("Error: \(error)")
                    } else if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let movieListResult = jsonObject["movieListResult"] as? [String: Any],
                               let movieList = movieListResult["movieList"] as? [[String: Any]] {
                                var commingSoonData: [CommingSoonDataModel] = []
                                for movieData in movieList {
                                    if let jsonData = try? JSONSerialization.data(withJSONObject: movieData),
                                       let movie = try? decoder.decode(CommingSoonDataModel.self, from: jsonData) {
                                        commingSoonData.append(movie)
                                    }
                                }
                                
                                allCommingSoonData += commingSoonData
                            } else {
                                print("Box office data not found in JSON response")
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }.resume()
            } else {
                print("Invalid URL")
            }
        }
        
        group.notify(queue: .main) {
            completion(allCommingSoonData)
//            print("allCommingSoonData: \(allCommingSoonData)")
        }
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

        guard let apiKeyBoxOffice = dict[keyName] as? String else {
            print("ApiKey '\(keyName)' not found in ApiKey.plist.")
            return nil
        }

        return apiKeyBoxOffice
    }
}
