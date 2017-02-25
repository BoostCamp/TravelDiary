//
//  ExtenstionForTD.swift
//  TravelDiary
//
//  Created by Daeyun Ethan Kim on 14/02/2017.
//  Copyright © 2017 Daeyun Ethan Kim. All rights reserved.
//

import Foundation
import UIKit



extension Array {
    func find(includedElement: (Element) -> Bool) -> Int? {
        for(index, element) in enumerated() {
        
            if includedElement(element) {
                return index
            }
        }
        return nil
    }
}

extension UIImage {
    class func imageResize(_ image: UIImage, _ sizeChange: CGSize) -> UIImage {
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}


extension UICollectionView {
    
    var centerPoint : CGPoint {
        
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }
    
    var centerCellIndexPath: NSIndexPath? {
        
        if let centerIndexPath: NSIndexPath  = self.indexPathForItem(at: self.centerPoint) as NSIndexPath? {
            return centerIndexPath
        }
        return nil
    }
}

