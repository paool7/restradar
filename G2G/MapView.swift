//
//  MapOuterView.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @ObservedObject var attendant = BathroomAttendant.shared
    @ObservedObject var locationAttendant = LocationAttendant.shared
    @State var id: Int

    class Coordinator: NSObject, MKMapViewDelegate {        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? BathroomTileOverlay  {
                return MKTileOverlayRenderer(tileOverlay: tileOverlay)
            } else {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.lineWidth = 8.0
                renderer.strokeColor = .green.withAlphaComponent(0.6)
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
      
      mapView.backgroundColor = .secondarySystemBackground
      
//      let configuration = MKStandardMapConfiguration(emphasisStyle: .muted)
//      mapView.preferredConfiguration = configuration
      
      let overlay = BathroomTileOverlay()
      overlay.canReplaceMapContent = true
      mapView.addOverlay(overlay, level: .aboveRoads)
      
      if let bathroom = attendant.defaults.first(where: {$0.id == self.id}) {
          mapView.delegate = context.coordinator
          if let annotation = bathroom.annotation {
              mapView.addAnnotation(annotation)
          }
          
          let camera = MKMapCamera()
          if let current = locationAttendant.current {
              camera.centerCoordinate = current.coordinate.midpointTo(location: bathroom.coordinate )
          }
          if let distance = bathroom.distanceMeters {
              camera.centerCoordinateDistance = distance*2.5
          }
          camera.heading = locationAttendant.currentHeading
          mapView.camera = camera
          
          if let route = bathroom.route {
              mapView.addOverlay((route.polyline), level: .aboveRoads)
          }
      }
      return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
      let camera = MKMapCamera()

      camera.heading = locationAttendant.currentHeading

      if let bathroom = attendant.defaults.first(where: {$0.id == self.id}) {
          if let annotation = bathroom.annotation, !uiView.annotations.contains(where: {$0 as? Annotation == annotation}) {
              uiView.addAnnotation(annotation)
          }

          if let current = locationAttendant.current {
              camera.centerCoordinate = current.coordinate.midpointTo(location: bathroom.coordinate)
          }
          if let distance = bathroom.distanceMeters {
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
      }

      uiView.camera = camera
  }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(id: 2)
    }
}

