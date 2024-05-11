//
//  BoxOfficeAPIManager.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/7/24.
//

import Foundation

class BoxOfficeAPIManager {
    static func fetchDataFromAPI(completion: @escaping ([BoxOfficeDataModel]) -> Void) {
        guard let apiKeyBoxOffice = getApiKey(keyName: "API_KEY_BOXOFFICE") else {
            print("Movie API key not found.")
            return
        }
        
        let today = Date()
        var yesterdayDateString = ""
        if let formattedDate = formatDateString(today) {
            if let yesterdayDate = subtractOneDay(from: formattedDate) {
                yesterdayDateString = yesterdayDate
                print("Yesterday's date: \(yesterdayDateString)")
            } else {
                print("Failed to subtract one day.")
                return
            }
        } else {
            print("Invalid date format.")
            return
        }
        
        let boxofficeList = "boxoffice"
        let urlString = "http://kobis.or.kr/kobisopenapi/webservice/rest/\(boxofficeList)/searchDailyBoxOfficeList.json?key=\(apiKeyBoxOffice)&targetDt=\(yesterdayDateString)"

        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let boxOfficeResult = jsonObject["boxOfficeResult"] as? [String: Any],
                           let dailyBoxOfficeList = boxOfficeResult["dailyBoxOfficeList"] as? [[String: Any]] {
                            var boxOfficeData: [BoxOfficeDataModel] = []
                            for movieData in dailyBoxOfficeList {
                                if let jsonData = try? JSONSerialization.data(withJSONObject: movieData),
                                   let movie = try? decoder.decode(BoxOfficeDataModel.self, from: jsonData) {
                                    boxOfficeData.append(movie)
                                }
                            }
                            completion(boxOfficeData)
                            print("boxOfficeDataboxOfficeDataboxOfficeData\(boxOfficeData)")
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

        guard let apiKeyBoxOffice = dict[keyName] as? String else {
            print("ApiKey '\(keyName)' not found in ApiKey.plist.")
            return nil
        }

        return apiKeyBoxOffice
    }


    static private func formatDateString(_ date: Date) -> String? {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyyMMdd"
        return outputFormatter.string(from: date)
    }

    static private func subtractOneDay(from dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMdd"

        if let date = inputFormatter.date(from: dateString) {
            if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyyMMdd"
                return outputFormatter.string(from: yesterday)
            }
        }

        return nil
    }
    
}
