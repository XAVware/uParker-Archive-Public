//
//  VehiclesVieww.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/23/23.
//
//
//  VehiclesView.swift
//  uParker-SwiftUI
//
//  Created by Ryan Smetana on 2/14/23.
//

import SwiftUI

@MainActor class VehiclesViewModel: ObservableObject {
    // MARK: - PROPERTIES
    @Published var tabBarVisibility: Visibility = .hidden
    @Published var navBarVisibility: Visibility = .visible
    @Published var licensePlate: String = "S71JCY"
    @Published var selectedState: String = "NJ"
    @Published var isRequestInProgress: Bool = false
    @Published var isShowingAddVehicle: Bool = false
    @Published var newVehicle: Vehicle?
    @Published var userVehicles: [Vehicle] = [Vehicle]()
    
    enum AddMethod { case licensePlate, manual }
    @Published var selectedMethod: AddMethod? = .none
    
    // MARK: - FUNCTIONS
    func addVehicleTapped() {
        isShowingAddVehicle.toggle()
    }
    
    func backTapped(_ dismiss: DismissAction) {
        if isShowingAddVehicle {
            if selectedMethod == .none {
                isShowingAddVehicle = false
            } else {
                if newVehicle == nil {
                    self.selectedMethod = .none
                } else {
                    newVehicle = nil
                }
            }
        } else {
            tabBarVisibility = .visible
            dismiss.callAsFunction()
        }
        
    }
    
    func saveTapped() {
        guard newVehicle != nil else {
            print("New vehicle is nil")
            return
        }
        
        userVehicles.append(newVehicle!)
        newVehicle = nil
        selectedMethod = .none
        isShowingAddVehicle = false
    }
    
    func lookupPlate() {
        guard self.licensePlate != "" else {
            print("No license plate entered")
            return
        }
        self.isRequestInProgress = true
        self.navBarVisibility = .hidden
        let plateInfo: [String: AnyHashable] = ["plate": licensePlate, "state": selectedState]
        
        fetchVehicle(forPlate: plateInfo)
    }
    
    private func fetchVehicle(forPlate parameters: [String: AnyHashable])  {
        guard let url = URL(string: "https://platetovin.net/api/convert") else {
            let error = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Unable to access URL"])
            print(error)
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


struct VehiclesView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: VehiclesViewModel = VehiclesViewModel()
    
    // MARK: - BODY
    var body: some View {
        VStack {
            if vm.isShowingAddVehicle {
                AddVehicleView()
                    .environmentObject(vm)
                
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
                        vm.addVehicleTapped()
                        print(vm.isShowingAddVehicle)
                    } label: {
                        Text("Add A Vehicle")
                            .frame(maxWidth: .infinity)
                    }
                    .modifier(RoundedButtonMod())

                } //: VStack
                .padding(.vertical)
            } else {
                List(vm.userVehicles, id: \.vin) { vehicle in
                    VStack {
                        Text(vehicle.year)
                        Text(vehicle.make)
                        Text(vehicle.model)
                        Text(vehicle.vin)
                        Divider()
                    }
                }
            }
            
        } //: VStack
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(vm.isShowingAddVehicle ? "Add Vehicle" : "Your Vehicles")
        .toolbar(vm.tabBarVisibility, for: .tabBar)
        .toolbar(vm.navBarVisibility, for: .navigationBar)
        .onDisappear {
            vm.tabBarVisibility = .visible
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            if vm.userVehicles.count != 0 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
        } //: ToolBar
        
    }
    
    // MARK: - VIEW VARIABLES
    private var addButton: some View {
        Button {
            vm.addVehicleTapped()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                
                Text("Add")
                    .modifier(TextMod(.footnote, .regular))
            } //: HStack
            .frame(height: 16, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backButton: some View {
        Button {
            vm.backTapped(dismiss)
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
}

struct VehiclesVieww_Previews: PreviewProvider {
    static var previews: some View {
        VehiclesView()
    }
}

