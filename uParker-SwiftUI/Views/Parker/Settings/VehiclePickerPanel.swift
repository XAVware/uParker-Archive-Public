//
//  VehiclePickerPanel.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/15/23.
//

import SwiftUI

final class VehicleJSONManager: ObservableObject {
    
    @Published var vehicleList = [VehicleOption]() {
        didSet {
            yearOptions = Set(vehicleList.map { $0.year })
        }
    }
    
    @Published var yearOptions = Set<Int>() {
        didSet {
            selectedYear = yearOptions.max() ?? 0
        }
    }
    
    @Published var makeOptions = Set<String>()
    @Published var modelOptions = Set<String>()
    
    @Published var selectedYear: Int = 0 {
        didSet {
            let makesForYear = vehicleList.filter{ $0.year == selectedYear }
            makeOptions = Set(makesForYear.map { $0.make })
            selectedMake = makeOptions.sorted{$0 < $1}[0]
        }
    }
    
    @Published var selectedMake: String = ""
    
    init() {
        print("Initialized")
        load()
//        selectedYear = yearOptions.sorted{$0 > $1}[0]
//
//        print("Makes for year: \(selectedYear)")
//        let makesForYear: [VehicleOption] = vehicleList.filter { $0.year == selectedYear }
        
    }
    
    func load() {
        let path = Bundle.main.path(forResource: "VehicleOptions", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let allVehicles = try JSONDecoder().decode([VehicleOption].self, from: data)
                    
                    let yearOptions = Set(allVehicles.map { $0.year })
                    let mostRecentYear = yearOptions.max()
                    
                    let makesForYear = allVehicles.filter{ $0.year == mostRecentYear }
                    let makeOptions = Set(makesForYear.map { $0.make })
                    
                    DispatchQueue.main.async {
                        self.vehicleList = allVehicles
//                        self.yearOptions = Set(allVehicles.map { $0.year })
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
    
//    @State var selectedYear: Int = 2022
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                Text("Year:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Picker("", selection: $vehicles.selectedYear) {
                    ForEach(vehicles.yearOptions.sorted{$0 > $1}, id: \.self) { year in
                        Text(String(year))
                    }
                }
                
            } //: HStack
//            .onChange(of: vehicles.yearOptions) { _ in
//                self.selectedYear = vehicles.yearOptions.sorted{$0 > $1}[0]
//            }
            
            HStack {
                Text("Make:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Picker("", selection: $vehicles.selectedMake) {
                    ForEach(vehicles.makeOptions.sorted{$0 < $1}, id: \.self) { make in
                        Text(String(make))
                    }
                }
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
