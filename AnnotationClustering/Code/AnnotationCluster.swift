//
//  AnnotationCluster.swift
//  AnnotationClustering
//
//  Created by Gunter Hager on 07.06.16.
//  Copyright © 2016 Gunter Hager. All rights reserved.
//

import Foundation
import MapKit

/// Class that represents an annotation cluster.
/// - Note: Needs to subclass NSObject to be able to conform to MKAnnotation
open class AnnotationCluster: NSObject {
    open var coordinate = CLLocationCoordinate2D(latitude: 0, longitude:0)
    
    open var title: String? = "cluster"
    open var subtitle: String?
    
    /// Annotations that are represented by this cluster.
    open var annotations: [MKAnnotation] = []
}

extension AnnotationCluster: MKAnnotation {}
