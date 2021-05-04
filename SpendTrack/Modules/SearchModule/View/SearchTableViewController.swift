//
//  SearchTableViewController.swift
//  SpendTrack
//
//  Created by Клим on 24.04.2021.
//

import UIKit

protocol SearchViewProtocol: UIViewController{
    func updateUI()
    var resultsTableViewController: SearchItemsViewController {get}
}

class SearchTableViewController: UITableViewController {
    
    var presenter: SearchPresenterProtocol!
    var searchController: UISearchController!
    var resultsTableController: SearchItemsViewController!
    var currentTableAnimation: TableAnimation = .moveUpWithFade(rowHeight: 72.0, duration: 0.85, delay: 0.03)
    private var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .white
        setupSpinner(spinner: activityIndicator)
        setupSearchBar()
        presenter.loadRecentSearches()
    }
    
    private func setupSpinner(spinner: UIActivityIndicatorView) {
            spinner.hidesWhenStopped = true
            spinner.style = .medium
            spinner.color = .systemYellow
            spinner.frame = view.bounds
            spinner.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(activityIndicator)
        }
    
    private func setupSearchBar(){
        resultsTableController = SearchItemsViewController()
        resultsTableController.suggestedSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchBar.placeholder = "Искать в Google Market"
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        //tableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = searchController
    }
    
    func setToSuggestedSearches() {
        resultsTableController.showSuggestedSearches = true
        resultsTableController.tableView.delegate = resultsTableController
    }
    
    func saveRecentSearch(query: String){
       resultsTableController.updateSearchTable(newSearch: query)
        presenter.saveRecentSearch(query: resultsTableController.suggestedSearches.joined(separator: ", "))
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sender: sender)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getDataCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.identifier, for: indexPath) as! SearchViewCell
        presenter.prepareCell(cell: cell, index: indexPath.row)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let animation = currentTableAnimation.getAnimation()
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 200
      }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailPurchase", sender: presenter.getIndexData(index: indexPath.row))
    }

}

extension SearchTableViewController: SearchViewProtocol{
    var resultsTableViewController: SearchItemsViewController {
        get{ resultsTableController }
    }
    
    func updateUI() {
        tableView.reloadData()
        tableView.separatorColor = .black
        activityIndicator.stopAnimating()
    }
}

extension SearchTableViewController: SuggestedSearch{
    func didSelectSuggestedSearch(word: String) {
        let searchField = searchController.searchBar
        if (searchField.text == word){
           searchController.dismiss(animated: true, completion: nil)
           resultsTableController.showSuggestedSearches = false
           return
       }
        searchField.text = word
        activityIndicator.startAnimating()
        presenter.loadItems(query: word)
        searchController.dismiss(animated: true, completion: nil)
        resultsTableController.showSuggestedSearches = false
    }
}

extension SearchTableViewController: UISearchControllerDelegate{
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        setToSuggestedSearches()
    }
}

extension SearchTableViewController: UISearchBarDelegate{
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.count >= 2 else{
            return
        }
        presenter.loadItems(query: query)
        saveRecentSearch(query: query)
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            // Text is empty, show suggested searches again.
            setToSuggestedSearches()
        } else {
            resultsTableController.showSuggestedSearches = false
        }
    }
}
