//
//  TDTableViewController.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 07/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class TDTableViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tdTableView: UITableView!
    
    
    // MARK: - Properties
    let realm = try! Realm()
    var filteredDestination: Results<Destination>!
    var region: String!
    var section: Int = -1
    var state = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Destination.shared = self.realm.objects(Destination.self)
        self.filteredDestination = Destination.shared
        Destination.filterd = self.filteredDestination
        
        let isCreatedImageFolder = UserDefaults.standard.value(forKey: "createImagesDirectory")
        if isCreatedImageFolder as! Bool {
            print("ImagesFolder already created.")
        } else {
            self.createImagesDirectory()
            print("Make ImagesFolder")
            UserDefaults.standard.set(true, forKey: "createImagesDirectory")
        }
        
        // Do any additional setup after loading the view.
        print(NSHomeDirectory())
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tdTableView.register(UINib(nibName: "TDTableHeaderViewCell", bundle: nil), forCellReuseIdentifier: "TDTableHeaderViewCell")
        
        self.tdTableView.reloadData()
        self.checkSectionCount()
    }
}


// MARK: - Extensions
// Did Load Check Data
extension TDTableViewController {
    func createImagesDirectory() { // 처음 시작하면 폴더 만들기
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Images")
        
        try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        
        print("createDirectory : \(paths)")
    }
    
    func checkSectionCount() {
        var count = 0
        if let destinations = Destination.shared {
            count = destinations.count
        }
        
        if count == 0 {
            let actionSheet = UIAlertController(title: "여행 기록이 없습니다.", message: "여행 기록을 추가 하시겠습니까?", preferredStyle: .actionSheet)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default) { (alertAction) in
                self.newDestination(section: nil)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(okayAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true, completion: nil)
        }
    }
}


// MARK: - Actions
extension TDTableViewController {
    
    @IBAction func makeNewDiary(_ sender: Any) {
        self.newDestination(section: nil)
    }
    
    @IBAction func setFilter(_ sender: Any) {
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "TDFilterViewController") as! TDFilterViewController
        filterVC.delegate = self
        
        self.present(filterVC, animated: true, completion: nil)
    }
    
    func newDestination(section: Int?) {
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "TDEditDestinationViewController") as! TDEditDestinationViewController
        
        destinationVC.delegate = self
        
        destinationVC.section = section
        
        self.present(destinationVC, animated: false, completion: nil)
    }
}

// MARK: - TDEditDestinationViewControllerDelegate, TDEditDiaryViewControllerDelegate
// 데이터(목적지 데이터, 목적지별 일기) 세이브 후 테이블 뷰 리로드
extension TDTableViewController: TDEditDestinationViewControllerDelegate, TDEditDiaryViewControllerDelegate {
    
    func didSaveDestination() {
        self.tdTableView.reloadData()
    }
    
    func changedData() {
        self.tdTableView.reloadData()
    }
}

// MARK: - TDTableHeaderViewCellDelegate
// 헤더에서 버튼 요청을 받아 작업
extension TDTableViewController: TDTableHeaderViewCellDelegate {
    func showCell(header: TDTableHeaderViewCell, section: Int, state: Bool) {
        
        self.section = section
        self.state = state
        
//        self.tdTableView.reloadData()
        self.tdTableView.beginUpdates()
//        for row in 0 ..< self.filteredDestination[section].diaries.count {
//            self.tdTableView.reloadRows(at: [IndexPath(row: row, section: self.section)], with: .automatic)
//        }
        self.tdTableView.reloadData()
        self.tdTableView.endUpdates()
        
        header.isShowCellButtonClicked = !header.isShowCellButtonClicked
        print("Show Cell \(header.isShowCellButtonClicked)")
    }
    
    func editDestinationFor(section: Int) {
        self.newDestination(section: section)
    }
    
    func newDiaryFor(section: Int) {
        let editDiaryVC = self.storyboard!.instantiateViewController(withIdentifier: "TDEditDiaryViewController") as! TDEditDiaryViewController
        editDiaryVC.section = section
        editDiaryVC.delegate = self
        
        self.present(editDiaryVC, animated: true, completion: nil)
    }
    
    func deleteDestinationFor(section: Int) {
        let destination = self.filteredDestination[section]
        let diaries = destination.getDiaries()
            
        try! self.realm .write {
            for diary in diaries {
                self.realm.delete(diary.dirPathForPhotos)
            }
            
            self.realm.delete(diaries)
            self.realm.delete(destination)
        }
        
        Destination.shared = self.realm.objects(Destination.self)
        self.filteredDestination = Destination.shared.filter("destinationName = %@", "\(region)")
        Destination.filterd = self.filteredDestination
        
        self.tdTableView.reloadData()
        
    }
    
    func showMapFor(section: Int) {
        let tdMapVC = self.storyboard?.instantiateViewController(withIdentifier: "TDMapViewController") as! TDMapViewController
        tdMapVC.section = section
        
        self.navigationController?.pushViewController(tdMapVC, animated: true)
    }
}

// MARK: - TableView
extension TDTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let destinations = self.filteredDestination {
            return destinations.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "TDTableHeaderViewCell") as! TDTableHeaderViewCell  // -> 재사용
        
        let destination = self.filteredDestination[section]
        headerView.configureCell(destination: destination)
        headerView.section = section
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == self.section {
            return self.state ? 115 : 0
        } else {
            return 115
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let row = self.filteredDestination[section].getDirayCount()
        
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TDTableViewCell!
        
        let diary = self.filteredDestination[indexPath.section].getDiary(at: indexPath.row)

        cell = tableView.dequeueReusableCell(withIdentifier: "TDTableViewCell", for: indexPath) as! TDTableViewCell
        cell.configureCell(diary: diary!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.alpha = 0
        
        UIView.animate(withDuration: 1) { 
            cell.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tdDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "TDDetailViewController") as! TDDetailViewController
        
        tdDetailVC.indexPath = indexPath
        
        self.navigationController?.pushViewController(tdDetailVC, animated: true)
    }
}

// MARK: - TDFilterViewController Delegate
extension TDTableViewController: TDFilterViewControllerDelegate {
    func setFilter(selectedRegion: String) {
        if selectedRegion == "all" {
            self.filteredDestination = Destination.shared
            Destination.filterd = self.filteredDestination

        } else {
            self.region = selectedRegion
            self.filteredDestination = Destination.shared.filter("destinationName = %@", "\(region!)")
            Destination.filterd = self.filteredDestination
            
            self.tdTableView.reloadData()
        }
    }
}

