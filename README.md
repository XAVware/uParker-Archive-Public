# uParker-Archive

A running repository of branches containing older versions of uParker.

API Keys and secrets have been revoked or deleted.
Privacy Policy, Terms of Service, FAQs, and other IP have been removed and errors will be thrown for missing files.

# uParker v0.3 SwiftUI

Archived 2023

iOS 16.1




# Firebase
[Firebase Auth, Firestore, and Functions](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/Login/LoginView.swift)

Phone verification
```swift
private func authorizePhone(phoneNum: String, completion: @escaping () -> Void) {
    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { verificationId, error in
        guard let verificationId = verificationId, error == nil else {
            AlertManager.shared.showError(title: "Error", message: error?.localizedDescription ?? "something went wrong - AddPhoneViewModel authorizePhone()")
            return
        }
        self.verificationId = verificationId
        completion()
    }
}

private func verifyCode(code: String, completion: @escaping () -> Void) {
    guard let verificationId = verificationId else { return }
    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
    Auth.auth().signIn(with: credential) { result, error in
        guard result != nil, error == nil else {
            AlertManager.shared.showError(title: "Error", message: error?.localizedDescription ?? "something went wrong - AddPhoneViewModel authorizePhone()")
            return
        }
        completion()
    }
}
```

Authentication using APNS Token
```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
}

func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if Auth.auth().canHandleNotification(notification) {
        completionHandler(.noData)
        return
    }
}

func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    if Auth.auth().canHandle(url) {
        return true
    }
    return false
}
```


# Stripe
In the [MainView](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/MainView.swift) 
```swift
func setupStripe() {
    Wallet.instance.customerContext = STPCustomerContext(keyProvider: StripeApiClient())

    let config = STPPaymentConfiguration.shared
    paymentContext = STPPaymentContext(customerContext: Wallet.instance.customerContext, configuration: config, theme: .defaultTheme)

    let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).last

    paymentContext.hostViewController = keyWindow?.rootViewController
}
```

Stripe users are created at signup through the [Rest API](https://github.com/XAVware/uParker-Archive-Public/blob/NodeServer/node.js)
```swift
Functions.functions().httpsCallable("createStripeUser").call(["email": self.regEmail]) { (result, error) in
    defer {
        Task { @MainActor in
            self.isRequestInProgress = false
        }
    }
    if let error = error { return }
    self.isLoggedIn = true
}
```

# Map & Spot Search

## [SearchView](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/Parker/Map/SearchView.swift)
- [Mapbox Geocoder](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/MapBox/MBGeocoder.swift)
- Realtime search suggestions

## [Map Result View](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/Parker/Map/SpotMapView2.swift)
Developed prior to Mapbox's SwiftUI SDK -> Built with UIKit, UIViewControllerRepresentable, and Coordinators.
- Pins added to map at the address of each result, linked to a card-type preview
- Map style selection
- Center on current location

## List Result View
Draggable/Floating list view that opens from bottom of screen via either tap, flick, or drag. View snaps into half-screen or full-screen mode.
> This was not extracted into it's own file, it can be found in the [MapView and MapViewModel](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/Parker/Map/SpotMapView2.swift)


## [Spot Listing](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/Parker/Map/SpotListingView.swift)
Depending on whether or not the user has selected a spot will determine if there is a partial screen preview of the spot or a full screen detailed view for the listing.
- [Observable Scrollview](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/CustomComponents/ObservableScrollView.swift) dictates the opacity of the header bar.


# PlateToVIN API
Option for user to add their vehicle information by entering their license plate. Relative files can be found at:
- [VehiclesView](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/Parker/Settings/Vehicles/VehiclesView.swift)
- [AddVehiclesView](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/Parker/Settings/Vehicles/AddVehicleView.swift)
- [VehiclePickerPanel](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/Parker/Settings/Vehicles/VehiclePickerPanel.swift)


# [Basic Chat](https://github.com/XAVware/uParker-Archive-Public/tree/Chat)

# Other Noteworthy Components:
- [Range Slider](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/CustomComponents/RangeSlider.swift)
    - A `Picker` type component with two handles, allowing you to select a range of values. 
- [Circular progress bar for reservation duration](https://github.com/XAVware/uParker-Archive-Public/blob/v0.3-SwiftUI/uParker-SwiftUI/Views/Parker/Reservations/ParkerReservationsView.swift)
