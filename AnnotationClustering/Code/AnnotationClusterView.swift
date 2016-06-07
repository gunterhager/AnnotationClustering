//
//  AnnotationClusterView.swift
//  AnnotationClustering
//
//  Created by Gunter Hager on 07.06.16.
//  Copyright © 2016 Gunter Hager. All rights reserved.
//

import UIKit
import MapKit

/// Annotation view that represents a cluster. If you reuse an instance of this view, be sure to call `reuseWithAnnotation()`.
public class AnnotationClusterView : MKAnnotationView {
    
    /// Count of the annotations this cluster view represents.
    public var count = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var fontSize: CGFloat = 12
    
    private var imageName = "cluster_30"
    private var loadExternalImage = false
    
    private var countLabel: UILabel = UILabel()
    private var options: AnnotationClusterViewOptions?
    
    /**
     Creates a new cluster annotation view.
     
     - parameter annotation:      Annotation that represents a cluster.
     - parameter reuseIdentifier: Identifier for reusing the annotation view.
     - parameter options:         Options that customize the annotation view.
     
     - returns: Returns an initialised cluster annotation view.
     */
    public init(annotation: AnnotationCluster?, reuseIdentifier: String?, options: AnnotationClusterViewOptions?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        guard let cluster = annotation else { return }
        updateViewFromCount(cluster.annotations.count)
        
        backgroundColor = UIColor.clearColor()
        
        // Setup label
        self.countLabel.frame = bounds
        self.countLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.countLabel.textAlignment = .Center
        self.countLabel.backgroundColor = UIColor.clearColor()
        self.countLabel.textColor = UIColor.whiteColor()
        self.countLabel.adjustsFontSizeToFitWidth = true
        self.countLabel.minimumScaleFactor = 0.8
        self.countLabel.numberOfLines = 1
        self.countLabel.font = UIFont.boldSystemFontOfSize(fontSize)
        self.countLabel.baselineAdjustment = .AlignCenters
        addSubview(self.countLabel)
        
        setNeedsLayout()
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        
        // Images are faster than using drawRect:
        
        let bundle: NSBundle? = loadExternalImage ? nil : NSBundle(forClass: AnnotationClusterView.self)
        let imageAsset = UIImage(named: imageName, inBundle: bundle, compatibleWithTraitCollection: nil)
        
        countLabel.frame = self.bounds
        image = imageAsset
        centerOffset = CGPointZero

        guard let cluster = annotation as? AnnotationCluster else { return }
        updateViewFromCount(cluster.annotations.count)
    }
    
    /**
     Reuse the annotation view by providing a new annotation. Should be called after dequeing it from a map view.
     
     - parameter annotation: Annotation that represents a cluster.
     */
    public func reuseWithAnnotation(annotation: AnnotationCluster) {
        self.annotation = annotation
        self.count = annotation.annotations.count
        
    }
    
    private func updateViewFromCount(count: Int) {
        countLabel.text = "\(count)"

        switch count {
        case 0...5:
            fontSize = 12
            if let options = options {
                loadExternalImage = true;
                imageName = options.smallClusterImage
            }
            else {
                imageName = "cluster_30"
            }
            
        case 6...15:
            fontSize = 13
            if let options = options {
                loadExternalImage = true;
                imageName = options.mediumClusterImage
            }
            else {
                imageName = "cluster_40"
            }
            
        default:
            fontSize = 14
            if let options = options {
                loadExternalImage = true;
                imageName = options.largeClusterImage
            }
            else {
                imageName = "cluster_50"
            }
            
        }
    }
    
}

/**
 *  Provides options for the annotation cluster view.
 */
public struct AnnotationClusterViewOptions {
    let smallClusterImage : String
    let mediumClusterImage : String
    let largeClusterImage : String
}
