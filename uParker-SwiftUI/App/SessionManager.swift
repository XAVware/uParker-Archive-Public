//
//  SessionManager.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/21/22.
//

import SwiftUI

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = true
    @Published var isShowingLoginModal: Bool = false
    @Published var isShowingSignUpModal: Bool = false
    
    @Published var userType: UserType = .parker
    
    enum UserType { case parker, host}
    
    func logIn() {
        self.isLoggedIn = true
        self.isShowingLoginModal = false
        self.isShowingSignUpModal = false
    }
    
    func logOut() {
        self.isLoggedIn = false
    }
}
