//
//  TDDestinationCollectionViewCell.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 24/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

class TDDestinationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var backgrounView: UIView!
    
    func configureCell(region: String) {
        self.region.text = region
        
        self.backgrounView.layer.cornerRadius = 10
    }
}
