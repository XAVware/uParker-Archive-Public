//
//  PaymentMethodsView.swift
//  uParker-SwiftUI
//
//  Created by Ryan Smetana on 2/14/23.
//

import SwiftUI


struct PaymentMethodsView: View {
    // MARK: - PROPERTIES
    @State private var newVehicle: Vehicle?
    
    // MARK: - BODY
    var body: some View {
        VehiclePickerPanel(newVehicle: $newVehicle)
    }
}

struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodsView()
    }
}
