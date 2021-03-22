//
//  SearchViewController.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import UIKit
import Network

class SearchViewController: UIViewController {

    @IBOutlet weak var tableViewSearch: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tapDismiss: UITapGestureRecognizer!
    
    
    //test
    var articles = [Article]()
    var filteredAtricles = [Article]()
    //
    var textSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favoriteList.removeAll()
        updateFavorite()
    }
    
    // MARK: - IBActions
    @IBAction func tap(_ sender: Any) {
        dismissKeyboard()
    }
    
    // MARK: - Private Methods
    private func getResultSearching() {
        getResults(from: evrythingSearch(textSearch: textSearch)!) {
            DispatchQueue.main.async {
                self.tableViewSearch.reloadData()
            }
        }
    }
    
    private func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
}

// MARK: - TableViewDataSource, TableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArticleSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellSearch")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CellSearch")
        }
        let searchItem = feedArticleSearch[indexPath.row]
        cell!.textLabel?.numberOfLines = .bitWidth
        cell!.textLabel?.text = searchItem.title
        
        cell!.detailTextLabel?.numberOfLines = .bitWidth
        cell!.detailTextLabel?.text = searchItem.description
        
        return cell!
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //test
        print("1")
        let article = self.filteredAtricles[indexPath.row]
        print(article)
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.urlFromSegue = URL(string: article.url ?? "")
        vc.navigationTitle = article.source?.name
        DispatchQueue.main.async(execute: {
           self.present(vc, animated: true, completion: nil)
        })
        self.navigationController?.pushViewController(vc, animated: true)
        print("done")
        //
        tableView.deselectRow(at: indexPath, animated: true)
        dismissKeyboard()
    }
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        textSearch = searchBar.text ?? ""
        getResultSearching()
        dismissKeyboard()
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

