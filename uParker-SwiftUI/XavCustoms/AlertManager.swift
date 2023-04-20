//
//  AlertManager.swift
//  CogCalendar2023
//
//  Created by Smetana, Ryan on 4/19/23.
//

import SwiftUI

class AlertManager: ObservableObject {
    static let shared: AlertManager = AlertManager()
    @Published var isShowing: Bool = false
    var alert: Alert = Alert(title: Text(""))
    
    private init() { }
    
    func showError(title: String, message: String) {
        self.alert = Alert(title: Text(title), message: Text(message))
        self.isShowing.toggle()
    }
}
