//
//  ContestListViewController.swift
//  CodeContests
//
//  Created by Bektemur Mamashayev on 27/03/23.
//

import UIKit

protocol ContestListViewControllerDelegate: AnyObject {
    func sendDataToFavourites(data: [Contest])
}

final class ContestListViewController: UITableViewController {
    
    
    private let url = URL(string: "https://kontests.net/api/v1/all")!
    private let networkManager = NetworkManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    private var contests: [Contest] = []
    private var contest: Contest?
    private var favourites: [Contest] = []
    private var filteredContests: [Contest] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    weak var delegate: ContestListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fetchContest()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contestInfoVC = segue.destination as? ContestInfoViewController else {
            return
        }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        contestInfoVC.contest = contests[indexPath.row]
    }
    // MARK: - Private methods
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .black
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }

}

// MARK: - UISearchResultsUpdating
extension ContestListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredContests = contests.filter { character in
            character.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}


// MARK: - Table view data source
extension ContestListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        isFiltering ? filteredContests.count : contests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contestCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let contest = isFiltering
            ? filteredContests[indexPath.row]
            : contests[indexPath.row]
        contests[indexPath.row]
        content.text = contest.name
        content.image = UIImage(named: contest.site)
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favourite = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [favourite])
    }
    
    func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = contests[indexPath.row]
        let action  = UIContextualAction(style: .normal, title: "Like") { (action, view, completion) in
            object.isFavourite = !object.isFavourite
            self.contests[indexPath.row] = object
            completion (true)
        }
        action.backgroundColor = object.isFavourite ? .systemPurple : .systemGray
        action.image = UIImage(systemName: "heart")
        return action
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let contestCell = contests.remove(at: sourceIndexPath.row)
        contests.insert(contestCell, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        contests.forEach { contest in
            if contest.isFavourite && !favourites.contains(where: { $0.isFavourite }) {
                favourites.append(contest)
            }
        }
        delegate?.sendDataToFavourites(data: favourites)
    }
    
}


//MARK: - UITableViewDelegate
extension ContestListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - Networking
private extension ContestListViewController {
    func fetchContest() {
        NetworkManager.shared.fetchContests(from: url) { [weak self] result in
            switch result {
            case .success(let contests):
                self?.contests = contests
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
