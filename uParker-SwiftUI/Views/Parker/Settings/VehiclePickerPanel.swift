//
//  VehiclePickerPanel.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/15/23.
//

import SwiftUI

class VehicleJSONManager: ObservableObject {
    
    @Published var vehicleList = [VehicleOption]()
    @Published var yearOptions = [String]()
    @Published var makeOptions = [String]()
    @Published var modelOptions = [String]()
    
    init() {
        load()
    }
    
    func load() {
        let path = Bundle.main.path(forResource: "VehicleOptions", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let allVehicles = try JSONDecoder().decode([VehicleOption].self, from: data)
                    var years: [String] = [String]()
                    Set(allVehicles.map { $0.year }).forEach { year in
                        years.append("\(year)")
                    }
                    
                    DispatchQueue.main.async {
                        self.vehicleList = allVehicles
                        self.yearOptions = years
                    }
                } else {
                    print("No Data")
                }
            } catch {
                print("Error converting JSON: \(error)")
            }
        }.resume()
    }
}

struct VehiclePickerPanel: View {
    // MARK: - PROPERTIES
    @Binding var newVehicle: Vehicle?
    @ObservedObject var vehicles = VehicleJSONManager()
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Text("List Count: \(vehicles.vehicleList.count)")
            Text("List Count: \(String(describing: vehicles.yearOptions))")
            HStack {
                Text("Year:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Text(self.newVehicle?.year ?? "Empty")
                    .modifier(TextMod(.title3, .regular))
            } //: HStack
            
            HStack {
                Text("Make:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Text(self.newVehicle?.make ?? "Empty")
                    .modifier(TextMod(.title3, .regular))
            } //: HStack
            
            
            HStack {
                Text("Model:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Text(self.newVehicle?.model ?? "Empty")
                    .modifier(TextMod(.title3, .regular))
            } //: HStack
            
            HStack {
                Text("Trim:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Text(self.newVehicle?.trim ?? "Empty")
                    .modifier(TextMod(.title3, .regular))
            } //: HStack
            
            HStack {
                Text("Color:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Text(self.newVehicle?.color.name ?? "Empty")
                    .modifier(TextMod(.title3, .regular))
            } //: HStack
        } //: VStack
        .frame(width: 300)
    }
}

struct VehiclePickerPanel_Previews: PreviewProvider {
    @State static var newVehicle: Vehicle?
    static var previews: some View {
        VehiclePickerPanel(newVehicle: $newVehicle)
    }
}
