//
//  TabBarViewController.swift
//  CodeContests
//
//  Created by Bektemur Mamashayev on 28/03/23.
//

import UIKit

final class TabBarViewController: UITabBarController, ContestListViewControllerDelegate {
    
    func sendDataToFavourites(data: [Contest]) {
        if let secondVC = viewControllers?[1] as? UINavigationController {
            if let favouritesVC = secondVC.topViewController as? FavouriteListViewController {
                favouritesVC.favouriteContests = data
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let firstVC = viewControllers?.first as? UINavigationController {
            if let contestListVC = firstVC.topViewController as? ContestListViewController  {
                contestListVC.delegate = self
            }
        }
    }
    
}
