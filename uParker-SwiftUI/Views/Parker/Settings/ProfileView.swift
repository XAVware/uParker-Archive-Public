//
//  ProfileView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/7/23.
//

import SwiftUI

struct ProfileView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    
    @State var isEditing: Bool = false
    
    @State var firstName: String = "Ryan"
    @State var lastName: String = "Smetana"
    @State var phoneNumber: String = "201-874-3252"
    @State var email: String = "ryansmetana@gmail.com"
    @State private var shouldShowImagePicker: Bool = false
    @State private var image: UIImage?
    
    private func imageTapped() {
        if self.isEditing {
            self.shouldShowImagePicker.toggle()
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        HeaderView(leftItem: nil, title: nil, rightItem: nil)
                        
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: isEditing ? 140 : 70, height: isEditing ? 140 : 70, alignment: .center)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: isEditing ? 140 : 70, height: isEditing ? 140 : 70, alignment: .center)
                                    .padding(isEditing ? 24 : 16)
                            }
                        } //: VStack
                        .frame(width: 400)
                        .overlay(
                            Circle().stroke(.gray, lineWidth: 0.5)
                        )
                        .onTapGesture {
                            self.imageTapped()
                        }
                        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                            ImagePicker(image: $image)
                        }
                        
                        if !self.isEditing {
                            // MARK: - PROFILE OVERVIEW
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Hi \(firstName)!")
                                        .modifier(BigTitleMod())
                                    
                                    Text("Joined 2023")
                                        .modifier(MidTitleMod())
                                        .foregroundColor(.gray)
                                } //: VStack
                                Spacer()
                                VStack {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .foregroundColor(primaryColor)
                                        
                                        Text("0 Reviews")
                                            .modifier(CalloutTextMod())
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    } //: HStack
                                    
                                    HStack {
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .foregroundColor(primaryColor)
                                        
                                        Text("Not Verified")
                                            .modifier(CalloutTextMod())
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    } //: HStack
                                } //: VStack
                                .frame(width: 120, alignment: .leading)
                            } //: HStack
                            
                            Divider().padding(.bottom)
                        }
                            
                            // MARK: - PERSONAL INFO
                            VStack(alignment: .leading, spacing: 16) {
                                if !self.isEditing {
                                    HStack {
                                        Text("Personal Information")
                                            .modifier(MidTitleMod())
                                        
                                        Spacer()
                                        
                                        Button {
                                            withAnimation { self.isEditing.toggle() }
                                        } label: {
                                            Text("Edit")
                                                .font(.footnote)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    } //: HStack
                                }
                                
                                HStack {
                                    ProfileFieldView(header: "First Name", detail: $firstName, isEditing: $isEditing)
                                        .frame(width: (geo.size.width - 32) / 2, alignment: .leading)
                                    
                                    ProfileFieldView(header: "Last Name", detail: $lastName, isEditing: $isEditing)
                                        .frame(width: (geo.size.width - 32) / 2, alignment: .leading)
                                } //: HStack
                                .padding(.top, self.isEditing ? 16 : 0)
                                
                                ProfileFieldView(header: "Email", detail: $email, isEditing: $isEditing)
                                
                                ProfileFieldView(header: "Phone Number", detail: $phoneNumber, isEditing: $isEditing)
                            } //: VStack
                        
                        
                        if !self.isEditing {
                            Divider().padding(.bottom)
                            
                            Text("Reviews")
                                .modifier(MidTitleMod())
                        }
                    } //: VStack
                    .padding(.horizontal)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden()
                    .navigationTitle(isEditing ? "Edit Profile" : "Profile")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                if self.isEditing {
                                    withAnimation {
                                        isEditing.toggle()
                                    }
                                } else {
                                    dismiss.callAsFunction()                                    
                                }
                            } label: {
                                Image(systemName: isEditing ? "xmark" : "chevron.left")
                                    .resizable()
                                    .scaledToFit()
                                    .fontWeight(.light)
                                    .frame(height: 20)
                                    .frame(width: 15)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    } //: ToolBar
                } //: ScrollView
            } //: Nav View
        } //: GeometryReader
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct ProfileFieldView: View {
    // MARK: - PROPERTIES
    @State var header: String
    @Binding var detail: String
    @Binding var isEditing: Bool
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if isEditing {
                AnimatedTextField(boundTo: $detail, placeholder: header)
            } else {
                Text(header)
                    .modifier(FootTextMod())
                
                Text(detail)
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        } //: VStack
        
    }
}
