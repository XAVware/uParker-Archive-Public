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
    
    @State var toolBarVisibility: Visibility = .hidden
    
    private func imageTapped() {
        if self.isEditing {
            self.shouldShowImagePicker.toggle()
        }
    }
    
    private var profileImage: some View {
        VStack {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: isEditing ? 140 : 70, height: isEditing ? 140 : 70, alignment: .center)
                    
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(width: isEditing ? 140 : 70, height: isEditing ? 140 : 70, alignment: .center)
                    .animation(.interactiveSpring(), value: isEditing)
                    .padding(isEditing ? 24 : 16)
            }
        } //: VStack
        .animation(.interactiveSpring(), value: isEditing)
        .overlay(
            ZStack {
                Circle().stroke(.gray, lineWidth: 0.5)
                
                if self.isEditing {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12)
                                .foregroundColor(.white)
                            
                            Text("Change")
                                .modifier(TextMod(.footnote, .semibold, .white))
                        
                        }
                        .padding(.top, 3)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30, alignment: .top)
                        .background(primaryColor)
                    } //: VStack
                    .opacity(self.isEditing ? 1 : 0)
                    .clipShape(Circle())
                }
            } //: ZStack
        )
        .padding(.vertical)
        .onTapGesture {
            self.imageTapped()
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    } //: Profile Image
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: isEditing ? .center : .leading) {
                    HStack {
                        profileImage
                        
                        if !self.isEditing {
                            VStack(alignment: .leading) {
                                Text("Hi \(firstName)!")
                                    .modifier(TextMod(.title, .semibold))
                                
                                Text("Joined 2023")
                                    .modifier(TextMod(.title2, .semibold, .gray))
                            } //: VStack
                            .padding(.horizontal)
                        }
                    }
                    
                    if !self.isEditing {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15)
                                    .foregroundColor(primaryColor)
                                
                                Text("0 Reviews")
                                    .modifier(TextMod(.callout, .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } //: HStack
                            
                            HStack {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15)
                                    .foregroundColor(primaryColor)
                                
                                Text("Not Verified")
                                    .modifier(TextMod(.callout, .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } //: HStack
                        } //: VStack
                        .padding(.horizontal)
                        
                        Divider().padding(.vertical, 8)
                    }
                    
                    // MARK: - PERSONAL INFO
                    VStack(alignment: .leading, spacing: 24) {
                        if !self.isEditing {
                            HStack {
                                Text("Personal Information")
                                    .modifier(TextMod(.title2, .semibold))
                                
                                Spacer()
                                
                                Button {
                                    withAnimation(.interactiveSpring(blendDuration: 1)) {
                                        isEditing.toggle()
                                    }
                                } label: {
                                    Text("Edit")
                                        .font(.footnote)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.trailing)
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
                    
                    if self.isEditing {
                        Button {
                            self.isEditing.toggle()
                        } label: {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                        .modifier(RoundedButtonMod())
                        .padding()

                    }
                    
                    
                    if !self.isEditing {
                        Divider().padding(.vertical, 8)
                        
                        Text("Reviews")
                            .modifier(TextMod(.title2, .semibold))
                    }
                } //: VStack
                
            } //: ScrollView
            .padding(.horizontal)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(isEditing ? "Edit Profile" : "Profile")
            .toolbar(toolBarVisibility, for: .tabBar)
            .onDisappear {
                toolBarVisibility = .visible
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if self.isEditing {
                            withAnimation(.interactiveSpring(blendDuration: 1)) {
                                isEditing.toggle()
                            }
                        } else {
                            toolBarVisibility = .visible
                            dismiss.callAsFunction()
                        }
                    } label: {
                        Image(systemName: isEditing ? "xmark" : "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.light)
                            .background(.white)
                            .frame(width: 30, height: 20, alignment: .leading)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } //: ToolBar
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
                    .modifier(TextMod(.footnote, .semibold))
                
                Text(detail)
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        } //: VStack
        .padding(.horizontal)
    }
}