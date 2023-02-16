//
//  VehiclePickerPanel.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/15/23.
//

import SwiftUI

class VehicleJSONManager: ObservableObject {
    
    @Published var vehicleList = [VehicleOption]()
    @Published var yearOptions = Set<Int>()
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
                    
                    DispatchQueue.main.async {
                        self.vehicleList = allVehicles
                        self.yearOptions = Set(allVehicles.map { $0.year })
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
    
    @State var selectedYear: Int?
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                Text("Year:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Picker("", selection: $selectedYear) {
                    ForEach(vehicles.yearOptions.sorted{$0 > $1}, id: \.self) { year in
                        Text(String(year))
                    }
                }
                
            } //: HStack
            .onTapGesture {
                print("Tapped")
                print(selectedYear ?? "Empty")
            }
            .onChange(of: vehicles.yearOptions) { _ in
                self.selectedYear = vehicles.yearOptions.sorted{$0 > $1}[0]
            }
            
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
