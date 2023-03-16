//
//  NotificationSettingView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/6/23.
//

import SwiftUI

//struct NotificationSettingView: View {
//    // MARK: - PROPERTIES
//    @Environment(\.dismiss) var dismiss
//    @Binding var notificationSetting: NotificationSetting
//    @State var isButtonDisabled: Bool = true
//    
//    // MARK: - BODY
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(notificationSetting.title)
//                .modifier(TextMod(.title2, .semibold))
//            
//            Text(notificationSetting.description)
//                .modifier(TextMod(.callout, .light, .gray))
//                .multilineTextAlignment(.leading)
//                .padding(.bottom, 22)
//            
//            Toggle(isOn: $notificationSetting.emailIsOn) {
//                Text("Email Notifications:")
//                    .modifier(TextMod(.body, .regular))
//            }
//            
//            Toggle(isOn: $notificationSetting.pushIsOn) {
//                Text("Push Notifications:")
//                    .modifier(TextMod(.body, .regular))
//            }
//            .padding(.vertical, 22)
//            
//            Toggle(isOn: $notificationSetting.smsIsOn) {
//                Text("SMS/Text Notifications:")
//                    .modifier(TextMod(.body, .regular))
//            }
//            
//            Button {
//                dismiss.callAsFunction()
//            } label: {
//                Text("Save Changes")
//                    .frame(maxWidth: .infinity)
//            }
//            .modifier(RoundedButtonMod())
//            .disabled(isButtonDisabled)
//            .opacity(isButtonDisabled ? 0.55 : 1)
//            .padding(.top)
//
//            
//            Spacer()
//        } //: VStack
//        .onChange(of: notificationSetting) { _ in
//            isButtonDisabled = false
//        }
//    }
//}
//
//
//struct NotificationSetting: Equatable {
//    enum Groups: CaseIterable, Identifiable {
//        case general, hosting
//        var id: UUID { return UUID() }
//        
//        var header: String {
//            switch self {
//            case .general:
//                return "General"
//            case .hosting:
//                return "Hosting"
//            }
//        }
//        
//        var description: String {
//            switch self {
//            case .general:
//                return "Get important notifications about your account, reservations, and more."
//            case .hosting:
//                return "Hosting section description"
//            }
//        }
//    }
//    
//    let title: String
//    let description: String
//    let group: Groups
//    var emailIsOn: Bool
//    var pushIsOn: Bool
//    var smsIsOn: Bool
//    
//    var overviewText: String {
//        var optionsTurnedOn: [String] = [String]()
//        
//        if emailIsOn { optionsTurnedOn.append("Email") }
//        
//        if pushIsOn { optionsTurnedOn.append("Push") }
//        
//        if smsIsOn { optionsTurnedOn.append("SMS") }
//        
//        switch optionsTurnedOn.count {
//        case 0:
//            return "Off"
//        case 1:
//            return "On: \(optionsTurnedOn[0])"
//        case 2:
//            return "On: \(optionsTurnedOn[0]), \(optionsTurnedOn[1])"
//        case 3:
//            return "On: \(optionsTurnedOn[0]), \(optionsTurnedOn[1]), \(optionsTurnedOn[2])"
//        default:
//            return "Error"
//        }
//    }
//}
