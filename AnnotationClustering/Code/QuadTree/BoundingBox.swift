//
//  BoundingBox.swift
//  AnnotationClustering
//
//  Created by Gunter Hager on 07.06.16.
//  Copyright © 2016 Gunter Hager. All rights reserved.
//

import Foundation
import MapKit

let smallDimension = Double(10.0)

struct BoundingBox {
    fileprivate let rect: MKMapRect
    
    // MARK: - Initializers
    
    init(x: Double, y: Double, width: Double, height: Double) {
        rect = MKMapRect(origin: MKMapPoint(x: x, y: y), size: MKMapSize(width: width, height: height))
    }
    
    init(mapRect: MKMapRect) {
        rect = mapRect
    }

    // MARK: - Convenience accessors
    
    var x: Double { return rect.origin.x }
    var y: Double { return rect.origin.y }
    var width: Double { return rect.size.width }
    var height: Double { return rect.size.height }
    
    var mapRect: MKMapRect {
        return rect
    }
    
    var isSmall: Bool {
        let minDimension = min(width, height)
        return minDimension < smallDimension
    }

    
    // MARK: - Comparisons
    
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return MKMapRectContainsPoint(rect, MKMapPointForCoordinate(coordinate))
    }
    
    func intersects(_ other: BoundingBox) -> Bool {
        return MKMapRectIntersectsRect(rect, other.rect)
    }

}

