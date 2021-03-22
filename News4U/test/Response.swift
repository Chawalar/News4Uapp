//
//  Response.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import Foundation

class Response: Codable {
    let totalResults: Int
    let articles: [Article]
}
