//
//  TDTableHeaderView.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 26/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
protocol TDHeaderViewDelegate {
    func collapseCell(section: Int)
    func newDiaryFor(section: Int)
    func editDestinationFor(section: Int)
    func deleteDestinationFor(section: Int)
    func showMapFor(section: Int)
}

class TDTableHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var arrivalDateLable: UILabel!
    @IBOutlet weak var showCellButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var widthForMoreButton: NSLayoutConstraint!
    @IBOutlet weak var backgroundCardView: UIView!
    
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var headerContentView: UIView!
    
    var delegate: TDHeaderViewDelegate?
    var section: Int!
    var isMoreButtonClicked: Bool = false
    var destination: Destination!
    var photos: [UIImage] = []
    
    func configureView(destination: Destination, section: Int, state: Bool) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
        self.setUI()
        
        self.section = section
        self.destination = destination
        let destinationName = self.destination.getDestinationName()
        let departureDate = self.destination.getDepartureDate()
        let arrivalDate = self.destination.getArrivalDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        
        self.destinationLabel?.text = destinationName
        self.departureDateLabel?.text = dateFormatter.string(from: departureDate)
        self.arrivalDateLable?.text = dateFormatter.string(from: arrivalDate)
        
        self.setShowCellButton(state: state)
    }
    
    func setShowCellButton(state: Bool) {
        if !state {
            let image = UIImage(named: "caret-down")
            self.showCellButton?.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "caret-arrow-up")
            self.showCellButton?.setImage(image, for: .normal)
        }
    }
}

// MARK: - Actions
extension TDTableHeaderView {
    
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? TDTableHeaderView else {
            return
        }
        
        self.delegate?.collapseCell(section: self.section)
    }
    
    @IBAction func editDestination() {
        self.delegate?.editDestinationFor(section: self.section)
    }
    
    @IBAction func newDiaryButtonTapped() {
        self.delegate?.newDiaryFor(section: self.section)
    }
    
    @IBAction func deleteDestinationButtonTapped() {
        self.delegate?.deleteDestinationFor(section: self.section)
    }
    
    @IBAction func showMapButtonTapped() {
        self.delegate?.showMapFor(section: self.section)
    }
    
    @IBAction func moreButtonTapped() {
        if self.isMoreButtonClicked {
            self.widthForMoreButton.constant = 0
            self.isMoreButtonClicked = false
        } else {
            self.widthForMoreButton.constant = 200
            self.isMoreButtonClicked = true
        }
    }
}

extension TDTableHeaderView {
    func setUI() {
        self.backgroundCardView.layer.cornerRadius = 3
        self.backgroundCardView.layer.masksToBounds = false
        self.backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCardView.layer.shadowOpacity = 0.8
        
        self.headerContentView.backgroundColor = UIColor(red: 240/255.5, green: 240/255.5, blue: 240/255.5, alpha: 1)
        
        self.moreButton.layer.cornerRadius = 4
        self.showCellButton.layer.cornerRadius = 4
        self.buttonContainerView.layer.cornerRadius = 4
    }
}
