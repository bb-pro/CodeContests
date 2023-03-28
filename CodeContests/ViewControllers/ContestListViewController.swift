//
//  ContestListViewController.swift
//  CodeContests
//
//  Created by Bektemur Mamashayev on 27/03/23.
//

import UIKit

final class ContestListViewController: UITableViewController {
    private let url = URL(string: "https://kontests.net/api/v1/all")!
    private let networkManager = NetworkManager.shared
    private var contests: [Contest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}


// MARK: - Table view data source
extension ContestListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        contests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contestCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let contest = contests[indexPath.row]
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
        
        let love = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [love])
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
