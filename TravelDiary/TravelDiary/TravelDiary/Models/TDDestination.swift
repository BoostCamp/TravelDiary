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

// 아시아, 유럽, 아프리카, 오세아니아, 북아메리카, 남아메리카
enum RegionList: Int {
    case asia = 0
    case europe
    case northAmerica
    case southAmerica
    case oceania
    case africa
    
    func convertRegion() -> String {
        switch self {
        case .asia:
            return "Asis"
        case .europe:
            return "Europe"
        case .northAmerica:
            return "North America"
        case .southAmerica:
            return "South America"
        case .oceania:
            return "Oceania"
        case .africa:
            return "Africa"
        }
    }
}

class Destination: Object {
    
    static var shared: Results<Destination>!
    static var filterd: Results<Destination>!
    
    // MARK: - Properties
    dynamic var id = 0
    dynamic var destinationName: String! = ""
    var diaries = List<Diary>()
    
    // var photosURL = List<DirPathForImage>()
    
    // 출발 날짜, 도착 날짜
     dynamic var departureDate: Date = Date()
     dynamic var arrivalDate: Date = Date()
    
    // Initialize
    convenience init(destinationName: String, departureDate: Date, arrivalDate: Date) { // 받아 올 때 구글플레이스 위치 검색으로 검색된 값 받아오기
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
        let diary = diaries[index]   // Array Extension 해서 Element 로 삭제 추가
        switch index {
        case 0 ..< self.diaries.count:
            self.diaries.remove(at: index)
        default: break
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
