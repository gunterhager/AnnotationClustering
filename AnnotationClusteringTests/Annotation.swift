//
//  Annotation.swift
//  AnnotationClustering
//
//  Created by Gunter Hager on 14.06.16.
//  Copyright © 2016 Gunter Hager. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject {
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude:0)
    
    var title: String? = "Pin"
    var subtitle: String?
}

extension Annotation: MKAnnotation {}
