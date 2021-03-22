//
//  NewsAPI.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import Foundation
import UIKit

let API_KEY = "41c57f350f7341ff966ed29a99c7c100"

class NewsApi {
    
    let imageCache: NSCache<NSString, UIImage>
    var headlineRequestHelper: RequestHelper
    
    static let shared = NewsApi()
    
    init() {
        self.imageCache = NSCache<NSString, UIImage>()
        self.headlineRequestHelper = RequestHelper(pageSize: 10, page: 1, loadedResults: 0, totalResults: 0, status: .uninitialized)
    }
    
    func fetchHeadlineArticles(callback: @escaping ([Article]) -> Void) {
        
        if (!headlineRequestHelper.shouldMakeRequest()) { return }
        
        headlineRequestHelper.loadingUpdate()

        let urlString = "https://newsapi.org/v2/top-headlines?country=us&pageSize=\(headlineRequestHelper.pageSize)&page=\(headlineRequestHelper.page)&apiKey=\(API_KEY)"
                
        guard let url = URL(string: urlString) else {
            headlineRequestHelper.failureUpdate()
            callback([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let response = decodeResponse(data: data)
                    let totalResults = response?.totalResults ?? 0
                    let articles = response?.articles ?? []
                    
                    self.headlineRequestHelper.successUpdate(articleCount: articles.count, totalResults: totalResults)
                    
                    callback(articles)
                } else {
                    print("Failed to retrieve articles with error: ", error?.localizedDescription ?? "Unknown Error")
                    self.headlineRequestHelper.failureUpdate()
                    callback([])
                }
            }
        }.resume()
    }
}

func decodeArticleJSONString(jsonString: String) -> Article? {
        
    let jsonData = jsonString.data(using: .utf8)!
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    guard let article = try? decoder.decode(Article.self, from: jsonData) else { return nil }
    
    return article
}

func decodeResponse(data: Data) -> Response? {
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    var response: Response?
    
    do {
        response = try decoder.decode(Response.self, from: data)
    } catch {
        print("Failed to decode response: ", error)
    }
    
    return response
}
