//
//  PaymentMethodsView.swift
//  uParker-SwiftUI
//
//  Created by Ryan Smetana on 2/14/23.
//

import SwiftUI

class Json: ObservableObject {
    @Published var json = [VehicleOption]()
    
    init() {
        load()
    }
    
    func load() {
        let path = Bundle.main.path(forResource: "VehicleOptions", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let json = try JSONDecoder().decode([VehicleOption].self, from: data)
                    DispatchQueue.main.async {
                        self.json = json
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

struct PaymentMethodsView: View {
    @ObservedObject var datas = Json()
    
    var body: some View {
        Text("List Count: \(datas.json.count)")
    }
}

struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodsView()
    }
}
