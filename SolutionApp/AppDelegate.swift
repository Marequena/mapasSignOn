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
import AuthenticationServices


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Override point for customization after application launch.
    GMSServices.provideAPIKey("AIzaSyBxEPQo2wLw0KQsS0ESl9nVD_xukmAF4jg")
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
          switch credentialState {
          case .authorized:
              break // The Apple ID credential is valid.
          case .revoked, .notFound:
              // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
              DispatchQueue.main.async {
                  self.window?.rootViewController?.showLoginViewController()
              }
          default:
              break
          }
      }
      return true
  }

}

