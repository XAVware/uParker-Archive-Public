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
    @Published var isShowingOptions: Bool = false
    @Published var isShowingConfirmDelete: Bool = false
    @Published var selectedVehicle: Vehicle?
    @Published var defaultVehicle: Vehicle?
    
    enum AddMethod { case licensePlate, manual }
    @Published var selectedMethod: AddMethod? = .none
    
    var dialogText: String {
        if let selectedVehicle = selectedVehicle {
            let year = String(describing: selectedVehicle.year)
            return "\(year) \(selectedVehicle.make) \(selectedVehicle.model)"
        } else {
            return "No Vehicle Selected"
        }
        
    }
    
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
        
        if licensePlate != "" && selectedState != ""{
            newVehicle!.plate = licensePlate
            newVehicle!.state = selectedState
        }
        
        userVehicles.append(newVehicle!)
        if userVehicles.count == 1 {
            defaultVehicle = newVehicle
        }
        
        newVehicle = nil
        selectedMethod = .none
        isShowingAddVehicle = false
        print(userVehicles)
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
                    let year = decodedResponse.vin.year
                    let make = decodedResponse.vin.make
                    
                    
                    var model = decodedResponse.vin.model
                    let trimResponse = decodedResponse.vin.trim
                    if trimResponse.count > 0 {
                        if model == "Empty" {
                            model = trimResponse
                        } else {
                            model.append(" \(trimResponse)")
                        }
                    }
                    
                    let trim = decodedResponse.vin.style
                    
                    let color = decodedResponse.vin.color.name
                    let vin = decodedResponse.vin.vin
                    let plate = self.licensePlate
                    let state = self.selectedState
                    self.newVehicle = Vehicle(year: year, make: make, model: model, trim: trim, color: color, plate: plate, state: state, vin: vin)
                }
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    func vehicleTapped(_ vehicle: Vehicle) {
        selectedVehicle = vehicle
        isShowingOptions = true
        
    }
    
    func setDefault() {
        defaultVehicle = selectedVehicle
    }
    
    func deleteTapped() {
        guard selectedVehicle != nil else {
            return
        }
        
        userVehicles.removeAll { vehicle in
            vehicle == selectedVehicle
        }
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
                
            } else {
                vehicleListView
            } //: If-Else
        } //: VStack
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(vm.isShowingAddVehicle ? "Add Vehicle" : "Your Vehicles")
        .onDisappear {
            vm.tabBarVisibility = .visible
        }
        .overlay((vm.userVehicles.isEmpty && !vm.isShowingAddVehicle) ? noVehiclesView : nil, alignment: .center)
        .overlay(vm.isShowingAddVehicle ? nil : addButton, alignment: .bottom)
        .toolbar(vm.tabBarVisibility, for: .tabBar)
        .toolbar(vm.navBarVisibility, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        } //: ToolBar
        .confirmationDialog("Select an option for: \(vm.dialogText)", isPresented: $vm.isShowingOptions, titleVisibility: .visible) {
            Button("Make Default") {
                vm.setDefault()
            }
            
            Button("Delete", role: .destructive) {
                vm.isShowingConfirmDelete = true
            }
            
            Button("Cancel", role: .cancel) {
                vm.isShowingOptions = false
                vm.selectedVehicle = nil
            }
        }
        .alert("Are you sure you want to delete \(vm.dialogText)", isPresented: $vm.isShowingConfirmDelete) {
            Button("Yes, Delete Vehicle", role: .destructive) {
                vm.deleteTapped()
            }
            
            Button("Cancel", role: .cancel) {
                vm.isShowingConfirmDelete = false
                vm.selectedVehicle = nil
            }
        }
    }
    
    
    // MARK: - VIEW VARIABLES
    private var addButton: some View {
        Button {
            vm.addVehicleTapped()
        } label: {
            Text("+ Add A Vehicle")
                .frame(maxWidth: .infinity)
        }
        .modifier(RoundedButtonMod())
        .padding()
        .padding(.bottom, 32)
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
    
    private var defaultText: some View {
        Text("* Default")
            .modifier(TextMod(.callout, .light))
    }
    
    private var noVehiclesView: some View {
        GeometryReader { geo in
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
                    .frame(maxWidth: 300)
                
            } //: VStack
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .offset(y: geo.size.height / 5)
        }
    } //: No Vehicles View
    
    private var vehicleListView: some View {
        ScrollView {
            VStack {
                ForEach(vm.userVehicles) { vehicle in
                    Button {
                        vm.vehicleTapped(vehicle)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(vehicle.year) \(vehicle.make) \("- \(vehicle.plate ?? "")")")
                                    .modifier(TextMod(.title2, .semibold))
                                
                                Text("\(vehicle.model)")
                                
                                Text("Color: \(vehicle.color)")
                            } //: VStack
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 15)
                        } //: HStack
                        .overlay(vehicle == vm.defaultVehicle ? defaultText : nil, alignment: .topTrailing)
                    } //: Card Button
                    .padding(.horizontal)
                    
                    Divider()
                } //: For Each
            } //: VStack
            .padding(.top, 32)
        } //: Scroll
    }
}

struct VehiclesVieww_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VehiclesView()
        }
    }
}

