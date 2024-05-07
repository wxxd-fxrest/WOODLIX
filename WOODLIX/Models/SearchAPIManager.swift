//
//  SearchAPIManager.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/8/24.
//

import Foundation

class SearchAPIManager {
    static func fetchDataFromAPI(searchString: String, completion: @escaping ([SearchDataModel]) -> Void) {
        guard let apiKeySearch = getApiKey(keyName: "API_KEY_BOXOFFICE") else {
            print("Movie API key not found.")
            return
        }
        
        let searchList = "movie"
        let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/\(searchList)/searchMovieList.json?key=\(apiKeySearch)&movieNm=\(searchString)"

        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
          
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let movieListResult = jsonObject["movieListResult"] as? [String: Any],
                           let movieList = movieListResult["movieList"] as? [[String: Any]] {
                            var searchData: [SearchDataModel] = []
                            for movieData in movieList {
                                if let jsonData = try? JSONSerialization.data(withJSONObject: movieData),
                                   let movie = try? decoder.decode(SearchDataModel.self, from: jsonData) {
                                    searchData.append(movie)
                                    print("searchDatasearchDatasearchDatasearchData\(searchData)")
                                }
                            }
                            completion(searchData) 
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

    static private func getApiKey(keyName: String) -> String? {
        guard let path = Bundle.main.path(forResource: "ApiKey", ofType: "plist") else {
            print("ApiKey.plist not found.")
            return nil
        }

        guard let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            print("Invalid format of ApiKey.plist.")
            return nil
        }

        guard let apiKeySearch = dict[keyName] as? String else {
            print("ApiKey '\(keyName)' not found in ApiKey.plist.")
            return nil
        }

        return apiKeySearch
    }
}
