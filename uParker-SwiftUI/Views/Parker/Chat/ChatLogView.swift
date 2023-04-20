//
//  ChatLogView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/1/23.
//

import SwiftUI


struct ChatLogView: View {
    // MARK: - PROPERTIES
    @State var tabBarVisibility: Visibility = .hidden
    @State var chatText: String = ""
    @State var messages: [String] = ["Fake", "Testing"]
    
    // MARK: - BODY
    var body: some View {
        VStack {
            messagesView
            
            chatBottomBar
            
        } //: VStack
        .toolbar(tabBarVisibility, for: .tabBar)
        .navigationTitle("Conversation")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            tabBarVisibility = .visible
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            VStack {
                Spacer()
                ForEach(messages, id: \.self) { message in
                    HStack {
                        Spacer()
                        
                        Text(message)
                            .modifier(TextMod(.body, .regular, .white))
                            .padding(12)
                            .background(primaryColor)
                            .cornerRadius(10)
                        
                    } //: HStack
                    .padding(.horizontal)
                    .padding(.top, 8)
                } //: For Each
                
                HStack {
                    Spacer()
                } //: HStack
            } //: VStack
        } //: Scroll
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(.gray)
            
            ZStack(alignment: .leading) {
                TextEditor(text: $chatText)
                    .frame(height: 42)
                    .background(.clear)
                
                if chatText.isEmpty {
                    Text("Message")
                        .padding(.leading, 6)
                        .modifier(TextMod(.callout, .regular, .gray))
                }
            }
            
            Button {
                guard chatText != "" else { return }
                messages.append(chatText)
                chatText = ""
            } label: {
                Text("Send")
                    .modifier(TextMod(.callout, .semibold, .white))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(primaryColor)
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
