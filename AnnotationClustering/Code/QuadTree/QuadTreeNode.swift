//
//  QuadTreeNode.swift
//  AnnotationClustering
//
//  Created by Gunter Hager on 07.06.16.
//  Copyright © 2016 Gunter Hager. All rights reserved.
//

import Foundation
import MapKit

private let nodeCapacity = 8

class QuadTreeNode {
    
    var boundingBox: BoundingBox
    
    var northEast: QuadTreeNode? = nil
    var northWest: QuadTreeNode? = nil
    var southEast: QuadTreeNode? = nil
    var southWest: QuadTreeNode? = nil
    
    var annotations:[MKAnnotation] = []
    
    // MARK: - Initializers
    
    init(x: Double, y: Double, width: Double, height: Double) {
        boundingBox = BoundingBox(x: x, y: y, width: width, height: height)
    }
    
    init(boundingBox box: BoundingBox) {
        boundingBox = box
    }
    
    // Annotations
    
    var allAnnotations: [MKAnnotation] {
        var result = annotations
        result += northEast?.allAnnotations ?? []
        result += northWest?.allAnnotations ?? []
        result += southEast?.allAnnotations ?? []
        result += southWest?.allAnnotations ?? []
        return result
    }
    
    func addAnnotation(_ annotation: MKAnnotation) -> Bool {
        guard boundingBox.contains(annotation.coordinate) else {
            return false
        }
        
        if (annotations.count < nodeCapacity) || boundingBox.isSmall {
            annotations.append(annotation)
            return true
        }
        
        subdivide()
        
        if let node = northEast, node.addAnnotation(annotation) == true {
            return true
        }
        if let node = northWest, node.addAnnotation(annotation) == true {
            return true
        }
        if let node = southEast, node.addAnnotation(annotation) == true {
            return true
        }
        if let node = southWest, node.addAnnotation(annotation) == true {
            return true
        }
        
        return false
    }
    
    func forEachAnnotationInBox(_ box: BoundingBox, block: (MKAnnotation) -> Void) {
        guard boundingBox.intersects(box) else { return }
        
        for annotation in annotations {
            if box.contains(annotation.coordinate) {
                block(annotation)
            }
        }
        
        if isLeaf() {
            return
        }
        
        if let node = northEast {
            node.forEachAnnotationInBox(box, block: block)
        }
        if let node = northWest {
            node.forEachAnnotationInBox(box, block: block)
        }
        if let node = southEast {
            node.forEachAnnotationInBox(box, block: block)
        }
        if let node = southWest {
            node.forEachAnnotationInBox(box, block: block)
        }
    }
    
    
    // MARK: - Private
    
    fileprivate func isLeaf() -> Bool {
        return (northEast == nil) ? true : false
    }
    
    fileprivate func subdivide() {
        
        guard isLeaf() == true else { return }
        
        let w2 = boundingBox.width / 2.0
        let xMid = boundingBox.x + w2
        let h2 = boundingBox.height / 2.0
        let yMid = boundingBox.y + h2
        
        northEast = QuadTreeNode(x: xMid,          y: boundingBox.y, width: w2, height: h2)
        northWest = QuadTreeNode(x: boundingBox.x, y: boundingBox.y, width: w2, height: h2)
        southEast = QuadTreeNode(x: xMid,          y: yMid,          width: w2, height: h2)
        southWest = QuadTreeNode(x: boundingBox.x, y: yMid,          width: w2, height: h2)
    }
    
}
