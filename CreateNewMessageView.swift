//
//  CreateNewMessageView.swift
//  FirebaseChat
//
//  Created by Smetana, Ryan on 1/23/23.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseAuth

class CreateNewMessageViewModel: ObservableObject {
    @Published var users: [ChatUser] = [ChatUser]()
    @Published var errorMessage: String = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        Firestore.firestore().collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users; \(error)"
                    print("Failed to fetch users; \(error)")
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    if user.uid != Auth.auth().currentUser?.uid {
                        self.users.append(.init(data: data))
                        
                    }
                })
                
            }
    }
}

struct CreateNewMessageView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm = CreateNewMessageViewModel()
    let didSelectNewUser: (ChatUser) -> ()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                ForEach(vm.users) { user in
                    Button {
                        dismiss.callAsFunction()
                        didSelectNewUser(user)
                    } label: {
                        HStack {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .scaledToFill()
                                .clipped()
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(.black, lineWidth: 1)
                                )
                            
                            Text(user.email)
                            Spacer()
                        } //: HStack
                        .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Divider()
                        .padding(.vertical, 8)
                }
            } //: Scroll
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        } //: NavigationView
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView(didSelectNewUser: { user in
            
        })
    }
}
