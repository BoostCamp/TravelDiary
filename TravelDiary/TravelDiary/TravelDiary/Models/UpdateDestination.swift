//
//  UpdateDestination.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 18/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import Foundation

class UpdateDestination: NSObject {
    
    var destinations = [Destination]()
    
    struct StaticInstance {
        static var instance: UpdateDestination?
    }
    
    class func sharedInstance() -> UpdateDestination {
        if !(StaticInstance.instance != nil) {
            StaticInstance.instance = UpdateDestination()
        }
        return StaticInstance.instance!
        
    }
    
    public func getDestinations() -> [Destination] {
        return self.destinations
        //UpdateDestination.sharedInstance().destinations
    }
    
    public func addDestination(destination: Destination) {
        self.destinations.append(destination)
        //UpdateDestination.sharedInstance().destinations.append(destination)
        
    }
    
    public func getDestinationAt(index: Int) -> Destination {
        return self.destinations[index]
        //UpdateDestination.sharedInstance().destinations[index]
    }
}
