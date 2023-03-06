//
//  NotificationsView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/6/23.
//

import SwiftUI

@MainActor class NotificationsViewModel: ObservableObject {
    @Published var isShowingDetail: Bool = false
    @Published var tabBarVisibility: Visibility = .hidden
    @Published var notificationSettings: [NotificationSetting] = [
        NotificationSetting(title: "Reminders", description: "Get important reminders about your reservations, listings, and account activity.", group: .general, emailIsOn: true, pushIsOn: false, smsIsOn: true),
        NotificationSetting(title: "Reviews", description: "Get notified when someone leaves you a review or if you are able to leave someone a review.", group: .general, emailIsOn: true, pushIsOn: false, smsIsOn: true),
        NotificationSetting(title: "Messages", description: "Stay in touch with the host or parker throughout each reservation.", group: .general, emailIsOn: true, pushIsOn: false, smsIsOn: true)
    ]

}

struct NotificationsView: View {
    // MARK: - PROPERTIES
    @StateObject var vm: NotificationsViewModel = NotificationsViewModel()
    
    // MARK: - BODY
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("General")
                    .modifier(TextMod(.title, .semibold))
                
                Text("Get important notifications about your account, reservations, and more.")
                    .modifier(TextMod(.callout, .light, .gray))
                    .multilineTextAlignment(.leading)
                
                ForEach(vm.notificationSettings.filter { $0.group == .general }, id: \.title) { notificationSetting in
                    SettingsButton(setting: notificationSetting)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            vm.isShowingDetail = true
                        }
                }
                
                
                Divider()
            } //: VStack
            .padding(.top)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        } //: Scroll
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.automatic)
        .sheet(isPresented: $vm.isShowingDetail) {
            NotificationSettingView(notificationSetting: $vm.notificationSettings[0])
                .presentationDetents([.fraction(0.40)])
                .presentationDragIndicator(.visible)
                .padding()
                .padding(.top, 16)
        }
        .onDisappear {
            vm.tabBarVisibility = .visible
        }
        .toolbar(vm.tabBarVisibility, for: .tabBar)
    }
    
    
    struct SettingsButton: View {
        var setting: NotificationSetting
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(setting.title)
                        .modifier(TextMod(.headline, .regular))
                    
                    Text(setting.overviewText)
                        .modifier(TextMod(.callout, .light, .gray))
                } //: VStack
                
                Spacer()
                
                Text("Edit")
                    .underline()
                    .modifier(TextMod(.callout, .semibold))
            } //: HStack
        }
    }
    
    
}

// MARK: - PREVIEW
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationsView()
        }
    }
}
