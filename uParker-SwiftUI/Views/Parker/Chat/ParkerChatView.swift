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
                
                if sessionManager.isLoggedIn == false {
                    HeaderView(leftItem: nil, title: nil, rightItem: nil)
                    NeedLoginView(title: "Chat", mainHeadline: "Login to view conversations", mainDetail: "Once you login, your message inbox will appear here.")
                } else {
                    HeaderView(leftItem: nil, title: "Inbox", rightItem: .settings)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(1 ..< 6) { contact in
                                NavigationLink {
                                    ChatLogView()
                                } label: {
                                    HStack {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 28))
                                            .padding(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 44)
                                                    .stroke(lineWidth: 1)
                                            )
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .leading) {
                                            Text("<<Host Name>>")
                                                .modifier(TextMod(.title3, .regular))
                                            
                                            Text("Sample message preview ...")
                                                .modifier(TextMod(.callout, .regular, .gray))
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
                } //: If-Else
                
                Spacer()
            } //: VStack
            .padding()
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
