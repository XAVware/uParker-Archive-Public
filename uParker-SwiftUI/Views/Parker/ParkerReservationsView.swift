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
    
    let currentReservation: Reservation = reservations[0]
    
    //Ring
    @State private var drawingStroke = false
    
    let animation = Animation
        .easeOut(duration: 3)
        .repeatForever(autoreverses: false)
        .delay(0.5)
    
    let trim: CGFloat = 16
    
    var rotationDegrees: CGFloat {
        return 90 - (3.6 * trim / 2)
    }
    
    
    // MARK: - BODY
    var body: some View {
        VStack {
            if sessionManager.isLoggedIn == false {
                HeaderView(leftItem: nil, title: nil, rightItem: nil)
                NeedLoginView(title: "Reservations", mainHeadline: "Login to view your reservations", mainDetail: "Once you login, your upcoming and past reservations will appear here.")
            } else {
                Text("Reservations")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                
                ReservationsPicker(selectedIndex: $selection, options: self.options)
                
                VStack(spacing: 20) {
                    // MARK: - RING
                    Circle()
                        .trim(from: (trim * 0.01), to: 1)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundStyle(.tertiary)
                        .overlay {
                            Circle()
                                .trim(from: (trim * 0.01), to: drawingStroke ? 0 : 1)
                                .stroke(primaryColor.gradient,
                                        style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        }
                        .rotationEffect(.degrees(rotationDegrees))
                        .frame(width: 150)
                        .animation(animation, value: drawingStroke)
                        .onAppear {
                            drawingStroke.toggle()
                        }
                    
                    // MARK: - ADDRESS
                    VStack {
                        Text(currentReservation.streetAddress)
                            .foregroundColor(primaryColor)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Text("\(currentReservation.city) \(currentReservation.state), \(currentReservation.zipCode)")
                            .foregroundColor(primaryColor)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                    } //: VStack
                    
                } //: VStack
                .padding(.vertical)
            } //: If-Else
            
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
