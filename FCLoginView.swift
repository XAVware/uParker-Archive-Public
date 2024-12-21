//
//  LoginView.swift
//  FirebaseChat
//
//  Created by Smetana, Ryan on 1/14/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct FCLoginView: View {
    // MARK: - PROPERTIES
    let didCompleteLoginProcess: () -> ()
    
    @State private var isLoginMode: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginStatusMessage: String = ""
    @State private var shouldShowImagePicker: Bool = false
    @State private var image: UIImage?
        
    // MARK: - FUNCTIONS
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user: \(err)")
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            
            print("Successfully logged in user \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged in user \(result?.user.uid ?? "")"
            
            self.didCompleteLoginProcess()
        }
    }
    
    private func createNewAccount() {
        if self.image == nil {
            self.loginStatusMessage = "You must select an avatar image"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user: \(err)")
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
//        let filename = UUID().uuidString
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Storage.storage().reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        ref.putData(imageData, metadata: nil) { CAEDRMetadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
//                print(url?.absoluteString)
                
                guard let url = url else { return }
                storeUserInformation(imageProfileUrl: url)
            }
            
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        Firestore.firestore().collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                print("Success")
                
                self.didCompleteLoginProcess()
            }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        
                        Text("Create Account")
                            .tag(false)
                    }
                    .pickerStyle(.segmented)
                    
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 64)
                                        .padding()
                                }
                            } //: VStack
                            .overlay(
                                RoundedRectangle(cornerRadius: 120)
                                    .stroke(.black, lineWidth: 3)
                            )
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                        
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .background(Color.blue)
                    }
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                    
                } //: VStack
                .padding()

            } //: Scroll
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(
                Color(.init(white: 0, alpha: 0.05))
                    .ignoresSafeArea()
            )
        } //: Navigation View
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
}

struct FCLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FCLoginView(didCompleteLoginProcess: {
            
        })
    }
}
