//
//  Network.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import Foundation

var everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
var sourcesUrl = URLComponents(string: "https://newsapi.org/v2/sources?")

//MARK: - API Parametrs
//let search = URLQueryItem(name: "q", value: "Yours text for seaching")
//let fromDate = URLQueryItem(name: "from", value: "Yours Data")
//let toDate = URLQueryItem(name: "to", value: "Yours Data")
//let sortBy = URLQueryItem(name: "sortBy", value: SortOptions.publishedAt.rawValue)
let language = URLQueryItem(name: "language", value: "en")
//let country = URLQueryItem(name: "country", value: "us")

let secretAPIKey = URLQueryItem(name: "apiKey", value: "41c57f350f7341ff966ed29a99c7c100")

//check URL
var switchId: Int = 0
//check Internet connection
var internet: Bool = false

//MARK: - Funcion of get URL
func allChannelNews() -> URL? {
    switchId = 1
    sourcesUrl?.queryItems?.append(language)
    sourcesUrl?.queryItems?.append(secretAPIKey)
    return sourcesUrl?.url
}

func topHeadlinesFavorite(nameChannel: String) -> URL? {
    switchId = 2
    var endURL = everythingUrl
    let sourcesName = URLQueryItem(name: "sources", value: nameChannel)
    endURL?.queryItems?.append(sourcesName)
    endURL?.queryItems?.append(secretAPIKey)
    return endURL?.url
}

func evrythingSearch (textSearch: String) -> URL? {
    switchId = 3
    var endURL = everythingUrl
    let search = URLQueryItem(name: "q", value: textSearch)
    endURL?.queryItems?.append(search)
    endURL?.queryItems?.append(secretAPIKey)
    return endURL?.url
}

//MARK: - Object

var feedSource: [NewsSource.Source] = []
var items: [NewsSource.Source] = []
var itemsFavorite = [NewsArticles.Article]()
var feedArticleSearch: [NewsArticles.Article] = []
var feedArticle: [NewsArticles.Article] = []

var errorMessage = ""
let decoder = JSONDecoder()

//MARK: - Network
func getResults(from url: URL, completion: @escaping () -> ()) {
    URLSession.shared.dataTask(with: url) { (data, response, error ) in
        guard let data = data else { return }
        if error == nil {
            internet = true
        }
        switch switchId {
        case 1:
            updateResults(data)
        case 2:
            updateResultsFavorite(data)
        case 3:
            updateResultsSearch(data)
        default:
            break
        }
        completion()
        }.resume()
}

fileprivate func updateResults(_ data: Data) {
    decoder.dateDecodingStrategy = .iso8601
    feedSource.removeAll()
    do {
        let rawFeed = try decoder.decode(NewsSource.self, from: data)
        feedSource = rawFeed.sources
    } catch let decodeError as NSError {
        errorMessage += "Decoder error: \(decodeError.localizedDescription)"
        return
    }
}

fileprivate func updateResultsFavorite(_ data: Data) {
    decoder.dateDecodingStrategy = .iso8601
    feedArticle.removeAll()
    do {
        let rawFeed = try decoder.decode(NewsArticles.self, from: data)
        feedArticle = rawFeed.articles
    } catch let decodeError as NSError {
        errorMessage += "Decoder error: \(decodeError.localizedDescription)"
        return
    }
}

fileprivate func updateResultsSearch(_ data: Data) {
    decoder.dateDecodingStrategy = .iso8601
    feedArticleSearch.removeAll()
    do {
        let rawFeed = try decoder.decode(NewsArticles.self, from: data)
        feedArticleSearch = rawFeed.articles
    } catch let decodeError as NSError {
        errorMessage += "Decoder error: \(decodeError.localizedDescription)"
        return
    }
}
