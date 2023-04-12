//
//  MapOuterView.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @StateObject private var bathroomAttendant = BathroomAttendant.shared
    @StateObject private var locationAttendant = LocationAttendant.shared
    @Binding var bathroom: Bathroom

    class Coordinator: NSObject, MKMapViewDelegate {        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? BathroomTileOverlay  {
                return MKTileOverlayRenderer(tileOverlay: tileOverlay)
            } else if let circle = overlay as? MKCircle {
                let renderer = MKCircleRenderer(circle: circle)
                renderer.fillColor = .systemBlue
                return renderer
            } else {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.lineWidth = 8.0
                renderer.strokeColor = UIColor(red: 0.514, green: 0.682, blue: 0.800, alpha: 1.000)
                return renderer
            }
        }
    }
    
    class BathroomTileOverlay : MKTileOverlay {
        override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
            result(UIColor.secondarySystemBackground.image().pngData(), nil)
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
      
      let configuration = MKStandardMapConfiguration(emphasisStyle: .muted)
      mapView.preferredConfiguration = configuration
      
//      let overlay = BathroomTileOverlay()
//      overlay.canReplaceMapContent = true
//      mapView.addOverlay(overlay, level: .aboveRoads)
      
      mapView.delegate = context.coordinator
      if let annotation = bathroom.annotation {
          mapView.addAnnotation(annotation)
      }
      
      let camera = MKMapCamera()
      if let current = locationAttendant.current {
          camera.centerCoordinate = current.coordinate.midpointTo(location: bathroom.coordinate )
      }
      if let current = locationAttendant.current, let distance = bathroom.distanceMeters(current: current)?.value {
          camera.centerCoordinateDistance = distance*2.5
      }
      camera.heading = locationAttendant.currentHeading
      mapView.camera = camera
      
      if let route = bathroom.route {
          mapView.addOverlay((route.polyline), level: .aboveRoads)
      }
      return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
      let camera = MKMapCamera()

      camera.heading = locationAttendant.currentHeading

      if let current = locationAttendant.current {
          camera.centerCoordinate = current.coordinate.midpointTo(location: bathroom.coordinate)
      }
      if let current = locationAttendant.current, let distance = bathroom.distanceMeters(current: current)?.value {
          camera.centerCoordinateDistance = distance*2.5
      }
      if let route = bathroom.route {
          uiView.addOverlay((route.polyline), level: .aboveRoads)
          
//              let step = route.steps[1].polyline
//              var count = 0
//              for point in UnsafeBufferPointer(start: step.points(), count: step.pointCount) {
//                  uiView.addAnnotation(Annotation(title: "\(count)", coordinate: point.coordinate))
//                  count += 1
//              }
      }

      uiView.camera = camera
  }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(bathroom: .constant(BathroomAttendant.shared.closestBathroom))
    }
}

