//
//  ContestInfoViewController.swift
//  CodeContests
//
//  Created by Bektemur Mamashayev on 27/03/23.
//

import UIKit

final class ContestInfoViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var siteLabel: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var contest: Contest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer()
        updateUI()
    }
    
    private func updateUI() {
        nameLabel.text = contest.name
        urlLabel.text = contest.url
        startTime.text = contest.startTime
        endTime.text = contest.endTime
        siteLabel.text = contest.site
        imageView.image = UIImage(named: contest.site)
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    @IBAction func registerButtonPressed() {
        guard let url = URL(string: contest.url) else { return }
        
        UIApplication.shared.open(url)
        contest.isRegistered = true
    }
    
}
