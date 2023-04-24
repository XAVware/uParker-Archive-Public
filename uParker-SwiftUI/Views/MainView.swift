//
//  MainView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/4/23.
//

import SwiftUI
import FirebaseAuth

@MainActor class MainViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isShowingLogin: Bool = false
    
    enum UserState { case needLogin, parker, host }
    
    init() {
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleFont = UIFont(descriptor: titleFont.fontDescriptor.withDesign(.rounded)?.withSymbolicTraits(.traitBold) ?? titleFont.fontDescriptor, size: titleFont.pointSize)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
    }
    
    //    func setupStripe() {
    //        Wallet.instance.customerContext = STPCustomerContext(keyProvider: StripeApiClient())
    //
    //        let config = STPPaymentConfiguration.shared
    //        paymentContext = STPPaymentContext(customerContext: Wallet.instance.customerContext, configuration: config, theme: .defaultTheme)
    //
    //        let keyWindow = UIApplication.shared.connectedScenes
    //                    .filter({$0.activationState == .foregroundActive})
    //                    .map({$0 as? UIWindowScene})
    //                    .compactMap({$0})
    //                    .first?.windows
    //                    .filter({$0.isKeyWindow}).last
    //
    //        paymentContext.hostViewController = keyWindow?.rootViewController
    //    }
    
    func changeLoginStatus(to status: Bool) {
        print("User Manager isLoggedIn changed: \(status)")
        isLoggedIn = status
        isShowingLogin = !status
    }
}

struct MainView: View {
    @StateObject var vm: MainViewModel = MainViewModel()
    @StateObject var userManager: UserManager = UserManager.shared
    
    var body: some View {
        VStack {
            if vm.isLoggedIn {
                if userManager.user?.userType == .host {
                    hostView
                } else {
                    parkerView
                }
            } else {
                LoginSignUpView()
            }
        } //: VStack
        .onReceive(userManager.$isLoggedIn, perform: { output in
            vm.changeLoginStatus(to: output)
        })
//        .fullScreenCover(isPresented: $vm.isShowingLogin) {
//            LoginView()
//                .ignoresSafeArea(.keyboard)
//        }
    } //: Body
    
    private var parkerView: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Park", systemImage: "car")
                }
            
            reservationsView
                .tabItem {
                    Label("Reservations", systemImage: "calendar")
                }
            
            chatView
                .tabItem {
                    Label("Chat", systemImage: "bubble.left.fill")
                }
            
            settingsView
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        } //: TabView
        .ignoresSafeArea(.keyboard)
    } //: Parker View
    
    @ViewBuilder private var reservationsView: some View {
        if vm.isLoggedIn {
            ParkerReservationsView()
        } else {
            VStack {
                NeedLoginView(source: .reservations, isShowingLoginView: $vm.isShowingLogin)
                Spacer()
            }
        }
    } //: Reservations View
    
    @ViewBuilder private var chatView: some View {
        if vm.isLoggedIn {
            ParkerChatView()
        } else {
            VStack {
                NeedLoginView(source: .chat, isShowingLoginView: $vm.isShowingLogin)
                Spacer()
            }
        }
    } //: Chat View
    
    @ViewBuilder private var settingsView: some View {
        if vm.isLoggedIn {
            ParkerSettingsView()
        } else {
            VStack {
                NeedLoginView(source: .profile, isShowingLoginView: $vm.isShowingLogin)
                SupportSettings()
                    .padding()
                Spacer()
            } //: VStack
        }
    } //: Settings View
    
    private var hostView: some View {
        VStack {
            Text("Hello, Host!")
            
            Button {
                //                self.sessionManager.userType = .parker
            } label: {
                Text("Change to parker")
            }
        } //: VStack
    }
}

// MARK: - PREVIEW
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
