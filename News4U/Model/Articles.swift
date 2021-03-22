//
//  Articles.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import Foundation

struct NewsArticles: Codable {
    let status: String?
    let totalResults: Int?
    struct Article: Codable {
        let source: Source
        let author: String?
        let title: String?
        let description: String?
        let url: URL?
        let urlToImage: URL?
        let publishedAt: Date
        let content: String?
        
        
        struct Source: Codable {
            let id: String?
            let name: String?
        }
    }
    
    let articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}
