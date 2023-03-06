//
//  NotificationSettingView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/6/23.
//

import SwiftUI

struct NotificationSettingView: View {
    // MARK: - PROPERTIES
    @Binding var notificationSetting: NotificationSetting
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reminders")
                .modifier(TextMod(.title2, .semibold))
            
            Text("Here are a few details about reminder notifications....")
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
            
            Spacer()
        } //: VStack
    }
}

struct NotificationSettingView_Previews: PreviewProvider {
    @State static var notification: NotificationSetting = NotificationSetting(title: "Reminders", description: "Here are a few details about reminder notifications....", group: .general, emailIsOn: true, pushIsOn: false, smsIsOn: true)
    
    static var previews: some View {
        NotificationSettingView(notificationSetting: $notification)
            .padding()
    }
}


struct NotificationSetting {
    enum Groups { case general, messages, hosting, reviews }
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
