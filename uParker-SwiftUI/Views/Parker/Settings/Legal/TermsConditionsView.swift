//
//  TermsConditionsView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/28/23.
//

import SwiftUI

struct TermsConditionsView: View {
    let parkerResponsibilites: [String] = [
        "Accepting and paying any fees resulting from canceling a reservation.",
        "Reporting any complaint within 48 hours of the corresponding reservation’s end-time.",
        "Parking in the correct location at the correct address.",
        "Returning to their vehicle and leaving the Spot before reservation ends.",
        "Leaving accurate reviews of host.",
        "Monitoring the actions of any passengers they bring with them to the spot",
        "Accurate vehicle information.",
        "Requesting a time-extension with a “reasonable” heads-up.",
        "Only parking at the reservation during the agreed upon timeframe.",
        "Keeping track of all of their belongings.",
        "Not loitering on Host’s property.",
        "Leaving Spot in same or better condition as when they arrived. Respecting the Host’s property."
    ]
    
    let hostResponsibilities: [String] = [
        "Legally being allowed to rent out their parking spot with regard to city codes, land lord, private parking, etc.",
        "Accurate information on listings. Including clear, accurate images of their parking Spot.",
        "Fulfilling every agreed upon reservation or accepting any cancellation fees.",
        "Ensuring their Spot is available and vacant throughout the entire timespan of every reservation they have agreed to.",
        "Ensuring all available times, prices, and features on their listing are correct.",
        "Monitoring auto/manual accepting feature and preparing for any reservation that may have been automatically accepted.",
        "Accepting ratings and reviews given to them by parkers who have previously reserved their Spot.",
        "Reporting any complaint within 48 hours of the corresponding reservation’s end time.",
        "Ensuring spot is “As Promised”"
        
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Parker is responsible for:")
                    .modifier(TextMod(.title3, .semibold))
                    .padding(.top)
                
                ForEach(parkerResponsibilites, id: \.self) { str in
                    BulletPoint(text: str)
                        .padding(.horizontal, 6)
                }
                
                Text("Host is responsible for:")
                    .modifier(TextMod(.title3, .semibold))
                    .padding(.top)
                
                ForEach(hostResponsibilities, id: \.self) { str in
                    BulletPoint(text: str)
                        .padding(.horizontal, 6)
                }
                
                .padding(8)
            } //: VStack
            .padding()
        } //: Scroll
        .navigationTitle("Terms & Conditions")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct BulletPoint: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 6, height: 6, alignment: .top)
                .offset(x: 4, y: 8)
                .foregroundColor(.black)
            
            Text(text)
                .modifier(TextMod(.callout, .regular))
                .padding(.horizontal)
        } //: HStack
    } //: Body
}


struct TermsConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermsConditionsView()
        }
    }
}
