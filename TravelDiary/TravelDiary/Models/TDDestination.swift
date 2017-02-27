//
//  TDDestination.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 17/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

// 필터 목록
enum RegionList: Int {
    case asia = 0
    case europe
    case northAmerica
    case southAmerica
    case oceania
    case africa
    
    func convertRegion() -> (region: String, color: UIColor) {
        switch self {
        case .asia:
            return ("Asia", UIColor.FlatColor.Blue.BlueWhale)
        case .europe:
            return ("Europe", UIColor.FlatColor.Green.PersianGreen)
        case .northAmerica:
            return ("North America", UIColor.FlatColor.Yellow.Turbo)
        case .southAmerica:
            return ("South America", UIColor.FlatColor.Red.TerraCotta)
        case .oceania:
            return ("Oceania", UIColor.FlatColor.Orange.Sun)
        case .africa:
            return ("Africa", UIColor.FlatColor.Violet.Wisteria)
        }
    }
}

// Destination 모델
class Destination: Object {
    
    // MARK: - Properties
    dynamic var id = 0
    dynamic var destinationName: String! = ""
    var diaries = List<Diary>()
    
     dynamic var departureDate: Date = Date()
     dynamic var arrivalDate: Date = Date()
    
    // Initialize
    convenience init(destinationName: String, departureDate: Date, arrivalDate: Date) {
        self.init()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddhhmmss"
        let currentID = dateFormatter.string(from: date)
        self.id = Int(currentID)!
        
        if destinationName == "" {
            self.destinationName = "목적지가 설정 되지 않았습니다."
        } else {
            self.destinationName = destinationName
        }
        
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
    }
    
    // MARK: - Functions
    // Get, Set Properties
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func getDestinationName() -> String {
        return self.destinationName
    }
    
    public func getDirayCount() -> Int {
        let count = self.diaries.count
        
        return count
    }
    
    public func getDiaries() -> List<Diary> {
        return diaries
    }
    
    public func getDiary(at index: Int) -> Diary? {
        let diary = self.diaries[index]
        return diary
    }
    
    public func setDiaries(diaries: List<Diary>) {
        self.diaries = diaries
    }
    
    public func deleteDiary(at index: Int) {
        
        switch index {
        case 0 ..< self.diaries.count:
            self.diaries.remove(at: index)
        default:
            print("Erro : Destination doesn't have that diary.")
            break
        }
    }
    
    public func addDiary(diary: Diary) {
        self.diaries.append(diary)
    }
    
    public func getDepartureDate() -> Date {
        return self.departureDate
    }
    
    public func getArrivalDate() -> Date {
        return self.arrivalDate
    }
}
