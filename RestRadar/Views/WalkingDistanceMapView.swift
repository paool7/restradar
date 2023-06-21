//
//  MapOuterView.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import MapKit
import SwiftUI

class BathroomTileOverlay : MKTileOverlay {
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        result(UIColor.secondarySystemBackground.image().pngData(), nil)
    }
    
}

struct WalkingDistanceMapView: UIViewRepresentable {
    @ObservedObject private var bathroomAttendant = BathroomAttendant.shared
    @ObservedObject private var locationAttendant = LocationAttendant.shared
    @StateObject var bathroom: Bathroom
    
    @Binding var walkingDistance: Double
    @Binding var current: CLLocation
    @Binding var currentHeading: CLLocationDegrees
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? BathroomTileOverlay  {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor(red: 0.514, green: 0.682, blue: 0.800, alpha: 1.000)
            return renderer
        }
    }
    
  func makeUIView(context: Context) -> MKMapView {
      let mapView = MKMapView(frame: UIScreen.main.bounds)
      mapView.showsUserLocation = true
      mapView.isUserInteractionEnabled = false

      mapView.backgroundColor = .secondarySystemBackground
      
      let configuration = MKStandardMapConfiguration(emphasisStyle: .default)
      mapView.preferredConfiguration = configuration
      
      let camera = MKMapCamera()
      camera.heading = currentHeading
      camera.centerCoordinate = current.coordinate
      camera.centerCoordinateDistance = walkingDistance*4
      mapView.setCamera(camera, animated: true)
      
      let overlay = BathroomTileOverlay()
      overlay.canReplaceMapContent = true

      mapView.addOverlay(overlay, level: .aboveRoads)

      return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
      
      UIView.animate(withDuration: 0.1) {
//            uiView.setRegion(MKCoordinateRegion(center: current.coordinate, latitudinalMeters: self.walkingDistance*2, longitudinalMeters: self.walkingDistance*2), animated: true)
          
          let overlay = BathroomTileOverlay()
          overlay.canReplaceMapContent = true

          uiView.addOverlay(overlay, level: .aboveRoads)

          let camera = MKMapCamera()
          camera.heading = currentHeading
          camera.centerCoordinate = current.coordinate
          camera.centerCoordinateDistance = walkingDistance*4
          uiView.setCamera(camera, animated: true)
      } completion: { success in
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//              let bathrooms = bathroomAttendant.filteredBathrooms.filter({$0.distanceMeters(current: current)?.value ?? 0.0 <= self.walkingDistance})
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
  }
    
}
