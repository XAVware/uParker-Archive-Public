//
//  VehiclesView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/9/23.
//

import SwiftUI

struct VehiclesView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @State var toolBarVisibility: Visibility = .hidden
    @State var licensePlate: String = ""
    @State var vin: String = ""
    
    @State private var selectedMethod: AddMethod? = .none
    private enum AddMethod { case licensePlate, vin, manual }
    
    @State private var vehicles: [Vehicle] = [Vehicle]()
    
    @State private var selectedState: String = "--Select State--"
    
    // MARK: - BODY
    var body: some View {
        VStack {
            noVehiclesView
                .frame(maxWidth: 280, maxHeight: selectedMethod == .none ? 220 : 0)
                .scaleEffect(selectedMethod == .none ? 1 : 0)
                .opacity(selectedMethod == .none ? 1 : 0)
            
            Divider()
            
            switch self.selectedMethod {
            case .none:
                addButtonPanel
                
            case .licensePlate:
                addLicensePlateView
                
            case .vin:
                Text("VIN")
                
            case .manual:
                Text("Manual")
            }
            
            if selectedMethod != .none {
                Button {
                    fetchVehicle()
                } label: {
                    Text("Search")
                        .frame(maxWidth: .infinity)
                }
                .modifier(RoundedButtonMod())
                .padding()
            }
            
            Spacer()
        } //: VStack
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Your Vehicles")
        .toolbar(toolBarVisibility, for: .tabBar)
        .onDisappear {
            toolBarVisibility = .visible
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    backTapped()
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            
                        Text("Back")
                            .modifier(TextMod(.footnote, .regular))
                    } //: HStack
                    .frame(height: 16, alignment: .leading)
                }
                .buttonStyle(PlainButtonStyle())
            }
        } //: ToolBar
    } //: Body
    
    // MARK: - FUNCTIONS
    private func backTapped() {
        if self.selectedMethod == .none {
            toolBarVisibility = .visible
            dismiss.callAsFunction()
        } else {
            self.selectedMethod = .none
        }
    }
    
    
    
    private func fetchVehicle()  {
        print("Fetch Vehicle Started")
//        guard self.selectedState != states[0] else {
//            print("No State Selected")
//            return
//        }
//
//        guard self.licensePlate != "" else {
//            print("No license plate entered")
//            return
//        }
        
        
        guard let url = URL(string: "https://platetovin.net/api/convert") else {
            print("Issue accessing URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("GLrgFHToBcOX8uU", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        let parameters: [String: AnyHashable] = [
            "plate": "S71JCY",
            "state": "NJ"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        
        

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed 1")
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("Response:")
                print(response)
            } catch {
                print(error)
            }
        }
        task.resume()
        
        //From Youtube
        
//        do {
//            let (data, _) = try await URLSession.shared.data((from: url))
//
//            if let decodedResponse = try? JSONDecoder().decode([Vehicle].self, from: data) {
//                vehicles = decodedResponse
//            }
//        } catch {
//            print("error fetching data")
//        }
//        print("Fetch Vehicle Ended")
    }
    
    // MARK: - VIEW VARIABLES
    private var noVehiclesView: some View {
        VStack(spacing: 8) {
            Image(systemName: "car.2.fill")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 100)
                .foregroundColor(primaryColor)
                .padding(.vertical)
                .opacity(0.7)
            
            Text("Looks like you haven't added a vehicle yet!")
                .modifier(TextMod(.title3, .semibold))
                .multilineTextAlignment(.center)
            
        } //: VStack
        .padding(.vertical)
    } //: No Vehicles View
    
    private var addLicensePlateView: some View {
        VStack(spacing: 16) {
            Text("Enter License Plate")
                .modifier(TextMod(.title2, .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 24)
            
            Spacer()
            
            Picker("Select State", selection: $selectedState) {
                ForEach(states, id: \.self) {
                    Text($0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .tint(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 45, alignment: .trailing)
            .overlay(
                RoundedRectangle(cornerRadius: 5).stroke(.gray)
            )
            
            AnimatedTextField(boundTo: $licensePlate, placeholder: "License Plate")
            
            Spacer()
        } //: VStack
        .padding(.horizontal)
        .padding(.top, 30)
        .frame(maxWidth: 260, maxHeight: 200)
    } //: Add Licence Plate View
    
    private var addButtonPanel: some View {
        VStack(alignment: .leading) {
            Text("Add vehicle by using:")
                .modifier(TextMod(.body, .regular))
            
            Button {
                withAnimation { self.selectedMethod = .licensePlate }
            } label: {
                Text("License Plate")
                    .frame(maxWidth: .infinity)
            }
            .modifier(OutlinedButtonMod())
            
            Button {
                withAnimation { self.selectedMethod = .vin }
            } label: {
                Text("VIN")
                    .frame(maxWidth: .infinity)
            }
            .modifier(OutlinedButtonMod())
            
            Button {
                withAnimation { self.selectedMethod = .manual }
            } label: {
                Text("Year, Make & Model")
                    .frame(maxWidth: .infinity)
            }
            .modifier(OutlinedButtonMod())
            
        } //: VStack
        .padding()
    }
}

// MARK: - PREVIEW
struct VehiclesView_Previews: PreviewProvider {
    static var previews: some View {
        VehiclesView()
    }
}



extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
