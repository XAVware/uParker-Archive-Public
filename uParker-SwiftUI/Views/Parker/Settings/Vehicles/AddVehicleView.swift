//
//  AddVehicleView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/24/23.
//

import SwiftUI

struct AddVehicleView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: VehiclesViewModel
    
    @FocusState private var focusField: FocusText?
    enum FocusText { case licensePlate }
    
    var body: some View {
        switch vm.selectedMethod {
        case .none:
            VStack(spacing: 16) {
                Text("How do you want to add your vehicle?")
                    .modifier(TextMod(.title, .regular))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 32)
                
                Button {
                    vm.selectedMethod = .licensePlate
                } label: {
                    Text("License Plate")
                        .frame(maxWidth: .infinity)
                }
                .modifier(OutlinedButtonMod())
                
                OrDivider()
                    .padding(.horizontal)
                
                Button {
                    vm.selectedMethod = .manual
                } label: {
                    Text("Year, Make & Model")
                        .frame(maxWidth: .infinity)
                }
                .modifier(OutlinedButtonMod())
                
            } //: VStack
            .padding()
            
        case .licensePlate:
            ZStack {
                VStack(spacing: 48) {
                    Text("Enter License Plate")
                        .modifier(TextMod(.title2, .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    licensePlateField
                    
                    Button {
                        focusField = nil
                        vm.lookupPlate()
                    } label: {
                        Text("Find Vehicle Info")
                            .frame(maxWidth: .infinity)
                    }
                    .modifier(RoundedButtonMod())
                    
                } //: VStack
                .frame(width: 300)
                
                if vm.newVehicle != nil {
                    foundVehicleView
                }
                
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
            }
        case .manual:
            VehiclePickerPanel(newVehicle: $vm.newVehicle)
                .environmentObject(vm)
        } //: Switch
    }
    
    // MARK: - VIEW VARIABLES
    private var licensePlateField: some View {
        HStack {
            AnimatedTextField(boundTo: $vm.licensePlate, placeholder: "License Plate")
                .focused($focusField, equals: .licensePlate)
            
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
    }
    
    private struct VehicleDetail: Hashable {
        let header: String
        let detail: String
    }
    
    private var vehicleDetails: [VehicleDetail] {
//        var model = "Empty"
//
//        if let safeModel = vm.newVehicle?.model {
//            if safeModel.count > 0 {
//                model = safeModel
//            }
//        }
//
//        if let trim = vm.newVehicle?.trim {
//            if trim.count > 0 {
//                if model == "Empty" {
//                    model = trim
//                } else {
//                    model.append(" \(trim)")
//                }
//            }
//        }
        
        let detailArray: [VehicleDetail] = [
            VehicleDetail(header: "Plate:", detail: "\(vm.selectedState)-\(vm.licensePlate)"),
            VehicleDetail(header: "Year:", detail: vm.newVehicle?.year ?? "Empty"),
            VehicleDetail(header: "Make:", detail: vm.newVehicle?.make ?? "Empty"),
            VehicleDetail(header: "Model:", detail: "\(vm.newVehicle?.model ?? "")"),
//            VehicleDetail(header: "Trim:", detail: vm.newVehicle?.trim ?? "Empty"),
            VehicleDetail(header: "Style:", detail: vm.newVehicle?.trim ?? "Empty"),
//            VehicleDetail(header: "Engine:", detail: vm.newVehicle?.engine ?? "Empty"),
//            VehicleDetail(header: "Transmission:", detail: vm.newVehicle?.transmission ?? "Empty"),
//            VehicleDetail(header: "Drivetrain:", detail: vm.newVehicle?.driveType ?? "Empty"),
            VehicleDetail(header: "Color:", detail: vm.newVehicle?.color ?? "Empty"),
//            VehicleDetail(header: "Vin:", detail: vm.newVehicle?.vin ?? "Empty")
        ]
        return detailArray
    }
    
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
            
            ForEach(vehicleDetails, id: \.self) { detail in
                HStack {
                    Text(detail.header)
                        .modifier(TextMod(.title3, .semibold))

                    Spacer()

                    Text(detail.detail)
                        .modifier(TextMod(.title3, .regular))
                } //: HStack
                Divider()
            }
            
            Spacer()
            
            Button {
                focusField = nil
                vm.saveTapped()
            } label: {
                Text("Confirm & Save")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())
            .padding()
        } //: VStack
        .background(Color.white)
    } //: Found Vehicle View
}

struct AddVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        AddVehicleView()
            .environmentObject(VehiclesViewModel())
    }
}
