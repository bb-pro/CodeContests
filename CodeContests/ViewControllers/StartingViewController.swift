//
//  ViewController.swift
//  CodeContests
//
//  Created by Bektemur Mamashayev on 27/03/23.
//

import UIKit

final class StartingViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    let url = URL(string: "https://kontests.net/api/v1/all")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

