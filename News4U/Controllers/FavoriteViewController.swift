//
//  FavoriteViewController.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var presentNews: UIButton!
    
    var showIndexPaths = false
    let cache = CacheNewsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        alert()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favoriteList.removeAll()
        updateFavorite()
        itemsFavorite.removeAll()
        getActualResult()
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func showNews(_ sender: Any) {
        if internet {
            handleShowIndexPath()
        } else {
            cache.loadData()
            tableView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    private func getActualResult() {
        itemsFavorite.removeAll()
        for i in 0..<favoriteList.count {
            let favoriteChannelURL = favoriteList[i]
            let nameChannel = favoriteChannelURL["id"] as? String ?? ""
            getResults(from: topHeadlinesFavorite(nameChannel: nameChannel)!) {
                for i in 0..<feedArticle.count {
                    itemsFavorite.append(feedArticle[i])
                    let saveDataItem = itemsFavorite[i]
                    self.cache.saveTitle.append(saveDataItem.title ?? "")
                    self.cache.saveDiscription.append(saveDataItem.description ?? "")
                }
                self.cache.saveData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func handleShowIndexPath() {
        showIndexPaths = !showIndexPaths
        if showIndexPaths {
            getActualResult()
            presentNews.setTitle("Show Article", for: .normal)
        } else {
            presentNews.setTitle("Show News", for: .normal)
        }
        tableView.reloadData()
    }
    
    private func alert() {
        if internet == false {
            let alert = UIAlertController(title: "No network connection", message: "Click to 'Show news' to watch news offline", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtn)
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - TableViewDataSource, TableViewDelegate
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0
        if internet {
            if showIndexPaths {
                row = itemsFavorite.count
            } else {
                row = favoriteList.count
            }
        } else {
            row = cache.saveTitle.count
        }
        return row
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellId")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CellId")
        }
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CellCustom") as! CustomCell
        
        if internet {
            if showIndexPaths {
                let channelFavoriteNews = itemsFavorite[indexPath.row]
                if let url = channelFavoriteNews.urlToImage {
                    if let data = NSData(contentsOf: url as URL) {
                        let image = UIImage(data: data as Data)
                        customCell.imageViewPhotoNews.image = image
                    }
                }
                let dimAlphaRedColor = UIColor.black.withAlphaComponent(0.7)
                customCell.viewPresent.backgroundColor = dimAlphaRedColor
                
                customCell.labelTitle.numberOfLines = .bitWidth
                customCell.labelTitle.text = channelFavoriteNews.title
                
                customCell.labelDescription.numberOfLines = 2
                customCell.labelDescription.text = channelFavoriteNews.description
                
                return customCell
            } else {
                let favoriteChannel = favoriteList[indexPath.row]
                cell!.textLabel?.text = favoriteChannel["Name"] as? String ?? ""
                return cell!
            }
        } else {
            cell!.textLabel?.numberOfLines = .bitWidth
            cell!.textLabel?.text = cache.saveDiscription[indexPath.row]
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = itemsFavorite[indexPath.row]
        print(article)
 
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.urlFromSegue = article.url
        vc.navigationTitle = article.source.name
        self.navigationController?.pushViewController(vc, animated: true)
        print(itemsFavorite[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var editRow = true
        if showIndexPaths {
            editRow = false
        }
        return editRow
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if showIndexPaths == false {
            if editingStyle == .delete {
                removeItem(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
    }
}
