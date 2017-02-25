//
//  TDEditContainerViewController.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 18/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import RealmSwift

struct Typealiases {
    typealias JSONDict = [String:Any]
}

class TDEditContainerViewController: UITableViewController {
    
    @IBOutlet weak var tdTableView: UITableView!
    @IBOutlet weak var tdCollectionView: UICollectionView!
    @IBOutlet weak var tdTitle: UITextField!
    @IBOutlet weak var tdDate: UITextField!
    @IBOutlet weak var tdLocation: UITextField!
    @IBOutlet weak var tdMemo: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Set for UI
    @IBOutlet var uiContentViewCollection: [UIView]!
    @IBOutlet var uiCardViewViewCollection: [UIView]!
    @IBOutlet weak var backgroundViewForCollectionView: UIView!
    // Set for UI
    
    var delegate: TDEditDiaryViewControllerDelegate?
    let locationManager = CLLocationManager()
    
    var nowDate: Date!
    var tdImages = [UIImage]()
    var flagForLocation: Bool = false
    var location: (latitude: Double?, longitude: Double?)
    var dirPathForPhotos = List<DirPathForImage>()
    var isDatePickeHidden = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tdCollectionView.register(UINib(nibName: "TDImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TDImageCollectionViewCell")
        
        self.tdTitle.delegate = self
        self.tdDate.delegate = self
        self.tdLocation.delegate = self
        self.tdMemo.delegate = self
        self.locationManager.delegate = self
        self.setTableUI()
        
        // 탭 동작 인식기
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 MM월 dd일"
        
        if self.nowDate == nil {
            self.nowDate = Date()
        }
        self.tdDate.text = dateFormatter.string(from: self.nowDate)
        
        self.tdCollectionView.reloadData()
        self.tdTableView.reloadData()
//        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.unsubscribeFromKeyboardNotifications()
    }
    
    
}

// MARK: - Actions
extension TDEditContainerViewController {
    @IBAction func editDateButtonTapped(_ sender: Any) {
        
        if self.isDatePickeHidden {       // 버튼 모양 바꾸기
            self.isDatePickeHidden = false
            self.datePicker.isHidden = false
            
            self.tdTableView.reloadData()
        } else {
            self.isDatePickeHidden = true
            self.datePicker.isHidden = true
            
            self.nowDate = self.datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy년 MM월 dd일"
            
            self.tdDate.text = dateFormatter.string(from: self.nowDate)
            
            self.tdTableView.reloadData()
        }
    }
    
    @IBAction func editLocationButtonTapped(_ sender: Any) {
        let searchMapVC = self.storyboard?.instantiateViewController(withIdentifier: "TDSearchMapViewController") as! TDSearchMapViewController
        searchMapVC.delegate = self
        
        self.present(searchMapVC, animated: true, completion: nil)
    }
    
    @IBAction func setCurrentLocationButtonTapped(_ sender: Any) {
        self.locationManager.requestWhenInUseAuthorization()
        self.flagForLocation = false
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 MM월 dd일"
        
        self.tdDate.text = dateFormatter.string(from: sender.date)
    }
}

extension TDEditContainerViewController: TDSearchMapViewControllerDelegate {
    func changeLocation(location: CLLocationCoordinate2D, locationName: String) {
        self.flagForLocation = true
        self.location = (latitude: location.latitude, longitude: location.longitude)
        self.tdLocation.text = locationName
        
        self.locationManager.stopUpdatingLocation()
    }
}

// MARK: - TableView
extension TDEditContainerViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 && self.isDatePickeHidden {
            return 0
        } else if indexPath.row == 4 && self.tdImages.count == 0 {
            return 0
        } else {
            return super.tableView(tdTableView, heightForRowAt : indexPath)
        }
    }
    
    
    func setTableUI() {
        
        for cardView in self.uiCardViewViewCollection {
            cardView.backgroundColor = .white
            cardView.layer.cornerRadius = 3
            cardView.layer.masksToBounds = false
            cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
            cardView.layer.shadowOpacity = 0.8
        }
        
        for contentView in self.uiContentViewCollection {
            contentView.backgroundColor = UIColor(red: 240/255.5, green: 240/255.5, blue: 240/255.5, alpha: 1)
        }

        self.backgroundViewForCollectionView.backgroundColor = .black
    }
}

// MARK: - CollectionView
extension TDEditContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tdImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDImageCollectionViewCell", for: indexPath) as! TDImageCollectionViewCell
        
        let tdImage = self.tdImages[indexPath.row]
        cell.configureCell(tdImage: tdImage, isClipTrue: true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tdImages.remove(at: indexPath.row)
        self.tdCollectionView.deleteItems(at: [indexPath])
        self.tdTableView.reloadData()
    }
}


// MARK: - Get Current Location
extension TDEditContainerViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 1 {
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
                if let error = error {
                    print("Reverse geocoder failed with error" + error.localizedDescription)
                    return
                }
                
                if placemarks?.count != 0 {
                    if let pm = placemarks?.first {
                        if !self.flagForLocation {
                            self.setLocationInfo(placemark: pm)
                        }
                    }
                } else {
                    print("Problem with the data received from geocoder, \(placemarks?.count)")
                }
            })
        }
    }
    
    func setLocationInfo(placemark: CLPlacemark) {
        let location = placemark.location?.coordinate
        self.location = (latitude: (location?.latitude)!, longitude: (location?.longitude)!)
        locationManager.stopUpdatingLocation()
        
        var locationName = ""
        if let locatlity = placemark.locality {
            locationName += "\(locatlity)"
        }
        if let thoroughfare = placemark.thoroughfare {
            locationName += "\(thoroughfare)"
        }
        
        self.tdLocation.text = locationName
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}




extension TDEditContainerViewController: UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: - Control Keyboard
    
    // 뷰 구조에서 최초 응답 객체 찾기
    func findFirstResponder() -> UIResponder? {
        for v in self.view.subviews {
            if v.isFirstResponder {
                return (v as UIResponder)
            }
        }
        return nil
    }
    
    func handleTap(_ gesture: UITapGestureRecognizer) {
        // 최초 응답 객체 찾기
        
        if let firstRespond = self.findFirstResponder() {
            firstRespond.resignFirstResponder()
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let rectObj = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = rectObj.cgRectValue
            
            // 최초 응답 객체 찾기
            let textView = findFirstResponder() as! UITextView
            let textField = findFirstResponder() as! UITextField
            
            // 키보드에 가리는지 체크
            if keyboardRect.contains(textView.frame.origin) {
                let dy = keyboardRect.origin.y - textView.frame.origin.y - 10
                self.view.transform = CGAffineTransform.init(translationX: 0, y: dy)
            } else {
            }
            
            if keyboardRect.contains(textField.frame.origin) {
                let dy = keyboardRect.origin.y - textField.frame.origin.y - textField.frame.size.height - 10
                self.view.transform = CGAffineTransform.init(translationX: 0, y: dy)
            } else {
            }
            
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        self.view.transform = CGAffineTransform.identity
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
