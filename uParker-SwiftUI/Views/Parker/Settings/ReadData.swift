//
//  ReadData.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/13/23.
//

//import SwiftUI
//
//class ReadData: ObservableObject  {
//    @Published var vehicleOptions: [VehicleOption] = [VehicleOption]()
//    
//    init(){
//        
//        
//        loadData { result in
//            self.vehicleOptions = result ?? []
//        }
//        
////        loadData()
//    }
//    
//    func loadData(completion: @escaping ([VehicleOption]?) -> Void)  {
//        print("Load Data Initialized")
//        
////        guard let vehicleList: [VehicleOption] = Bundle.main.decode("VehicleOptions.json") else {
////            print("Unable to load")
////            return
////        }
//        
//        
//        do {
//            guard let url = Bundle.main.url(forResource: "VehicleOptions", withExtension: "json")
//            else {
//                print("Json file not found")
//                return
//            }
//            
//            let data = try Data(contentsOf: url)
//            
//            print("Data Count: \(data.count)")
//            let vehicleOptions = try JSONDecoder().decode([VehicleOption].self, from: data)
//            completion(vehicleOptions)
////            self.vehicleOptions = vehicleOptions
//            
//            
//            
//        } catch {
//            print(error)
//        }
////        print(data)
////        print(self.vehicleOptions.count)
//        
//    }
//     
//}
