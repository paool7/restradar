//
//  MapOuterView.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @ObservedObject private var bathroomAttendant = BathroomAttendant.shared
    @ObservedObject private var locationAttendant = LocationAttendant.shared
    @StateObject var bathroom: Bathroom

    class Coordinator: NSObject, MKMapViewDelegate {        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circle = overlay as? MKCircle {
                let renderer = MKCircleRenderer(circle: circle)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 1
                return renderer
            } else {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.lineWidth = 8.0
                renderer.strokeColor = UIColor(red: 0.514, green: 0.682, blue: 0.800, alpha: 1.000)
                return renderer
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
  func makeUIView(context: Context) -> MKMapView {
      let mapView = MKMapView(frame: UIScreen.main.bounds)
      mapView.showsUserLocation = true
      mapView.isUserInteractionEnabled = false

      mapView.backgroundColor = .secondarySystemBackground
      
      mapView.delegate = context.coordinator

      let configuration = MKStandardMapConfiguration(emphasisStyle: .default)
      mapView.preferredConfiguration = configuration
      
      let camera = MKMapCamera()
      if let distance = bathroom.distanceMeters()?.value {
          camera.centerCoordinateDistance = distance*2.5
      }
      mapView.camera = camera
      
      if let annotation = bathroom.annotation {
          mapView.addAnnotation(annotation)
      }
      
      return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
      let camera = MKMapCamera()

      if let currentHeading = locationAttendant.currentHeading {
          camera.heading = currentHeading
      }
      if let current = locationAttendant.current {
          camera.centerCoordinate = current.coordinate.midpointTo(location: bathroom.coordinate)
      }
      if let distance = bathroom.distanceMeters()?.value {
          camera.centerCoordinateDistance = distance*2.5
      }
      uiView.removeOverlays(uiView.overlays)

      if let route = bathroom.route {
          uiView.addOverlay((route.polyline), level: .aboveRoads)
      }
      uiView.camera = camera
  }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(bathroom: BathroomAttendant.shared.closestBathroom)
    }
}

