//
//  StructManager.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/7/24.
//

import Foundation

struct MovieDataModel: Decodable {
    let originalTitle: String
    let title: String
    let overview: String
    let id: Int64
    let posterPath: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case title
        case overview
        case id
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}

struct BoxOfficeDataModel: Decodable {
    let rank: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let salesAmt: String
    let audiCnt: String
}

struct APIMovieDataModel: Decodable {
    let movieCd: String
    let movieNm: String
    let movieNmEn: String
    let prdtYear: String?
    let openDt: String?
    let typeNm: String
    let prdtStatNm: String
    let nationAlt: String
    let genreAlt: String
    let repNationNm: String
    let repGenreNm: String
    let rank: String?
    let salesAmt: String?
    let audiCnt: String?
}

struct MovieApiResponse: Decodable {
    let results: [MovieDataModel]
}

struct BoxOfficeApiResponse: Decodable {
    let results: [APIMovieDataModel]
}

struct CommingSoonApiResponse: Decodable {
    let results: [APIMovieDataModel]
}
