//
//  ParkerReservationsView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct ParkerReservationsView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager

    // MARK: - BODY
    var body: some View {
        VStack {
            HeaderView(leftItem: nil, title: nil, rightItem: nil)
            
            NeedLoginView(title: "Reservations", mainHeadline: "Login to view your reservations", mainDetail: "Once you login, your upcoming and past reservations will appear here.")
            
            Spacer()
        } //: VStack
        .padding()
    }
}

// MARK: - PREVIEW
struct ParkerReservationsView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerReservationsView()
            .environmentObject(SessionManager())

    }
}
