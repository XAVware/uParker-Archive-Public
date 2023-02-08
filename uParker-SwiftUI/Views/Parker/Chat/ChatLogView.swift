//
//  ChatLogView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/1/23.
//

import SwiftUI


struct ChatLogView: View {
    
    @State var chatText: String = ""
    
    var body: some View {
        VStack {
            messagesView
            
            chatBottomBar
            
        } //: VStack
//        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10) { num in
                HStack {
                    Spacer()
                    
                    HStack {
                        Text("Fake")
                            .modifier(TextMod(.callout, .regular, .white))
                    } //: HStack
                    .padding()
                    .background(.blue)
                    .cornerRadius(8)
                } //: HStack
                .padding(.horizontal)
                .padding(.top, 8)
            }
            
            HStack { Spacer() }
        } //: Scroll
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            
            ZStack(alignment: .leading) {
                TextEditor(text: $chatText)
                    .frame(height: 42)
                    .background(.clear)
                
                if chatText.isEmpty {
                    Text("Description")
                        .padding(.leading, 6)
                        .modifier(TextMod(.callout, .regular, Color(.darkGray)))
                }
            }
            Button {
                //
            } label: {
                Text("Send")
                    .modifier(TextMod(.callout, .semibold, .white))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.blue)
            .cornerRadius(5)

        } //: HStack
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView()
        }
    }
}
