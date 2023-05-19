//
//  Annotation.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import Foundation
import MapKit

final class Annotation: NSObject, MKAnnotation {
  let title: String?
  let coordinate: CLLocationCoordinate2D
  
  init(title: String?, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.coordinate = coordinate
  }
}
