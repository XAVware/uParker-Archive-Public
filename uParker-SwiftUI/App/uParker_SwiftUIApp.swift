//
//  uParker_SwiftUIApp.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
    FirebaseApp.configure()
    return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("\(#function)")
    Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("\(#function)")
    if Auth.auth().canHandleNotification(notification) {
      completionHandler(.noData)
      return
    }
  }
  
  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    print("\(#function)")
    if Auth.auth().canHandle(url) {
      return true
    }
    return false
  }
}

@main
struct uParker_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    init() {
//        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
//        FirebaseApp.configure()
//    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
//                .onOpenURL { url in
//                  print("Received URL: \(url)")
//                  Auth.auth().canHandle(url) // <- just for information purposes
//                }
        }
    }
}
