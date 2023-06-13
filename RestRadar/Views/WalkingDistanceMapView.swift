//
//  MapOuterView.swift
//  G2G
//
//  Created by Paul Dippold on 3/25/23.
//

import MapKit
import SwiftUI

class WalkingDistanceOverlay: NSObject, MKOverlay {
    let coordinate: CLLocationCoordinate2D
    let boundingMapRect: MKMapRect
    let distanceString: String
    var currentHeading: CLLocationDegrees

    init(bathroom: Bathroom, current: CLLocationCoordinate2D, distance: Double, distanceString: String, currentHeading: CLLocationDegrees) {
        self.distanceString = distanceString
        self.currentHeading = currentHeading
        
        let pointsPerMeter = MKMapPointsPerMeterAtLatitude(current.latitude)
        let width = distance * pointsPerMeter
        
        let point = MKMapPoint(current)
        boundingMapRect = MKMapRect(origin: MKMapPoint(x: point.x-(width/2), y: point.y-(width/2)), size: MKMapSize(width: width, height: width))
        coordinate = current
  }
}

class WalkingDistanceOverlayView: MKOverlayRenderer {
    var distanceString: String
    var currentHeading: CLLocationDegrees

    let label: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.text = "Hello"
        return lbl
    }()
    
    init(overlay: MKOverlay, distanceString: String, currentHeading: CLLocationDegrees) {
        self.distanceString = distanceString
        self.currentHeading = currentHeading
        super.init(overlay: overlay)
    }

  override func draw(
    _ mapRect: MKMapRect,
    zoomScale: MKZoomScale,
    in context: CGContext
  ) {
      let rect = self.rect(for: overlay.boundingMapRect)
      
      let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
      let radius = min(rect.width, rect.height) / 2
       
      context.setLineWidth(400)
      
      context.setStrokeColor(Color.primary.cgColor ?? UIColor.white.cgColor)
      let startAngle = 1.07 + currentHeading.radians
      let endAngle = 2.07 + currentHeading.radians
      
      context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
      
      context.strokePath()

      // Set Drawing mode
      context.setTextDrawingMode(.fillStroke)
      context.textMatrix = CGAffineTransformMakeScale(1.0, -1.0);
      // Text size is crazy big because label has to be miles across
      // to be visible.
      var attrs = [ NSAttributedString.Key : Any]()
      attrs[NSAttributedString.Key.font] =
      
      attrs[NSAttributedString.Key.foregroundColor] = UIColor(Color.black)
      let attributedString = NSAttributedString(string: "Hello", attributes: attrs)
      let line = CTLineCreateWithAttributedString(attributedString)
      
      // Center is lat-lon, but map is in meters (maybe? definitely
      // not lat-lon). Center string and draw.
      // There is no "at" on CTLineDraw. The string
      // is positioned in the context.
      let textCenter = CGPoint(x: rect.width / 2, y: rect.height - 100)
      context.textPosition = textCenter
      CTLineDraw(line, context)
  }
}


struct WalkingDistanceMapView: UIViewRepresentable {
    @ObservedObject private var bathroomAttendant = BathroomAttendant.shared
    @ObservedObject private var locationAttendant = LocationAttendant.shared
    @StateObject var bathroom: Bathroom
    
    @Binding var walkingDistance: Double
    @Binding var current: CLLocation
    @Binding var currentHeading: CLLocationDegrees

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let overlay = overlay as? WalkingDistanceOverlay {
                return WalkingDistanceOverlayView(overlay: overlay, distanceString: overlay.distanceString, currentHeading: overlay.currentHeading)
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
      camera.heading = currentHeading
      camera.centerCoordinate = current.coordinate
      camera.centerCoordinateDistance = walkingDistance*4
      mapView.setCamera(camera, animated: true)

      return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
      uiView.removeOverlays(uiView.overlays)
      if let distanceString = bathroom.distanceString {
          uiView.addOverlay(WalkingDistanceOverlay(bathroom: bathroom, current: current.coordinate, distance: (walkingDistance * 2.0), distanceString: distanceString, currentHeading: currentHeading), level: .aboveLabels)
      }
      
      UIView.animate(withDuration: 0.1) {
//            uiView.setRegion(MKCoordinateRegion(center: current.coordinate, latitudinalMeters: self.walkingDistance*2, longitudinalMeters: self.walkingDistance*2), animated: true)

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
