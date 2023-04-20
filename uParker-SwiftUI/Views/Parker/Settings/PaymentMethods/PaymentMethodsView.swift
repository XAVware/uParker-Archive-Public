//
//  PaymentMethodsView.swift
//  uParker-SwiftUI
//
//  Created by Ryan Smetana on 2/14/23.
//

import SwiftUI

struct PaymentMethodsView: View {
    
    // MARK: - BODY
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        Image(systemName: "creditcard")
                            .font(.title3)
                        
                        Text("Credit Cards")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Spacer()
                        
                        Button {
                            //
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                            
                            Text("Add Card")
                        } //: Add Card Button
                    } //: HStack
                    
                    Divider()
                        .padding(.bottom)
                    
                    Button {
                        //
                    } label: {
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("**** 6906")
                                        .modifier(TextMod(.title3, .semibold))
                                    
                                    Text("Exp: 03/16")
                                } //: VStack
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 15)
                            } //: HStack
                            
                            Divider()
                        } //: VStack
                    } //: Card Button
                    .padding(.horizontal)
                    
                } //: VStack
                .padding()
                .padding(.top, 32)
                
                
                VStack {
                    HStack {
                        Image(systemName: "building.columns.fill")
                            .font(.title3)
                        
                        Text("Bank Accounts")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Spacer()
                        
                        Button {
                            //
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                            
                            Text("Add Bank")
                        } //: Add Card Button
                    } //: HStack
                    
                    Divider()
                        .padding(.bottom)
                    
                    Button {
                        //
                    } label: {
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("PNC Bank - Checking")
                                        .modifier(TextMod(.title3, .semibold))
                                    
                                    Text("****1234")
                                } //: VStack
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 15)
                            } //: HStack
                            
                            Divider()
                        } //: VStack
                    } //: Card Button
                    .padding(.horizontal)
                    
                } //: VStack
                .padding()
                .padding(.top, 32)
                
                Spacer()
            } //: VStack
            .navigationTitle("Payment Methods")
            .navigationBarTitleDisplayMode(.automatic)
        } //: Scroll
    }
    
}

struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentMethodsView()
        }
    }
}

