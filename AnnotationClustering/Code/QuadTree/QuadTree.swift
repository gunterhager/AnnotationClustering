//
//  QuadTree.swift
//  AnnotationClustering
//
//  Created by Gunter Hager on 07.06.16.
//  Copyright © 2016 Gunter Hager. All rights reserved.
//

import Foundation
import MapKit

class QuadTree {
    
    var rootNode: QuadTreeNode
        
    init () {
        rootNode = QuadTreeNode(boundingBox: BoundingBox(mapRect: MKMapRectWorld))
    }
    
    var allAnnotations: [MKAnnotation] {
        return rootNode.allAnnotations
    }
    
    func addAnnotation(annotation: MKAnnotation) -> Bool {
        return rootNode.addAnnotation(annotation)
    }
    
    func forEachAnnotation(block: (MKAnnotation) -> Void) {
        forEachAnnotationInBox(BoundingBox(mapRect: MKMapRectWorld), block: block)
    }
    
    func forEachAnnotationInBox(box: BoundingBox, block: (MKAnnotation) -> Void) {
        rootNode.forEachAnnotationInBox(box, block: block)
    }

}