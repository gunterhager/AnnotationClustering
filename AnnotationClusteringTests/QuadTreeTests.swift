//
//  QuadTreeTests.swift
//  AnnotationClustering
//
//  Created by Gunter Hager on 14.06.16.
//  Copyright © 2016 Gunter Hager. All rights reserved.
//

import XCTest
import MapKit
@testable import AnnotationClustering

class QuadTreeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddingAnnotations() {
        let numberOfAnnotations = 10000
        let tree = QuadTree()
        
        (0 ..< numberOfAnnotations).forEach { _ in
            tree.addAnnotation(Annotation())
        }
        
        let count = tree.allAnnotations.count
        XCTAssert(tree.allAnnotations.count == numberOfAnnotations, "\(count) Annotations in tree, should be \(numberOfAnnotations)")
    }
    
    func testPerformanceExample() {
        let numberOfAnnotations = 10000
        let tree = QuadTree()
        
        self.measureBlock {
            (0 ..< numberOfAnnotations).forEach { _ in
                tree.addAnnotation(Annotation())
            }
        }
    }
    
}
