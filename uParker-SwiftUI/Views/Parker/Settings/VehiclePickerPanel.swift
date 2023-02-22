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
    
    @Published var selectedYear: Int = 0 {
        didSet {
            let makesForYear = vehicleList.filter{ $0.year == selectedYear }
            makeOptions = Set(makesForYear.map { $0.make })
            selectedMake = makeOptions.sorted{$0 < $1}[0]
        }
    }
    
    @Published var makeOptions = Set<String>() {
        didSet {
            let modelsForMake = vehicleList.filter{ $0.year == selectedYear && $0.make == selectedMake }
            modelOptions = Set(modelsForMake.map { $0.model })
            if modelOptions.count > 0 {
                selectedModel = modelOptions.sorted{$0 < $1}[0]
            }
        }
    }
    
    @Published var selectedMake: String = "" {
        didSet {
            let modelsForMake = vehicleList.filter{ $0.year == selectedYear && $0.make == selectedMake }
            modelOptions = Set(modelsForMake.map { $0.model })
            if modelOptions.count > 0 {
                selectedModel = modelOptions.sorted{$0 < $1}[0]
            }
        }
    }
    
    @Published var modelOptions = Set<String>() {
        didSet {
            let trimsForModel = vehicleList.filter{ $0.year == selectedYear && $0.make == selectedMake && $0.model == selectedModel }
            trimOptions = Set(trimsForModel.map { $0.category })
            if trimOptions.count > 0 {
                selectedTrim = trimOptions.sorted{$0 < $1}[0]
            }
        }
    }
    
    @Published var selectedModel: String = "" {
        didSet {
            let trimsForModel = vehicleList.filter{ $0.year == selectedYear && $0.make == selectedMake && $0.model == selectedModel }
            trimOptions = Set(trimsForModel.map { $0.category })
            selectedTrim = trimOptions.sorted{$0 < $1}[0]
        }
    }
    
    @Published var trimOptions = Set<String>() {
        didSet {
            if trimOptions.count > 0 {
                selectedTrim = trimOptions.sorted{$0 < $1}[0]
            }
        }
    }
    
    @Published var selectedTrim: String = "N/A"
    
    init() {
        print("Initialized")
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
    @ObservedObject var vehicleManager = VehicleJSONManager()
        
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                Text("Year:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Picker("", selection: $vehicleManager.selectedYear) {
                    ForEach(vehicleManager.yearOptions.sorted{$0 > $1}, id: \.self) { year in
                        Text(String(year))
                    }
                }
                
            } //: HStack
            
            HStack {
                Text("Make:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Picker("", selection: $vehicleManager.selectedMake) {
                    ForEach(vehicleManager.makeOptions.sorted{$0 < $1}, id: \.self) { make in
                        Text(make)
                    }
                }
            } //: HStack
            
            
            HStack {
                Text("Model:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Picker("", selection: $vehicleManager.selectedModel) {
                    ForEach(vehicleManager.modelOptions.sorted{$0 < $1}, id: \.self) { model in
                        Text(model)
                    }
                }
            } //: HStack
            
            HStack {
                Text("Trim:")
                    .modifier(TextMod(.title3, .semibold))
                
                Spacer()
                
                Picker("", selection: $vehicleManager.selectedTrim) {
                    ForEach(vehicleManager.trimOptions.sorted{$0 < $1}, id: \.self) { trim in
                        Text(trim)
                    }
                }
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
