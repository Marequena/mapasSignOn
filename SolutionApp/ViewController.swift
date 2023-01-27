// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import GoogleMaps
import GoogleMapsUtils
import AuthenticationServices
import PDFKit

class ViewController: UIViewController, GMSMapViewDelegate {

  private var mapView: GMSMapView!
  private var clusterManager: GMUClusterManager!
  private var circle: GMSCircle? = nil

    var locationsMap : clsLocations = clsLocations()
    
    @IBAction func SignOut(_ sender: UIBarButtonItem) {
        // For the purpose of this demo app, delete the user identifier that was previously stored in the keychain.
        KeychainItem.deleteUserIdentifierFromKeychain()
        
       
        // Display the login controller again.
        DispatchQueue.main.async {
            self.showLoginViewController()
        }
    }
    private let locationManager = CLLocationManager()

    
    override func loadView() {

    // Load the map at set latitude/longitude and zoom level
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 11)

    mapView = GMSMapView(frame: .zero, camera: camera)
        self.view = mapView
    mapView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()

      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
      
    


  }

  // MARK: GMSMapViewDelegate

  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

    // Clear previous circles
    circle?.map = nil

    // Animate to the marker
    mapView.animate(toLocation: marker.position)

    // If the tap was on a marker cluster, zoom in on the cluster
    if let _ = marker.userData as? GMUCluster {
      mapView.animate(toZoom: mapView.camera.zoom + 1)
      return true
    }

    // Draw a new circle around the tapped marker
    circle = GMSCircle(position: marker.position, radius: 800)
    circle?.fillColor = UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 0.5)
    circle?.map = mapView
    return false
  }

    
    
    
    
    
   
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "previewPdf" {
        guard let vc = segue.destination as? PDFViewController else { return }
        let pdfCreator = PDFCreator()
        vc.documentData = pdfCreator.createPDF()
      }
    }
    
    
    
}




// MARK: - CLLocationManagerDelegate
//1
extension ViewController: CLLocationManagerDelegate {
  // 2
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // 3
    guard status == .authorizedWhenInUse else {
      return
    }
    // 4
    locationManager.startUpdatingLocation()
      
    //5
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
  // 6
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
      // Add a single marker with a custom icon
      let mapCenter = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
      
      let marker = GMSMarker(position: mapCenter)

      marker.icon = UIImage(named: "custom_pin.png")
      marker.map = mapView
    
      if let clsLoc : [locationsMap]? = UserDefaults.standard.retrieveCodable(for: "locationsMap"){
          clsLoc?.forEach({ loc in
              locationsMap.loc.append(loc)
          })
      }
          let newLocation = SolutionApp.locationsMap(lat:location.coordinate.latitude.description,lan:location.coordinate.longitude.description)
      locationsMap.loc.append(newLocation)
      UserDefaults.standard.storeCodable(locationsMap.loc, key: "locationsMap")
    // 7
    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      
    // 8
    locationManager.stopUpdatingLocation()
  }
}



//MARK: - UserDefaults + Codable
extension UserDefaults {
    func storeCodable<T: Codable>(_ object: T, key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch let error {
            print("Error encoding: \(error)")
        }
    }
    
    func retrieveCodable<T: Codable>(for key: String) -> T? {
        do {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print("Error decoding: \(error)")
            return nil
        }
    }
}
