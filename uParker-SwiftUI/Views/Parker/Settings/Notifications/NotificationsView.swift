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
        NotificationSetting(title: "Reviews", description: "Get notified when someone leaves you a review or if you are able to leave someone a review.", group: .general, emailIsOn: true, pushIsOn: true, smsIsOn: true),
        NotificationSetting(title: "Messages", description: "Stay in touch with the host or parker throughout each reservation.", group: .general, emailIsOn: true, pushIsOn: false, smsIsOn: true),
        NotificationSetting(title: "News & Updates", description: "Stay up to date on what's new with uParker.", group: .general, emailIsOn: false, pushIsOn: false, smsIsOn: true),
        NotificationSetting(title: "Tips", description: "Receive daily tips to increase your sales.", group: .hosting, emailIsOn: true, pushIsOn: true, smsIsOn: false),
        NotificationSetting(title: "Market Trends", description: "Receive notifications for ", group: .hosting, emailIsOn: true, pushIsOn: true, smsIsOn: false)
    ]
    
    @Published var selectedIndex: Int = 0
    
    func settingTapped(setting: NotificationSetting) {
        selectedIndex = notificationSettings.firstIndex(of: setting) ?? 0
        isShowingDetail = true
    }
   
}

struct NotificationsView: View {
    // MARK: - PROPERTIES
    @StateObject var vm: NotificationsViewModel = NotificationsViewModel()
    
    // MARK: - BODY
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(NotificationSetting.Groups.allCases) { group in
                    Text(group.header)
                        .modifier(TextMod(.title, .semibold))
                        .padding(.top)
                    
                    Text(group.description)
                        .modifier(TextMod(.callout, .light, .gray))
                        .multilineTextAlignment(.leading)
                    
                    ForEach(vm.notificationSettings.filter { $0.group == group }) { notificationSetting in
                        SettingsButton(setting: notificationSetting)
                            .padding(.vertical, 8)
                            .environmentObject(vm)
                    }
                    
                    Divider()
                }
            } //: VStack
            .padding(.top)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        } //: Scroll
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.automatic)
        .sheet(isPresented: $vm.isShowingDetail) {
            NotificationSettingView(notificationSetting: $vm.notificationSettings[vm.selectedIndex])
                .presentationDetents([.fraction(0.40)])
                .presentationDragIndicator(.visible)
                .padding()
                .padding(.top, 24)
        }
        .onDisappear {
            vm.tabBarVisibility = .visible
        }
        .toolbar(vm.tabBarVisibility, for: .tabBar)
    }
    
    
    struct SettingsButton: View {
        @EnvironmentObject var vm: NotificationsViewModel
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
            .background(Color.white)
            .onTapGesture {
                vm.settingTapped(setting: setting)
            }
            
        } //: Body
    }
    
    
}

// MARK: - PREVIEW
//struct NotificationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            NotificationsView()
//        }
//    }
//}

struct NotificationSettingView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @Binding var notificationSetting: NotificationSetting
    @State var isButtonDisabled: Bool = true
    
    //Improve this... use in case of nil optional notification setting toggle values
    @State var defaultEmail: Bool = true
    
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            Text(notificationSetting.title)
                .modifier(TextMod(.title2, .semibold))
            
            Text(notificationSetting.description)
                .modifier(TextMod(.callout, .light, .gray))
                .multilineTextAlignment(.leading)
                .padding(.bottom, 22)
            
            Toggle(isOn: $notificationSetting.emailIsOn) {
                Text("Email Notifications:")
                    .modifier(TextMod(.body, .regular))
            }
            
            Toggle(isOn: $notificationSetting.pushIsOn) {
                Text("Push Notifications:")
                    .modifier(TextMod(.body, .regular))
            }
            .padding(.vertical, 22)
            
            Toggle(isOn: $notificationSetting.smsIsOn) {
                Text("SMS/Text Notifications:")
                    .modifier(TextMod(.body, .regular))
            }
            
            Button {
                dismiss.callAsFunction()
            } label: {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())
            .disabled(isButtonDisabled)
            .opacity(isButtonDisabled ? 0.55 : 1)
            .padding(.top)

            
            Spacer()
        } //: VStack
        .onChange(of: notificationSetting) { _ in
            isButtonDisabled = false
        }
        
    }
}


struct NotificationSetting: Equatable, Identifiable {
    enum Groups: CaseIterable, Identifiable {
        case general, hosting
        var id: UUID { return UUID() }
        
        var header: String {
            switch self {
            case .general:
                return "General"
            case .hosting:
                return "Hosting"
            }
        }
        
        var description: String {
            switch self {
            case .general:
                return "Get important notifications about your account, reservations, and more."
            case .hosting:
                return "Hosting section description"
            }
        }
    }
    
    let id: UUID = UUID()
    let title: String
    let description: String
    let group: Groups
    var emailIsOn: Bool
    var pushIsOn: Bool
    var smsIsOn: Bool
    
    var overviewText: String {
        var optionsTurnedOn: [String] = [String]()
        
        if emailIsOn { optionsTurnedOn.append("Email") }
        
        if pushIsOn { optionsTurnedOn.append("Push") }
        
        if smsIsOn { optionsTurnedOn.append("SMS") }
        
        switch optionsTurnedOn.count {
        case 0:
            return "Off"
        case 1:
            return "On: \(optionsTurnedOn[0])"
        case 2:
            return "On: \(optionsTurnedOn[0]), \(optionsTurnedOn[1])"
        case 3:
            return "On: \(optionsTurnedOn[0]), \(optionsTurnedOn[1]), \(optionsTurnedOn[2])"
        default:
            return "Error"
        }
    }
}
