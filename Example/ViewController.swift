//
//  ViewController.swift
//  Example
//
//  Created by Gunter Hager on 07.06.16.
//  Copyright © 2016 Gunter Hager. All rights reserved.
//

import UIKit

import MapKit
import AnnotationClustering

class Annotation: NSObject {
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude:0)
    
    var title: String? = "Pin"
    var subtitle: String?
}

extension Annotation: MKAnnotation {}



class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let numberOfLocations = 1000
    
    let clusterManager = ClusterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotations = randomLocationsWithCount(numberOfLocations)
        
        clusterManager.addAnnotations(annotations)
        clusterManager.delegate = self
        
        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0)
        mapView.delegate = self
    }
    

    // MARK: - Utility
    
    func randomLocationsWithCount(count: Int) -> [MKAnnotation] {
        var array = [MKAnnotation]()
        (0 ..< count).forEach { _ in
            let a = Annotation()
            a.coordinate = CLLocationCoordinate2D(latitude: drand48() * 40 - 20, longitude: drand48() * 80 - 40 )
            array.append(a)
        }
        return array
    }
    
}

extension ViewController : ClusterManagerDelegate {
    
    func cellSizeFactorForManager(manager: ClusterManager) -> CGFloat {
        return 1.0
    }
    
}


extension ViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        
        NSOperationQueue().addOperationWithBlock { [unowned self] in
            
            let mapBoundsWidth = Double(mapView.bounds.size.width)
            let mapRectWidth:Double = mapView.visibleMapRect.size.width
            
            let scale:Double = mapBoundsWidth / mapRectWidth
            
            let annotationArray = self.clusterManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
            
            self.clusterManager.displayAnnotations(annotationArray, mapView: mapView)
            
        }
        
    }
    
    // Note: The example app doesn't support showing the user location. The handling of the user location pin is given as an example here in case your app wants to use it.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var reuseId = ""
        
        switch annotation {
        case is MKUserLocation:
            return nil // show Apple's default user location pin
            
        case let cluster as AnnotationCluster:
            reuseId = "Cluster"
            if let clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? AnnotationClusterView {
                clusterView.reuseWithAnnotation(cluster)
                return clusterView
            }
            else {
                let options = AnnotationClusterViewOptions(smallClusterImage: "cluster_2_30", mediumClusterImage: "cluster_2_40", largeClusterImage: "cluster_2_50")
                return AnnotationClusterView(annotation: cluster, reuseIdentifier: reuseId, options: options)
            }
            

        default:
            reuseId = "Pin"
            if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView {
                pinView.annotation = annotation
                return pinView
            }
            else {
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                return pinView
            }
        }
        
    }
    
}
