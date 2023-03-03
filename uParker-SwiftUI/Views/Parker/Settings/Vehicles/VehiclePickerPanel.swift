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
            isLoadingPickers = false
        }
    }
    
    @Published var selectedTrim: String = "N/A"
    
    @Published var selectedColor: String = "--Select Color--"
    
    let vehicleColors: [String] = ["Beige", "Black", "Blue", "Brown", "Cyan", "Gold", "Gray", "Green", "Maroon", "Orange", "Pink", "Purple", "Red", "Silver", "White", "Yellow"]
    
    @Published var isLoadingPickers: Bool = true
    
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
    
    struct VehicleOption: Codable, Identifiable {
        enum CodingKeys: CodingKey {
            case year
            case category
            case model
            case make
        }
        
        var id: UUID = UUID()
        let year: Int
        let category: String
        let model: String
        let make: String
    }

}

struct VehiclePickerPanel: View {
    // MARK: - PROPERTIES
    @Binding var newVehicle: Vehicle?
    @ObservedObject var vehicleManager = VehicleJSONManager()
    @EnvironmentObject var vm: VehiclesViewModel
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            
            Text("Please enter your vehicle information")
                .modifier(TextMod(.title3, .regular))
                .padding(.bottom, 32)
            
            yearRow
            makeRow
            modelRow
            trimRow
            colorRow
            
            Spacer()
            
            saveButton
        } //: VStack
        .padding()
        .overlay(vehicleManager.isLoadingPickers ? loadingView : nil)
        
    } //: Body
    
    
    // MARK: - VIEW VARIABLES
    private var saveButton: some View {
        Button {
            
            vm.saveTapped()
        } label: {
            Text("Confirm & Save")
                .frame(maxWidth: .infinity)
        }
        .modifier(RoundedButtonMod())
        .padding()
    } //: Save Button
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .tint(primaryColor)
                .frame(width: 50, height: 50)
                .scaleEffect(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    } //: Loading View
    
    private var yearRow: some View {
        VStack {
            HStack {
                Text("Year:")
                    .modifier(TextMod(.title3, .semibold))
                
                yearPicker
            } //: HStack
            
            Divider()
        } //: VStack
    } //: Year Row
    
    private var makeRow: some View {
        VStack {
            HStack {
                Text("Make:")
                    .modifier(TextMod(.title3, .semibold))
                
                makePicker
            } //: HStack
            Divider()
        } //: VStack
    } //: Make Row
    
    private var modelRow: some View {
        VStack {
            HStack {
                Text("Model:")
                    .modifier(TextMod(.title3, .semibold))
                
                modelPicker
            } //: HStack
            
            Divider()
        } //: VStack
    } //: Model Row
    
    private var trimRow: some View {
        VStack {
            HStack {
                Text("Trim:")
                    .modifier(TextMod(.title3, .semibold))
                
                trimPicker
            } //: HStack
            
            Divider()
        } //: VStack
    } //: Trim Row
    
    private var colorRow: some View {
        HStack {
            Text("Color:")
                .modifier(TextMod(.title3, .semibold))
            
            colorPicker
        } //: HStack
    }
    
    private var yearPicker: some View {
        Picker("", selection: $vehicleManager.selectedYear) {
            ForEach(vehicleManager.yearOptions.sorted{$0 > $1}, id: \.self) { year in
                Text(String(year))
                    .modifier(TextMod(.title3, .regular))
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    } //: Year Picker
    
    private var makePicker: some View {
        Picker("", selection: $vehicleManager.selectedMake) {
            ForEach(vehicleManager.makeOptions.sorted{$0 < $1}, id: \.self) { make in
                Text(make)
                    .modifier(TextMod(.title3, .regular))
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    } //: Make Picker
    
    private var modelPicker: some View {
        Picker("", selection: $vehicleManager.selectedModel) {
            ForEach(vehicleManager.modelOptions.sorted{$0 < $1}, id: \.self) { model in
                Text(model)
                    .modifier(TextMod(.title3, .regular))
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    } //: Model Picker
    
    private var trimPicker: some View {
        Picker("", selection: $vehicleManager.selectedTrim) {
            ForEach(vehicleManager.trimOptions.sorted{$0 < $1}, id: \.self) { trim in
                Text(trim)
                    .modifier(TextMod(.title3, .regular))
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    } //: Trim Picker
    
    private var colorPicker: some View {
        Picker("", selection: $vehicleManager.selectedColor) {
            ForEach(vehicleManager.vehicleColors.sorted{$0 < $1}, id: \.self) { color in
                Text(color)
                    .modifier(TextMod(.title3, .regular))
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    } //: Color Picker
}

struct VehiclePickerPanel_Previews: PreviewProvider {
    @State static var newVehicle: Vehicle?
    static var previews: some View {
        VehiclePickerPanel(newVehicle: $newVehicle)
    }
}
