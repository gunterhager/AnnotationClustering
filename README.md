# AnnotationClustering

<img src="https://img.shields.io/badge/Platform-iOS%208-blue.svg" alt="Platform iOS8+">
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Language-Swift%203-orange.svg" alt="Language: Swift 2" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg" alt="Carthage compatible" /></a>

Framework that clusters annotations on `MKMapView`.

Based on https://github.com/ribl/FBAnnotationClusteringSwift.

## Requirements

iOS 8.0+, Swift 3

## Usage

An example app is included to demonstrate the usage of `AnnotationClustering`.

### Getting started

Create an instance of the cluster manager.

```swift
let clusterManager = ClusterManager()
```

Create annotations and add them to the cluster manager.

```swift
clusterManager.addAnnotations(annotations)
clusterManager.delegate = self
```

Return cluster or pin in the delegate of the map view.

```swift
extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        
        OperationQueue().addOperation { [unowned self] in
            
            let mapBoundsWidth = Double(mapView.bounds.size.width)
            let mapRectWidth:Double = mapView.visibleMapRect.size.width
            
            let scale:Double = mapBoundsWidth / mapRectWidth
            
            let annotationArray = self.clusterManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
            
            self.clusterManager.displayAnnotations(annotationArray, mapView: mapView)
            
        }
        
    }
    
    // Note: The example app doesn't support showing the user location. The handling of the user location pin is given as an example here in case your app wants to use it.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var reuseId = ""
        
        switch annotation {
        case is MKUserLocation:
            return nil // show Apple's default user location pin
            
        case let cluster as AnnotationCluster:
            reuseId = "Cluster"
            if let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? AnnotationClusterView {
                clusterView.reuseWithAnnotation(cluster)
                return clusterView
            }
            else {
                let options = AnnotationClusterViewOptions(smallClusterImage: "cluster_2_30", mediumClusterImage: "cluster_2_40", largeClusterImage: "cluster_2_50")
                return AnnotationClusterView(annotation: cluster, reuseIdentifier: reuseId, options: options)
            }
            

        default:
            reuseId = "Pin"
            if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView {
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
```

## Documentation

You can find the API documentation here: [Documentation](https://github.com/gunterhager/AnnotationClustering/blob/master/docs/index.html)

## Installation

### Carthage

Add the following line to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

```
github "gunterhager/AnnotationClustering"
```

Then run `carthage update`.

### Manually

Just drag and drop the `.swift` files in the `AnnotationClustering` folder into your project.

## License

`AnnotationClustering` is available under the MIT license. See the [LICENSE](https://github.com/gunterhager/AnnotationClustering/blob/master/LICENSE) file for details.

## Contact

Made with ❤ at [all about apps](https://www.allaboutapps.at).

<img src="https://github.com/gunterhager/AnnotationClustering/blob/master/Resources/aaa_logo.png" height="60" alt="all about apps" />
