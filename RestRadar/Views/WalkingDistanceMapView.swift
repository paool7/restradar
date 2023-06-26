//
//  MapOuterView.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import MapKit
import SwiftUI

struct WalkingDistanceMapView: UIViewRepresentable {
    @ObservedObject private var bathroomAttendant = BathroomAttendant.shared
    @ObservedObject private var locationAttendant = LocationAttendant.shared
    @StateObject var bathroom: Bathroom
    
    @Binding var walkingDistance: Double
    @Binding var current: CLLocation
    @Binding var currentHeading: CLLocationDegrees
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let overlayRenderer = MKOverlayRenderer(overlay: overlay)
            overlayRenderer.alpha = 0.75
            return MKOverlayRenderer(overlay: overlay)
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
      camera.heading = currentHeading
      camera.centerCoordinate = current.coordinate
      camera.centerCoordinateDistance = walkingDistance*4
      mapView.setCamera(camera, animated: true)

      return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
      uiView.camera.heading = currentHeading
      uiView.camera.centerCoordinate = current.coordinate
      uiView.camera.centerCoordinateDistance = walkingDistance*4

      for annotation in uiView.annotations {
          if !bathroomAttendant.visibleBathrooms.contains(where: {$0.annotation?.coordinate.latitude == annotation.coordinate.latitude && $0.annotation?.coordinate.longitude == annotation.coordinate.longitude}) {
              uiView.removeAnnotation(annotation)
          }
      }
      
      for visibleBathroom in bathroomAttendant.visibleBathrooms {
          if let annotation = visibleBathroom.annotation, !uiView.annotations.contains(where: {$0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == annotation.coordinate.longitude}) {
              uiView.addAnnotation(annotation)
          }
      }
  }
    
}
