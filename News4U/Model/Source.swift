//
//  Source.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import Foundation

struct NewsSource: Codable {
let status: String?
struct Source: Codable {
    let id: String?
    let name: String?
    let description: String?
    let url: URL?
    let category: String?
    let language: String?
    let country: String?
}

let sources: [Source]

private enum CodingKeys: String, CodingKey {
    case status
    case sources
}
}
