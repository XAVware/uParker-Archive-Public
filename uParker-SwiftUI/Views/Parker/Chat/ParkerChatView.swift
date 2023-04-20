//
//  ParkerChatView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI
import MapboxMaps
import CoreLocation

struct ParkerChatView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                
//                if sessionManager.isLoggedIn == false {
//                    NeedLoginView(source: .chat)
////                    NeedLoginView(mainHeadline: "Login to view conversations", mainDetail: "Once you login, your message inbox will appear here.")
//                } else {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(1 ..< 6) { contact in
                                NavigationLink {
                                    ChatLogView()
                                } label: {
                                    HStack {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .padding(10)
                                            .foregroundColor(.gray)
                                            .frame(width: 50, height: 50, alignment: .center)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(.gray, lineWidth: 0.5)
                                            )
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .leading) {
                                            Text("<<Host Name>>")
                                                .modifier(TextMod(.title3, .regular))
                                            
                                            Text("Sample message preview ...")
                                                .modifier(TextMod(.callout, .light, .gray))
                                        } //: VStack
                                        .padding(.horizontal, 10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        VStack(alignment: .trailing) {
                                            Image(systemName: "smallcircle.filled.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 10)
                                            
                                            Text("5d")
                                                .modifier(TextMod(.caption, .bold))
                                        } //: VStack
                                        .foregroundColor(.black)
                                    } //: HStack
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity)
                                }
                                .frame(height: 70)
                                .background(.white)
                                
                                Divider()
                                
                            } //: ForEach
                        } //: VStack
                    } //: Scroll
//                } //: If-Else
                
                Spacer()
            } //: VStack
            .padding()
            .navigationTitle("Chat")
        }
    }
}

// MARK: - PREVIEW
struct ParkerChatView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerChatView()
            .environmentObject(SessionManager())
    }
}
