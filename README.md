# AnnotationClustering

<img src="https://img.shields.io/badge/Platform-iOS%208%2B-blue.svg" alt="Platform iOS8+">
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Language-Swift%202-orange.svg" alt="Language: Swift 2" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg" alt="Carthage compatible" /></a>

Framework that clusters annotations on `MKMapView`.

Based on https://github.com/ribl/FBAnnotationClusteringSwift.

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
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        NSOperationQueue().addOperationWithBlock { [unowned self] in
            let mapBoundsWidth = Double(mapView.bounds.size.width)
            let mapRectWidth:Double = mapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusterManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
            self.clusterManager.displayAnnotations(annotationArray, mapView: mapView)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var reuseId = ""
        if annotation.isKindOfClass(AnnotationCluster) {
            reuseId = "Cluster"
            if let clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? AnnotationClusterView {
                clusterView.reuseWithAnnotation(annotation)
                return clusterView
            }
            else {
                let clusterView = AnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
                return clusterView
            }
        }
        else {
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
```



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

`AnnotationClustering` is available under the MIT license. See the [LICENSE](https://github.com/mbuchetics/DataSource/blob/master/LICENSE.md) file for details.

## Contact

Made with ❤ at [all about apps](https://www.allaboutapps.at).

[<img src="https://github.com/mbuchetics/DataSource/blob/master/Resources/aaa_logo.png" height="60" alt="all about apps" />