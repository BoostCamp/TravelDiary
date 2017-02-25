//
//  TDDetailViewController.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 07/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
import RealmSwift

class TDDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tdCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: - Properties
    var tdImages = [UIImage]()
    var indexPath: IndexPath!
    var diaries = List<Diary>()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentSize = self.tdCollectionView.bounds.size
        let offset = CGFloat(self.indexPath.row) * currentSize.width
        let point = CGPoint(x: offset, y: 0)
        self.tdCollectionView.setContentOffset(point, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
}


// MARK: - Extensions
// MARK: - Actions
extension TDDetailViewController {
    @IBAction func shareTD(_ sender: AnyObject) {
        
    }
    
    @IBAction func modifyTD(_ sender: AnyObject) {
        let editDiaryVC = self.storyboard?.instantiateViewController(withIdentifier: "TDEditDiaryViewController") as! TDEditDiaryViewController
        editDiaryVC.delegate = self
        
        if let centerCellIndexPath: NSIndexPath  = self.tdCollectionView.centerCellIndexPath {
            editDiaryVC.section = self.indexPath.section
            editDiaryVC.row = centerCellIndexPath.row
        }
        
        self.present(editDiaryVC, animated: false, completion: nil)
    }
    
    @IBAction func deleteTD(_ sender: AnyObject) {
        if let centerCellIndexPath: NSIndexPath  = self.tdCollectionView.centerCellIndexPath {
            let destination = Destination.shared[self.indexPath.section]
            let diary = destination.getDiary(at: centerCellIndexPath.row)
            try! realm.write {
                destination.deleteDiary(at: centerCellIndexPath.row)
                realm.delete(diary!)
            }
            
            if Destination.shared[centerCellIndexPath.section].getDirayCount() == 0 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.tdCollectionView.reloadData()
            }
        }
    }
}


extension TDDetailViewController: TDDetailViewCellDelegate, TDEditDiaryViewControllerDelegate {
    func showPhotos(photos: [UIImage]?) {
        
        let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "TDImageViewController") as! TDImageViewController
        
        imageVC.tdImages = photos!
        
        self.navigationController?.pushViewController(imageVC, animated: true)
    }
    
    func changedData() {
        self.tdCollectionView.reloadData()
    }
    
    func setupFlowLayout() {
        self.flowLayout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
}

// MARK: - CollectionView
extension TDDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = self.indexPath.section
        
        self.diaries = Destination.shared[section].getDiaries()
        
        var count = 0
        
        count = self.diaries.count
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDDetailViewCell", for: indexPath) as! TDDetailViewCell
        cell.delegate = self
        
        let diary = self.diaries[indexPath.row]
        
        cell.setCell(diary: diary)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height - 150)
    }
    
    
}

