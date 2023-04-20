//
//  LoginView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/6/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor class LoginViewModel: ObservableObject {
    @Published var isSigningUp: Bool = false
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isRequestInProgress: Bool = false
    
    func continueTapped() {
        // Validate data before calling Firebase
        if isSigningUp {
            guard !email.isEmpty else {
                AlertManager.shared.showError(title: "Error", message: "Please enter an email.")
                return
            }
            
            guard !password.isEmpty else {
                AlertManager.shared.showError(title: "Error", message: "Please enter a password.")
                return
            }
            
            createNewAccount()
        } else {
            guard !email.isEmpty else {
                AlertManager.shared.showError(title: "Error", message: "Please enter an email.")
                return
            }
            
            guard !password.isEmpty else {
                AlertManager.shared.showError(title: "Error", message: "Please enter a password.")
                return
            }
            
            loginUser()
        }
    }
    
    private func createNewAccount() {
        isRequestInProgress = true
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                AlertManager.shared.showError(title: "Error", message: error.localizedDescription)
                return
            }
            
//            Functions.functions().httpsCallable("createStripeUser").call(["email": self.regEmail]) { (result, error) in
//                defer {
//                    Task { @MainActor in
//                        self.isRequestInProgress = false
//                    }
//                }
//
//                if let error = error {
//                    debugPrint(error.localizedDescription)
//                    return
//                }
//
//                print("Finished creating stripe user: \(result?.data)")
//                self.isLoggedIn = true
//            }
            
            debugPrint("Successfully created user in Auth: \(result?.user.uid ?? "")")
            
            if let uid = result?.user.uid {
                let userData = [
                    "uid": uid,
                    "email": self.email,
                    "firstName": self.firstName,
                    "lastName": self.lastName,
                    "phoneNumber": ""
                ]
                
                Firestore.firestore().collection("users").document(uid).setData(userData) { err in
                    if let err = err {
                        AlertManager.shared.showError(title: "Error", message: err.localizedDescription)
                        return
                    }
                    print("Successfully added user data to firestore")
                    
                    UserManager.shared.getCurrentUser {
                        print("Successfully retrieved and stored current user locally")
                    }
                    
                }
            } else {
                AlertManager.shared.showError(title: "Error", message: "User created in Auth but unable to create in Firestore. Bailing from CreateUser func.")
            }
            
            
        }
    }
    
    private func loginUser() {
        isRequestInProgress = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            defer {
                Task { @MainActor in
                    self.isRequestInProgress = false
                }
            }
            
            if let error = error {
                AlertManager.shared.showError(title: "Error", message: error.localizedDescription)
                return
            }
            
            debugPrint("Successfully logged in user \(result?.user.uid ?? "")")
            
            UserManager.shared.getCurrentUser {
                print("Successfully retrieved and stored current user locally")
            }
        }
    }
}

struct LoginView: View {
    // MARK: - PROPERTEIS
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: LoginViewModel = LoginViewModel()
    @StateObject var alertManager: AlertManager = AlertManager.shared
    
    @FocusState private var focusField: FocusText?
    enum FocusText { case email }
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
                infoFields
                    .padding(.vertical)
                
                continueButton
                    .padding(.bottom, 8)
                
                if vm.isSigningUp == false {
                    signUpButton
                }
                
                OrDivider()
                    .padding()
                
                authOptions
                
                Spacer()
            } //: VStack
            .padding(.horizontal)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(vm.isSigningUp ? "Sign Up" : "Login")
            .onTapGesture {
                focusField = nil
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if vm.isSigningUp {
                        backButton
                    } else {
                        closeButton
                    }
                }
            } //: ToolBar
            .alert(isPresented: $alertManager.isShowing) {
                alertManager.alert
            }
            .overlay(vm.isRequestInProgress ? ProgressView() : nil)
        } //: Navigation View
    } //: Body
    
    private var infoFields: some View {
        VStack(spacing: 16) {
            if vm.isSigningUp {
                nameFields
            }
            
            AnimatedTextField(boundTo: $vm.email, placeholder: "Email Address")
                .modifier(EmailFieldMod())
                .focused($focusField, equals: .email)
                .onSubmit {
                    focusField = nil
                }
                .onTapGesture {
                    focusField = .email
                }
            
            AnimatedTextField(boundTo: $vm.password, placeholder: "Password", isSecure: true)
        } //: VStack
    } //: Info Fields
    
    private var authOptions: some View {
        VStack(spacing: 16) {
            Button {
                //
            } label: {
                Text("Continue with Apple")
                    .frame(maxWidth: .infinity)
            }
            .modifier(OutlinedButtonMod())
            .overlay(
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(.leading), alignment: .leading
            )
            
            Button {
                //
            } label: {
                Text("Continue with Google")
                    .frame(maxWidth: .infinity)
            }
            .modifier(OutlinedButtonMod())
            .overlay(
                Image("GoogleIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(.leading), alignment: .leading
            )
            
        } //: VStack
    } //: Auth Options
    
    private var continueButton: some View {
        Button {
            vm.continueTapped()
        } label: {
            Text("Continue")
                .frame(maxWidth: .infinity)
        }
        .modifier(RoundedButtonMod())
        
//        NavigationLink {
//            vm.continueTapped()
//
//            if vm.isSigningUp {
//                AddPhoneView()
//            } else {
//                ConfirmPhoneView(phoneNumber: "201-874-3252")
//            }
//        } label: {
//            Text("Continue")
//                .frame(maxWidth: .infinity)
//        }
//        .modifier(RoundedButtonMod())
        
    } //: Continue Button
    
    private var signUpButton: some View {
        Button {
            vm.isSigningUp.toggle()
        } label: {
            Text("Don't have an account? Sign up now!")
                .underline()
                .modifier(TextMod(.footnote, .regular))
        }
    } //: Sign Up Button
    
    private var nameFields: some View {
        HStack(spacing: 16) {
            AnimatedTextField(boundTo: $vm.firstName, placeholder: "First Name")
            
            AnimatedTextField(boundTo: $vm.lastName, placeholder: "Last Name")
        } //: HStack
    }
    
    private var closeButton: some View {
        Button {
            dismiss.callAsFunction()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .fontWeight(.light)
                .frame(width: 15)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 50, height: 30, alignment: .leading)
    } //: Close Button
    
    private var backButton: some View {
        Button {
            vm.isSigningUp.toggle()
        } label: {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .fontWeight(.light)
                .frame(height: 12)
            
            Text("Back")
                .modifier(TextMod(.footnote, .regular))
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 50, height: 30, alignment: .leading)
    } //: Back Button
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
