//
//  ParkerReservationsView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct ParkerReservationsView: View {
    // MARK: - PROPERTIES
//    @EnvironmentObject var sessionManager: SessionManager
    
    @State var selection: Int = 1
    let options: [String] = ["Past", "Current", "Upcoming"]
    
    // MARK: - PROPERTIES
    let currentReservation: Reservation = reservations[0]
    
    //Timer
    @State var timeRemaining: Int = 10
    @State var isTimerRunning: Bool = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //Ring
    @State private var drawingStroke = false
    
    var ringAnimation: Animation {
        let secondsRemaining: Double = Double(Double(timeRemaining) + ((360 / trim) / 10))
        return Animation.linear(duration: Double(secondsRemaining))
    }
    
    let trim: CGFloat = 16
    
    var rotationDegrees: CGFloat {
        return 90 - (3.6 * trim / 2)
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
//                if sessionManager.isLoggedIn == false {
//                    NeedLoginView(source: .reservations)
////                    NeedLoginView(mainHeadline: "Login to view your reservations", mainDetail: "Once you login, your upcoming and past reservations will appear here.")
//                } else {
                    ReservationsPicker(selectedIndex: $selection, options: self.options)
                    
                    switch(selection) {
                    case 0:
                        pastReservations
                    case 1:
                        currentReservations
                    case 2:
                        upcomingReservations
                    default:
                        currentReservations
                    }
//                } //: If-Else
                
                Spacer()
            } //: VStack
            .padding()
            .navigationTitle("Reservations")
        } //: Navigation View
        
    } //: Body
    
    private var currentReservations: some View {
        VStack(spacing: 20) {
            ZStack {
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
                    .frame(width: 180)
                    .animation(ringAnimation, value: drawingStroke)
                
                if isTimerRunning {
                    Text("\(timeRemaining)")
                        .foregroundColor(primaryColor)
                        .modifier(TextMod(.largeTitle, .semibold))
                        .onReceive(timer) { _ in
                            if self.timeRemaining <= 0 {
                                self.isTimerRunning = false
                                self.drawingStroke = false
                            } else {
                                guard self.isTimerRunning else {
                                    return
                                }
                                timeRemaining -= 1
                            }
                        }
                } else {
                    Button {
                        self.isTimerRunning = true
                        self.drawingStroke = true
                    } label: {
                        Text("Arrive")
                    }
                    .foregroundColor(primaryColor)
                    .modifier(TextMod(.title, .semibold))

                }

            } //: ZStack
            .padding(.top)
            
            Spacer()
            // MARK: - ADDRESS
            VStack {
                Text(currentReservation.streetAddress)
                    .modifier(TextMod(.title2, .semibold, primaryColor))
                
                Text("\(currentReservation.city) \(currentReservation.state), \(currentReservation.zipCode)")
                    .modifier(TextMod(.title3, .regular, primaryColor))
            } //: VStack
            
            Spacer()
            
            // MARK: - BUTTON PANEL
            VStack {
                HStack {
                    ReservationPanelButton(iconName: "arrow.up.arrow.down.square", text: "Directions") {
                        //
                    }
                    Divider()
                    ReservationPanelButton(iconName: "plus.circle", text: "Extend") {
                        //
                    }
                } //: HStack
                HStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(height: 0.5)
                        .opacity(0.5)
                    
                    Spacer()
                
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(height: 0.5)
                        .opacity(0.5)
                } //: HStack
                HStack {
                    ReservationPanelButton(iconName: "xmark.circle", text: "Cancel") {
                        //
                    }
                    .foregroundColor(.red)
                    Divider()
                    ReservationPanelButton(iconName: "envelope", text: "Contact Host") {
                        //
                    }
                } //: HStack
                
            } //: VStack
            .frame(maxWidth: 350, maxHeight: 300)
            .padding(.vertical)
            
        } //: VStack
        .padding(.vertical)
    } //: Current Reservations
    
    private var pastReservations: some View {
        Text("Past Reservations")
    } //: Past Reservations
    
    private var upcomingReservations: some View {
        Text("Upcoming Reservations")
    } //: Upcoming Reservations
}

// MARK: - PREVIEW
struct ParkerReservationsView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerReservationsView()
//            .environmentObject(SessionManager())
        
    }
}
