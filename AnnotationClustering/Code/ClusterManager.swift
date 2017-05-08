//
//  ClusterManager.swift
//  AnnotationClustering
//
//  Created by Gunter Hager on 07.06.16.
//  Copyright © 2016 Gunter Hager. All rights reserved.
//

import Foundation
import MapKit

/**
 *  Protocol that the Delegate of the cluster manager needs to implement.
 */
public protocol ClusterManagerDelegate {
    
    /**
     Provide a cell size factor for the cluster manager. The cell size factor defines the size of the cells that the map uses for clustering. Clusters are grouped into cells.
     
     - parameter manager: Manager that wants to know its cell size factor.
     
     - returns: A cell size factor fo rthe manager to use.
     */
    func cellSizeFactorForManager(_ manager: ClusterManager) -> CGFloat
    
}

/// Class that manages the clustering of the annotations.
open class ClusterManager {
    
    open var delegate: ClusterManagerDelegate?
    open var maxZoomLevel = 19
    
    fileprivate var tree = QuadTree()    
    fileprivate var lock = NSRecursiveLock()
    
    
    public init(annotations: [MKAnnotation] = []){
        addAnnotations(annotations)
    }
    
    open func setAnnotations(_ annotations:[MKAnnotation]) {
        lock.lock()
        tree = QuadTree()
        addAnnotations(annotations)
        lock.unlock()
    }
    
    open func addAnnotations(_ annotations:[MKAnnotation]) {
        lock.lock()
        for annotation in annotations {
            tree.addAnnotation(annotation)
        }
        lock.unlock()
    }
    
    open func clusteredAnnotationsWithinMapRect(_ rect:MKMapRect, withZoomScale zoomScale:Double) -> [MKAnnotation] {
        guard !zoomScale.isInfinite else { return [] }
        
        let zoomLevel   = ClusterManager.zoomScaleToZoomLevel(MKZoomScale(zoomScale))
        let cellSize    = ClusterManager.cellSizeForZoomLevel(zoomLevel)
        
        let scaleFactor:Double = zoomScale / Double(cellSize)
        
        let minX = Int(floor(MKMapRectGetMinX(rect) * scaleFactor))
        let maxX = Int(floor(MKMapRectGetMaxX(rect) * scaleFactor))
        let minY = Int(floor(MKMapRectGetMinY(rect) * scaleFactor))
        let maxY = Int(floor(MKMapRectGetMaxY(rect) * scaleFactor))
        
        var clusteredAnnotations = [MKAnnotation]()
        
        lock.lock()
        
        for i in minX...maxX {
            
            for j in minY...maxY {
                
                let mapPoint = MKMapPoint(x: Double(i) / scaleFactor, y: Double(j) / scaleFactor)
                let mapSize = MKMapSize(width: 1.0 / scaleFactor, height: 1.0 / scaleFactor)
                let mapRect = MKMapRect(origin: mapPoint, size: mapSize)
                let mapBox = BoundingBox(mapRect: mapRect)
                
                var totalLatitude:Double = 0
                var totalLongitude:Double = 0
                
                var annotations = [MKAnnotation]()
                
                tree.forEachAnnotationInBox(mapBox) { (annotation) in
                    totalLatitude += annotation.coordinate.latitude
                    totalLongitude += annotation.coordinate.longitude
                    annotations.append(annotation)
                }
                
                let count = annotations.count
                
                if count == 1 || zoomLevel >= self.maxZoomLevel {
                    clusteredAnnotations += annotations
                }
                else if count > 1 {
                    let coordinate = CLLocationCoordinate2D(
                        latitude: CLLocationDegrees(totalLatitude) / CLLocationDegrees(count),
                        longitude: CLLocationDegrees(totalLongitude) / CLLocationDegrees(count)
                    )
                    let cluster = AnnotationCluster()
                    cluster.coordinate = coordinate
                    cluster.annotations = annotations
                    clusteredAnnotations.append(cluster)
                }
            }
        }
        
        
        lock.unlock()
        
        return clusteredAnnotations
    }
    
    open var allAnnotations: [MKAnnotation] {
        lock.lock()
        let annotations = tree.allAnnotations
        lock.unlock()
        return annotations
    }
    
    open func displayAnnotations(_ annotations: [MKAnnotation], mapView:MKMapView){
        
        DispatchQueue.main.async  {
            
            let before = NSMutableSet(array: mapView.annotations)
            before.remove(mapView.userLocation)
            let after = NSSet(array: annotations)
            let toKeep = NSMutableSet(set: before)
            toKeep.intersect(after as Set<NSObject>)
            let toAdd = NSMutableSet(set: after)
            toAdd.minus(toKeep as Set<NSObject>)
            let toRemove = NSMutableSet(set: before)
            toRemove.minus(after as Set<NSObject>)
            
            if let toAddAnnotations = toAdd.allObjects as? [MKAnnotation]{
                mapView.addAnnotations(toAddAnnotations)
            }
            
            if let removeAnnotations = toRemove.allObjects as? [MKAnnotation]{
                mapView.removeAnnotations(removeAnnotations)
            }
        }
        
    }
    
    open class func zoomScaleToZoomLevel(_ scale: MKZoomScale) -> Int {
        let totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0
        let zoomLevelAtMaxZoom = Int(log2(totalTilesAtMaxZoom))
        let floorLog2ScaleFloat = floor(log2f(Float(scale))) + 0.5
        guard !floorLog2ScaleFloat.isInfinite else { return (floorLog2ScaleFloat.sign == .minus) ? 0 : 19 }
        let sum = zoomLevelAtMaxZoom + Int(floorLog2ScaleFloat)
        let zoomLevel = max(0, sum)
        return zoomLevel;
    }
    
    open class func cellSizeForZoomLevel(_ zoomLevel: Int) -> CGFloat {
        
        switch (zoomLevel) {
        case 13:
            return 64
        case 14:
            return 64
        case 15:
            return 64
        case 16:
            return 32
        case 17:
            return 32
        case 18:
            return 32
        case 18 ..< Int.max:
            return 16
            
        default:
            // less than 13 zoom level
            return 88
        }
    }
    
    open class func cellSizeForZoomScale(_ zoomScale: MKZoomScale) -> CGFloat {
        
        let zoomLevel = ClusterManager.zoomScaleToZoomLevel(zoomScale)
        return ClusterManager.cellSizeForZoomLevel(zoomLevel)
    }
}
