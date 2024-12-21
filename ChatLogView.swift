//
//  ChatLogView.swift
//  FirebaseChat
//
//  Created by Smetana, Ryan on 1/26/23.
//

import SwiftUI
import Firebase

struct FirebaseConstants {
    static let timestamp = "timestamp"
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
    static let uid = "uid"
}

class ChatLogViewModel: ObservableObject {
    @Published var chatText: String = ""
    @Published var errorMessage: String = ""
    
    @Published var chatMessages = [ChatMessage]()
    
    var chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    var firestoreListener: ListenerRegistration?
    
    func fetchMessages() {
        
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let docId = change.document.documentID
                        let chatMessage = ChatMessage(documentId: docId, data: data)
                        self.chatMessages.append(chatMessage)
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }

            }
    }
    
    func handleSend() {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        //There is a better way to do the following, look into encoding with FirebaseFirestoreSwift package
        let messageData = [FirebaseConstants.fromId : fromId, FirebaseConstants.toId : toId, FirebaseConstants.text : self.chatText, "timestamp" : Timestamp()] as [String : Any]
        
        let document = Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        document.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
            }
            print("Successfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = Firestore.firestore()
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
            }
            print("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        let document = Firestore.firestore()
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, err in
            if let error = err {
                print("Failed to fetch current user: \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No Data Found"
                return
            }
            
            
            let currentUser = ChatUser(data: data)
            
//            guard let currentUser = currentUser else { return }
            
            let recipientRecentMessageDictionary = [
                FirebaseConstants.timestamp: Timestamp(),
                FirebaseConstants.text: self.chatText,
                FirebaseConstants.fromId: uid,
                FirebaseConstants.toId: toId,
                FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
                FirebaseConstants.email: currentUser.email
            ] as [String : Any]
            
            Firestore.firestore()
                .collection("recent_messages")
                .document(toId)
                .collection("messages")
                .document(currentUser.uid)
                .setData(recipientRecentMessageDictionary) { error in
                    if let error = error {
                        print("Failed to save recipient recent message: \(error)")
                        return
                    }
                }
        }
        
    }
    
    @Published var count = 0
    
}

struct ChatLogView: View {
    
//    let chatUser: ChatUser?
    
    @ObservedObject var vm: ChatLogViewModel
    
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//        self.vm = ChatLogViewModel(chatUser: chatUser)
//    }
    
    var body: some View {
        ZStack {
            messagesView
            
            Text(vm.errorMessage)
        } //: ZStack
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            vm.firestoreListener?.remove()
        }
        
    }
    static let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                ForEach(vm.chatMessages) { message in
                    MessageView(message: message)
                }
                
                HStack { Spacer() }
                    .id(Self.emptyScrollToString)
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                        }
                    }
            }
            
        } //: Scroll
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom) {
            chatBottomBar
                .background(Color(.systemBackground).ignoresSafeArea())
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            
            ZStack(alignment: .leading) {
                Text("Description")
                    .padding(.leading, 6)
                
                TextEditor(text: $vm.chatText)
                    .frame(height: 42)
                    .background(.clear)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
                
            }
            
            Button {
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
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

struct MessageView: View {
    let message: ChatMessage
    var body: some View {
        VStack {
            if message.fromId == Auth.auth().currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    } //: HStack
                    .padding()
                    .background(.blue)
                    .cornerRadius(8)
                } //: HStack
                .padding(.horizontal)
                .padding(.top, 8)
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(.black)
                    } //: HStack
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    Spacer()
                } //: HStack
            }
        } //: VStack
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

//struct ChatLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ChatLogView(chatUser: .init(data: ["uid": "123", "email": "ryanuser3@gmail.com"]))
//        }
//    }
//}
