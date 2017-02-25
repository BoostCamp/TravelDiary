//
//  TDFilterViewController.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 24/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
protocol TDFilterViewControllerDelegate {
    func setFilter(selectedRegion: String)
}

class TDFilterViewController: UITableViewController {

    var selectedRegion: String!
    var delegate: TDFilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 7
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.selectedRegion = "all"
            } else {
                let region = RegionList(rawValue: indexPath.row - 1)?.convertRegion()
            
                self.selectedRegion = region!
            }
        }
    }
    
    @IBAction func save() {
        self.delegate?.setFilter(selectedRegion: selectedRegion)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
