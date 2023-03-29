//
//  FavouriteListViewController.swift
//  CodeContests
//
//  Created by Bektemur Mamashayev on 28/03/23.
//

import UIKit

class FavouriteListViewController: UITableViewController {
    var favouriteContests: [Contest] = []

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else {
            return
        }
        guard let contestInfoVC = navigationVC.topViewController as? ContestInfoViewController else {
            return
        }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        contestInfoVC.contest = favouriteContests[indexPath.row]
    }
}
// MARK: - Table view data source
extension FavouriteListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        favouriteContests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let contest = favouriteContests[indexPath.row]
        content.text = contest.name
        content.image = UIImage(named: contest.site)
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}


