//
//  ChannelViewController.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import UIKit

class ChannelViewController: UIViewController {

    var articles = [Article]()
    var filteredAtricles = [Article]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadChannelList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        synchronizeFavorite(at: favoriteList.count)
        tableView.reloadData()
    }

    
    // MARK: - Loading list of channels
    private func loadChannelList() {
        getResults(from: allChannelNews()!) {
            DispatchQueue.main.async {
                for i in 0..<feedSource.count {
                    items.append(feedSource[i])
                }
                for i in 0..<items.count{
                    let channelName = items[i]
                    addChannel(idChannel: channelName.id ?? "" ,nameChannel: channelName.name ?? "")
                }
                self.tableView.reloadData()
            }
        }
    }
}


// MARK: - TableViewDataSource, TableViewDelegate
extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        }
        
        let chanel = items[indexPath.row]
        cell!.textLabel?.text = chanel.name
        cell!.detailTextLabel?.numberOfLines = .bitWidth
        cell!.detailTextLabel?.text = chanel.description
        
        let favoriteChannel = favorite[indexPath.row]
        if favoriteChannel["isFavorite"] as? Bool == true {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let article = self.filteredAtricles[indexPath.row]
//        print(article)
//        print(filteredAtricles)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
//        vc.urlFromSegue = URL(string: article.url ?? "")
//        vc.navigationTitle = article.source?.name
//        self.navigationController?.pushViewController(vc, animated: true)
       
        
        tableView.deselectRow(at: indexPath, animated: true)
        if changeFavorite(at: indexPath.row) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
}

