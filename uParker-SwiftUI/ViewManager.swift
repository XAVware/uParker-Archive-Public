//
//  ViewManager.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

import SwiftUI

struct ViewManager: View {
    @State var isLoggedIn: Bool = false
    var body: some View {
        ZStack {
            //Map View
            
            if isLoggedIn == false {
                LoginView()
            }
        }
    }
}

struct ViewManager_Previews: PreviewProvider {
    static var previews: some View {
        ViewManager()
    }
}
