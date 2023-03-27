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
    
}

//MARK: - UITableViewDelegate
extension ContestListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

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
