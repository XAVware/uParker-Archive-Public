//
//  VehiclesVieww.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/23/23.
//
//
//  PaymentMethodsView.swift
//  uParker-SwiftUI
//
//  Created by Ryan Smetana on 2/14/23.
//

import SwiftUI

extension VehiclesVieww {
    @MainActor class VehiclesViewModel: ObservableObject {
        // MARK: - PROPERTIES
        @Published var tabBarVisibility: Visibility = .hidden
        @Published var navBarVisibility: Visibility = .visible
        @Published var licensePlate: String = "S71JCY"
        @Published var selectedState: String = "NJ"
        @Published var isRequestInProgress: Bool = false
        @Published var newVehicle: Vehicle?
        @Published var isShowingAddVehicle: Bool = false
        @Published var userVehicles: [Vehicle] = [Vehicle]()

        enum AddMethod { case licensePlate, manual }
        @Published var selectedMethod: AddMethod? = .none
        
        // MARK: - FUNCTIONS
        func backTapped() {
            if self.selectedMethod == .none {
                tabBarVisibility = .visible
            } else {
                self.selectedMethod = .none
            }
        }
        
        func searchTapped() {
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
            
            fetchVehicle(forPlate: plateInfo)
        }
        
        private func fetchVehicle(forPlate parameters: [String: AnyHashable])  {
            guard let url = URL(string: "https://platetovin.net/api/convert") else {
                let error = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unable to access URL"])
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue("GLrgFHToBcOX8uU", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                defer {
                    DispatchQueue.main.async {
                        self.isRequestInProgress = false
                        self.navBarVisibility = .visible
                    }
                }
                
                guard let data = data, error == nil else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(PTVResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.newVehicle = decodedResponse.vin
                    }
                } catch {
                    print(error)
                }
            }.resume()
            
        }
    }
}

struct VehiclesVieww: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: VehiclesViewModel = VehiclesViewModel()
    
    // MARK: - BODY
    var body: some View {
        VStack {
            if vm.isShowingAddVehicle {
                switch vm.selectedMethod {
                case .none:
                    VStack(spacing: 16) {
                        Text("How do you want to add your vehicle?")
                            .modifier(TextMod(.title, .regular))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 32)
                        
                        Button {
                            withAnimation { vm.selectedMethod = .licensePlate }
                        } label: {
                            Text("License Plate")
                                .frame(maxWidth: .infinity)
                        }
                        .modifier(OutlinedButtonMod())
                        
                        OrDivider()
                            .padding(.horizontal)
                        
                        Button {
                            withAnimation { vm.selectedMethod = .manual }
                        } label: {
                            Text("Year, Make & Model")
                                .frame(maxWidth: .infinity)
                        }
                        .modifier(OutlinedButtonMod())
                        
                    } //: VStack
                    .padding()
                case .licensePlate:
                    if vm.newVehicle == nil {
                        VStack(spacing: 48) {
                            Text("Enter License Plate")
                                .modifier(TextMod(.title2, .semibold))
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            HStack {
                                AnimatedTextField(boundTo: $vm.licensePlate, placeholder: "License Plate")
                                
                                ZStack(alignment: .leading) {
                                    Text("State")
                                        .foregroundColor(.gray)
                                        .offset(y: -19)
                                        .scaleEffect(0.65, anchor: .leading)
                                    
                                    Picker("", selection: $vm.selectedState) {
                                        ForEach(stateAbbreviations, id: \.self) {
                                            Text("\($0)")
                                        }
                                    }
                                    .tint(.black)
                                    .offset(y: 7)
                                    
                                } //: ZStack
                                .frame(width: 65, height: 48)
                                .padding(.leading, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.gray, lineWidth: 1)
                                )
                                
                            } //: HStack
                            .frame(height: 48)
                            
                            Button {
                                vm.searchTapped()
                            } label: {
                                Text("Find Vehicle Info")
                                    .frame(maxWidth: .infinity)
                            }
                            .modifier(RoundedButtonMod())
                            
                        } //: VStack
                        .frame(width: 300)
                    } else {
                        foundVehicleView
                    }
                case .manual:
                    VehiclePickerPanel(newVehicle: $vm.newVehicle)
                }
                
            } else if vm.userVehicles.isEmpty {
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
                    
                    Spacer().frame(height: 80)
                    
                    Button {
                        vm.isShowingAddVehicle.toggle()
                    } label: {
                        Text("Add A Vehicle")
                            .frame(maxWidth: .infinity)
                    }
                    .modifier(RoundedButtonMod())

                } //: VStack
                .padding(.vertical)
            } else {
                Text("Vehicle List")
            }
            
        } //: VStack
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(vm.selectedMethod == .none ? "Your Vehicles" : "Add Vehicle")
        .toolbar(vm.tabBarVisibility, for: .tabBar)
        .toolbar(vm.navBarVisibility, for: .navigationBar)
        .onDisappear {
            vm.tabBarVisibility = .visible
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    vm.backTapped()
                    dismiss.callAsFunction()
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
                if vm.isRequestInProgress {
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
                }
            } //: VStack
        )
        
        
    }
    
    // MARK: - VIEW VARIABLES
    
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
                        Text("Plate:")
                            .modifier(TextMod(.title3, .semibold))
                        
//                        Text(self.licensePlate)
                        Text("S71JCY")
                            .modifier(TextMod(.title3, .regular))
                        
                        Spacer()
                        
                        Text("State:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Text(vm.selectedState)
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                    
                    HStack {
                        Text("Year:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Spacer()
                        
                        Text(vm.newVehicle?.year ?? "Empty")
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                    
                    HStack {
                        Text("Make:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Spacer()
                        
                        Text(vm.newVehicle?.make ?? "Empty")
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                    
                    
                    HStack {
                        Text("Model:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Spacer()
                        
                        Text(vm.newVehicle?.model ?? "Empty")
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                    
                    HStack {
                        Text("Color:")
                            .modifier(TextMod(.title3, .semibold))
                        
                        Spacer()
                        
                        Text(vm.newVehicle?.color.name ?? "Empty")
                            .modifier(TextMod(.title3, .regular))
                    } //: HStack
                }
                
                HStack {
                    Text("Trim:")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Spacer()
                    
                    Text(vm.newVehicle?.trim ?? "Empty")
                        .modifier(TextMod(.title3, .regular))
                } //: HStack
                
                HStack {
                    Text("Style:")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Spacer()
                    
                    Text(vm.newVehicle?.style ?? "Empty")
                        .modifier(TextMod(.title3, .regular))
                } //: HStack
                
                
                HStack {
                    Text("VIN:")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Spacer()
                    
                    Text(vm.newVehicle?.vin ?? "Empty")
                        .modifier(TextMod(.body, .regular))
                } //: HStack
            } //: VStack
            .frame(maxWidth: 300)
            
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
                        
            Picker("Select State", selection: $vm.selectedState) {
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
            
            AnimatedTextField(boundTo: $vm.licensePlate, placeholder: "License Plate")
                .frame(maxWidth: 190)
            
            Button {
                vm.searchTapped()
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
    
    
}

struct VehiclesVieww_Previews: PreviewProvider {
    static var previews: some View {
        VehiclesVieww()
    }
}

