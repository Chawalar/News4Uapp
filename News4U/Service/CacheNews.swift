//
//  CacheNews.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import Foundation

final class CacheNewsService {
    var saveTitle = [String]()
    var saveDiscription = [String]()
    
    func cleanData() {
        saveTitle = []
        saveDiscription = []
    }
    
    func saveData() {
        UserDefaults.standard.set(saveTitle, forKey: "title")
        UserDefaults.standard.set(saveDiscription, forKey: "discription")
        UserDefaults.standard.synchronize()
    }
    
    func loadData() {
        if let t = UserDefaults.standard.array(forKey: "title") as? [String] {
            saveTitle = t
        } else {
            saveTitle = []
        }
        if let d = UserDefaults.standard.array(forKey: "discription") as? [String] {
            saveDiscription = d
        } else {
            saveDiscription = []
        }
    }
}
