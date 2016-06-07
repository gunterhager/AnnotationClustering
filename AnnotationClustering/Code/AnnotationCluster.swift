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
public class AnnotationCluster: NSObject {
    public var coordinate = CLLocationCoordinate2D(latitude: 0, longitude:0)
    
    public var title: String? = "cluster"
    public var subtitle: String?
    
    /// Annotations that are represented by this cluster.
    public var annotations: [MKAnnotation] = []
}

extension AnnotationCluster: MKAnnotation {}