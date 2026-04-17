import Flutter
import UIKit
import UserNotifications
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {


    GMSServices.provideAPIKey("AIzaSyCszQ7wLIITsDBibcqVvDHIxTV8sEhxZ58")

    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    return super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
  }
}