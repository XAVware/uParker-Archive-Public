//
//  SessionManager.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/21/22.
//

import SwiftUI

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isShowingSignUp: Bool = false
    
    @Published var userType: UserType = .parker
    
    @Published var isShowingLoginModal: Bool = true
    
    enum UserType { case parker, host}
    
    
    func logIn() {
        self.isLoggedIn = true
        self.isShowingLoginModal = false
    }
}
