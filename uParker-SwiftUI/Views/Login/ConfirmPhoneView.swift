//
//  ConfirmPhoneView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/10/23.
//

import SwiftUI

struct ConfirmPhoneView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @State var phoneNumber: String
    
    // MARK: - BODY
    var body: some View {
        Text("Hello, World!")
    }
}

// MARK: - PREVIEW
struct ConfirmPhoneView_Previews: PreviewProvider {
    @State var phoneNumber = "(123) 456-7894"
    static var previews: some View {
        ConfirmPhoneView(phoneNumber: phoneNumber)
    }
}
