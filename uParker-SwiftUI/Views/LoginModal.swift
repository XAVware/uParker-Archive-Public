//
//  LoginModal.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/3/23.
//

import SwiftUI

struct LoginModal: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var phoneNumber: String = ""
    @State private var phoneNumIsSelected: Bool = false
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .fontWeight(.light)
                        .frame(width: 16)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
                

                Text("Log In or Sign Up")
                    .font(.title3)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity)
                
                
                Spacer()
                    .frame(width: 16)
                    .padding(.horizontal)
                
            } //: HStack
            .frame(height: 30)
            .padding(.top)
            
            Divider()
            
            Spacer()
            
            Image("LogoFull-Blue")
                .resizable()
                .scaledToFit()
                .padding(.vertical)
                .frame(width: 120)
            
            Spacer()
            
            // MARK: - MAIN STACK
            VStack {
                ZStack(alignment: .leading) {
                    Text("Phone Number")
                        .foregroundColor(.gray)
                        .offset(y: self.phoneNumIsSelected ? -14 : 0)
                        .font(self.phoneNumIsSelected ? .footnote : .body)
                        
                    TextField("", text: $phoneNumber) { isSelected in
                        withAnimation { phoneNumIsSelected = isSelected }
                    }
                        .foregroundColor(.black)
                        .frame(height: 36)
                        .offset(y: 7)
                    
                } //: ZStack
                .frame(height: 60)
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                )
                
                Text("We'll call or text to confirm your number. Standard message and data rates apply.")
                    .font(.caption)
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                
                Button {
                    //Continue
                } label: {
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontDesign(.rounded)
                        
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(backgroundGradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                    
                    Text("OR")
                        .font(.footnote)
                    
                    Rectangle()
                        .frame(height: 1)
                } //: HStack
                .frame(height: 10)
                .foregroundColor(.gray)
                .padding()
                
                
                
            } //: VStack
            .padding()
            .frame(maxHeight: .infinity)
            
            Spacer()
        } //: VStack
    } //: Body
} //: Struct

// MARK: - PREVIEW
struct LoginModal_Previews: PreviewProvider {
    static var previews: some View {
        LoginModal()
            .environmentObject(SessionManager())
    }
}
