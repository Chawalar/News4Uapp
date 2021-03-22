//
//  Favorite.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import Foundation

var favorite = [[String: Any]]()
var favoriteList = [[String: Any]]()

func addChannel (idChannel: String ,nameChannel: String, isFavorite: Bool = false) {
    favorite.append(["id": idChannel,"Name": nameChannel, "isFavorite": isFavorite])
}

func changeFavorite(at id: Int) -> Bool {
    favorite[id]["isFavorite"] = !(favorite[id]["isFavorite"] as! Bool)
    return favorite[id]["isFavorite"] as! Bool
}

func removeItem(at id: Int) {
    favoriteList.remove(at: id)
}

func updateFavorite() {
    for i in 0..<favorite.count {
        if (favorite[i]["isFavorite"] as? Bool) == true {
            favoriteList.append(favorite[i])
        }
    }
}

func synchronizeFavorite(at c: Int) {
    for i in 0..<favorite.count {
        favorite[i]["isFavorite"] = false
    }
    for i in 0..<favorite.count {
        for j in 0..<c {
            if favoriteList[j]["id"] as? String == favorite[i]["id"] as? String {
                favorite[i]["isFavorite"] = true
            }
        }
    }
}
