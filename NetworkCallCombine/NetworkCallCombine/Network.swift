//
//  Network.swift
//  NetworkCallCombine
//
//  Created by Jeann Luiz on 25/08/23.
//

import Combine
import Foundation

let apiKey = "e64f646c07736c13074da386282feaca"

func fetchMovies() -> some Publisher<MovieResponse, Error> {
    let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)")!
        
    // Option 1
//    return URLSession
//        .shared
//        .dataTaskPublisher(for: url)
//        .map(\.data)
//        .print()
//        .decode(type: MovieResponse.self, decoder: jsonDecoder)
//        //.eraseToAnyPublisher()
    
    // Option 2: We can use tryMap to a more complex decoding and adding an error handler.
    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .print()
        .tryMap { data in
            let decoded = try jsonDecoder.decode(MovieResponse.self, from: data)
            return decoded
        }
}

func searchMovies(for query: String) -> some Publisher<MovieResponse, Error> {
    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encodedQuery!)")!
    
    return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .print()
            .decode(type: MovieResponse.self, decoder: jsonDecoder)
}
