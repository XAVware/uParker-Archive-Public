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
    
    @State var selection: Int = 1
    let options: [String] = ["Past", "Current", "Upcoming"]
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
                if sessionManager.isLoggedIn == false {
                    NeedLoginView(mainHeadline: "Login to view your reservations", mainDetail: "Once you login, your upcoming and past reservations will appear here.")
                } else {
                    ReservationsPicker(selectedIndex: $selection, options: self.options)
                    
                    switch(selection) {
                    case 0:
                        PastReservationsView()
                    case 1:
                        CurrentReservationView()
                    case 2:
                        UpcomingReservationsView()
                    default:
                        CurrentReservationView()
                    }
                } //: If-Else
                
                Spacer()
            } //: VStack
            .padding()
            .navigationTitle("Reservations")
        } //: Navigation View
        
    }
}

// MARK: - PREVIEW
struct ParkerReservationsView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerReservationsView()
            .environmentObject(SessionManager())
        
    }
}
