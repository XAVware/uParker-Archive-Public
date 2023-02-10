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
    @State var tabBarVisibility: Visibility = .hidden
    @State var navBarVisibility: Visibility = .visible
    @State var licensePlate: String = ""
    @State var vin: String = ""
    
    @State private var selectedMethod: AddMethod? = .none
    private enum AddMethod { case licensePlate, vin, manual }
        
    @State private var selectedState: String = "---Select State---"
    
    @State private var isRequestInProgress: Bool = false
    @State private var newVehicle: Vehicle?
    
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
//                foundVehicleView
                
            case .licensePlate:
                if self.newVehicle == nil {
                    addLicensePlateView
                } else {
                    foundVehicleView
                }
                
            case .vin:
                Text("VIN")
                
            case .manual:
                Text("Manual")
            }
            
            Spacer()
        } //: VStack
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(self.selectedMethod == .none ? "Your Vehicles" : "Add Vehicle")
        .toolbar(tabBarVisibility, for: .tabBar)
        .toolbar(navBarVisibility, for: .navigationBar)
        .onDisappear {
            tabBarVisibility = .visible
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
        .overlay(
            VStack {
                if self.isRequestInProgress {
                    fetchingVehicleView
                }
            }
        )
    } //: Body
    
    // MARK: - FUNCTIONS
    private func backTapped() {
        if self.selectedMethod == .none {
            tabBarVisibility = .visible
            dismiss.callAsFunction()
        } else {
            self.selectedMethod = .none
        }
    }
    
    private func searchTapped() {
        guard self.selectedState != states[0] else {
            print("No State Selected")
            return
        }

        guard self.licensePlate != "" else {
            print("No license plate entered")
            return
        }
        self.isRequestInProgress = true
        self.navBarVisibility = .hidden
        let stateAbbreviation: String = String(selectedState.prefix(2))
        let plateInfo: [String: AnyHashable] = ["plate": licensePlate, "state": stateAbbreviation]
        
        fetchVehicle(forPlate: plateInfo) { vehicle, error in
            guard let vehicle = vehicle, error == nil else {
                print(error ?? "Error Returned")
                return
            }
            
            self.newVehicle = vehicle
        }
    }
    
    private func fetchVehicle(forPlate parameters: [String: AnyHashable], completion: @escaping(Vehicle?, Error?) -> ())  {
        guard let url = URL(string: "https://platetovin.net/api/convert") else {
            let error = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unable to access URL"])
            completion(nil, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("GLrgFHToBcOX8uU", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            defer {
                DispatchQueue.main.async {
                    self.isRequestInProgress = false
                    self.navBarVisibility = .visible
                }
            }
            
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PTVResponse.self, from: data)
                completion(decodedResponse.vin, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        
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
    
    private var fetchingVehicleView: some View {
        VStack {
            Spacer()
            
            ProgressView()
                .tint(primaryColor)
                .frame(width: 50, height: 50)
                .scaleEffect(2)
            
            Text("Looking for your vehicle's information...")
                .modifier(TextMod(.title3, .semibold, primaryColor))
                .padding(.top)
                .padding(.bottom, 4)
            
            Text("This may take a few seconds")
                .modifier(TextMod(.body, .semibold, primaryColor))
            
            Spacer()
            
        } //: VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Color.white)
    } //: Fetching Vehicle
    
    private var foundVehicleView: some View {
        VStack {
            Text("We found your vehicle!")
                .padding(.top)
                .frame(maxWidth: .infinity)
                .modifier(TextMod(.title2, .semibold))
            
            Text("Please confirm the information below")
                .frame(maxWidth: .infinity)
                .modifier(TextMod(.title3, .regular))
            
            Spacer()
            
            VStack(spacing: 12) {
                Group {
                    HStack {
                        Text("License Plate:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Text(self.licensePlate)
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                    
                    HStack {
                        Text("Year:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Text(self.newVehicle?.year ?? "Empty")
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                    
                    HStack {
                        Text("Make:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Text(self.newVehicle?.make ?? "Empty")
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                    
                    
                    HStack {
                        Text("Model:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Text(self.newVehicle?.model ?? "Empty")
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                    
                    HStack {
                        Text("Color:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Text(self.newVehicle?.color.name ?? "Empty")
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                }
                
                HStack {
                    Text("Trim:")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Text(self.newVehicle?.trim ?? "Empty")
                        .modifier(TextMod(.title3, .regular))
                } //: HStack
                
                HStack {
                    Text("Engine:")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Text(self.newVehicle?.engine ?? "Empty")
                        .modifier(TextMod(.title3, .regular))
                } //: HStack
                
                HStack {
                    Text("Transmission:")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Text(self.newVehicle?.transmission ?? "Empty")
                        .modifier(TextMod(.title3, .regular))
                } //: HStack
                
                HStack {
                    Text("Style:")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Text(self.newVehicle?.style ?? "Empty")
                        .modifier(TextMod(.title3, .regular))
                } //: HStack
                
                HStack {
                    Text("Drivetrain:")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Text(self.newVehicle?.driveType ?? "Empty")
                        .modifier(TextMod(.title3, .regular))
                } //: HStack
                
                HStack {
                    Text("VIN:")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Text(self.newVehicle?.vin ?? "Empty")
                        .modifier(TextMod(.body, .regular))
                } //: HStack
            } //: VStack
            
            Spacer()
            
            Button {
                //
            } label: {
                Text("Confirm & Save")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())

        } //: VStack
    } //: Found Vehicle View
    
    private var addLicensePlateView: some View {
        VStack(spacing: 16) {
            Text("Enter License Plate")
                .modifier(TextMod(.title2, .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 24)
                        
            Picker("Select State", selection: $selectedState) {
                ForEach(states, id: \.self) {
                    Text($0)
                }
            }
            .tint(.black)
            .frame(maxWidth: 190)
            .frame(height: 45, alignment: .trailing)
            .overlay(
                RoundedRectangle(cornerRadius: 5).stroke(.gray)
            )
            
            AnimatedTextField(boundTo: $licensePlate, placeholder: "License Plate")
                .frame(maxWidth: 190)
            
            Button {
                searchTapped()
            } label: {
                Text("Search")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())
            .padding()
            
            Spacer()
        } //: VStack
        .padding(.horizontal)
        .padding(.top, 30)
    } //: Add Licence Plate View
    
    private var addButtonPanel: some View {
        VStack(alignment: .leading) {
            Text("Add vehicle by using:")
                .modifier(TextMod(.body, .regular))
                .padding(.bottom, 4)
            
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

