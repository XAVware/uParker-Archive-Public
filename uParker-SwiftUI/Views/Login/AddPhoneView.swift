//
//  AddPhoneView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/6/23.
//

import SwiftUI

struct AddPhoneView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    @FocusState private var focusField: FocusText?
    enum FocusText { case phone }
    
    @State private var phoneNumber: String = ""
    
    // MARK: - BODY
    var body: some View {
        VStack {
            addPhone
            
            Spacer()
            
        } //: VStack
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
    } //: Body
    
    private var addPhone: some View {
        VStack {
            AnimatedTextField(boundTo: $phoneNumber, placeholder: "Phone Number")
                .padding(.top, 20)
                .keyboardType(.numberPad)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($focusField, equals: .phone)
                .submitLabel(.continue)
                .onChange(of: phoneNumber, perform: {
                    phoneNumber = String($0.prefix(14)).applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
                })
                .onSubmit {
                    focusField = nil
                }
                .onTapGesture {
                    focusField = .phone
                }
            
            Text("We'll call or text to confirm your number. Standard message and data rates apply.")
                .modifier(TextMod(.caption, .light, .gray))
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            NavigationLink {
                ConfirmPhoneView(phoneNumber: "201-874-3252")
                    .environmentObject(sessionManager)
//                focusField = nil
//                isConfirming = true
//                dismiss.callAsFunction()
//                sessionManager.logIn()
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())
        }
        .navigationTitle("Add Phone Number")
    } //: Add Phone
    
}



struct AddPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhoneView()
            .environmentObject(SessionManager())
    }
}
