//
//  LoginView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/6/23.
//

import SwiftUI

@MainActor class LoginViewModel: ObservableObject {
    @Published var isSigningUp: Bool = false
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    
}

struct LoginView: View {
    // MARK: - PROPERTEIS
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var vm: LoginViewModel = LoginViewModel()
    
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
        NavigationLink {
            if vm.isSigningUp {
                AddPhoneView()
                    .environmentObject(sessionManager)
            } else {
                ConfirmPhoneView(phoneNumber: "201-874-3252")
                    .environmentObject(sessionManager)
            }
        } label: {
            Text("Continue")
                .frame(maxWidth: .infinity)
        }
        .modifier(RoundedButtonMod())
        
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
            .environmentObject(SessionManager())
    }
}
