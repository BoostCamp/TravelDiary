//
//  TDEditDiaryViewController.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 07/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
import RealmSwift

protocol TDEditDiaryViewControllerDelegate {
    func changedData()
}

class TDEditDiaryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var editContainerView: UIView!
    
    // MARK: - Properties
    var tdEditContainerVC: TDEditContainerViewController!
    
    var diary: Diary!
    var section: Int!
    var row: Int?
    
    var delegate: TDEditDiaryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEditContainer()
        self.initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
}


// MARK: - Extensions
// MARK: - Actions
extension TDEditDiaryViewController {
    @IBAction func saveTD(_ sender: Any) {
        let title = self.tdEditContainerVC.tdTitle.text
        let date: Date = self.tdEditContainerVC.nowDate
        
        let photos = self.tdEditContainerVC.tdImages
        
        let text = self.tdEditContainerVC.tdMemo.text
        let locationText = self.tdEditContainerVC.tdLocation.text
        let latitude = self.tdEditContainerVC.location.latitude
        let longitude = self.tdEditContainerVC.location.longitude
        
        let diary = Diary(title: title, date: date, latitude: latitude, longitude: longitude, text: text, locatonName: locationText, images: photos)
    
        self.diary.deletePhoto()
        
        let realm = try! Realm()
        let destination = Destination.shared[self.section]
        if let row = self.row {
            try! realm.write {
                destination.diaries[row] = diary
                realm.delete(self.diary.dirPathForPhotos)
                realm.delete(self.diary)
            }
        } else {
            try! realm.write {
                destination.addDiary(diary: diary)
            }
        }
        
        self.delegate?.changedData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func camera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func album(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func textSetting(_ sender: Any) {
    }
}

// MARK: - Control ImagePicker
extension TDEditDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.tdEditContainerVC.tdImages += [image]
            self.tdEditContainerVC.tdCollectionView.reloadData()
            
        }else {
            print("something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension TDEditDiaryViewController {
    func initData() {
        if let row = self.row {
            self.diary = Destination.shared[section].getDiary(at: row)
            
            print(diary.getLocation())
            self.tdEditContainerVC.tdTitle.text = self.diary?.getTitle()
            self.tdEditContainerVC.nowDate = (self.diary?.getDate())!
            self.tdEditContainerVC.tdMemo.text = self.diary?.getText()
            self.tdEditContainerVC.tdLocation.text = self.diary?.getLocationName()
            self.tdEditContainerVC.location = diary.getLocation()
            self.tdEditContainerVC.dirPathForPhotos = diary.dirPathForPhotos
            
            if let photos = diary?.getPhotos() {
                self.tdEditContainerVC.tdImages = photos
            }
        } else {
            self.diary = Diary()
            
            self.tdEditContainerVC.nowDate = Destination.shared[section].departureDate
            self.tdEditContainerVC.datePicker.date = Destination.shared[section].departureDate
        }
    }
    
    func setEditContainer() {
        
        self.tdEditContainerVC = storyboard!.instantiateViewController(withIdentifier: "TDEditContainerViewController") as! TDEditContainerViewController
        addChildViewController(self.tdEditContainerVC)
        self.tdEditContainerVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.editContainerView.addSubview(self.tdEditContainerVC.view)
        
        NSLayoutConstraint.activate([
            self.tdEditContainerVC.view.leadingAnchor.constraint(equalTo: self.editContainerView.leadingAnchor),
            self.tdEditContainerVC.view.trailingAnchor.constraint(equalTo: self.editContainerView.trailingAnchor),
            self.tdEditContainerVC.view.topAnchor.constraint(equalTo: self.editContainerView.topAnchor),
            self.tdEditContainerVC.view.bottomAnchor.constraint(equalTo: self.editContainerView.bottomAnchor)
            ])
    }
}

