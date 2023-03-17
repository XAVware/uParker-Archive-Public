//
//  SpotCardView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/16/23.
//

import SwiftUI

struct SpotCardView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var vm: MapViewModel
    
    enum Size { case preview, list }
    let size: Size
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            Image("driveway")
                .resizable()
                .scaledToFill()
                .cornerRadius(10)

            HStack {
                VStack(alignment: .leading) {
                    Text("Spot Name")
                        .modifier(TextMod(.title3, .semibold))

                    Text("State College, Pennsylvania")
                        .modifier(TextMod(.body, .semibold, .gray))
                        .padding(.bottom, 1)

                    Text("$3.00 / Day")
                        .modifier(TextMod(.callout, .semibold))
                } //: VStack

                Spacer()

                VStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14)

                        Text("4.92")
                            .modifier(TextMod(.callout, .regular))
                    } //: HStack

                    Spacer()
                } //: VStack
            } //: HStack
        } //: VStack
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onTapGesture {
            vm.isShowingSpot.toggle()
        }
    } //: Body
    
    @ViewBuilder private var content: some View {
        switch size {
        case .list:
            listCard
        case .preview:
            smallCard
        }
    }
    
    private var listCard: some View {
        GeometryReader { geo in
            Image("driveway")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width - 64, height: size == .list ? (geo.size.height / 3) : (geo.size.height / 3) - 60, alignment: .top)
                .clipped()
                .overlay(
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Spot Name")
                                .modifier(TextMod(.title3, .semibold))
                            if size == .list {
                                Text("State College, Pennsylvania")
                                    .modifier(TextMod(.body, .semibold, .gray))
                                    .padding(.bottom, 1)
                            }
                            Text("$3.00 / Day")
                                .modifier(TextMod(.callout, .semibold))
                        } //: VStack

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(alignment: .center, spacing: 6) {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10)

                                Text("4.92")
                                    .modifier(TextMod(.footnote, .regular))
                            } //: HStack

                            Spacer().frame(maxHeight: .infinity)
                        } //: VStack
                    } //: HStack
                        .padding(.vertical, 8)
                        .padding(.horizontal, size == .list ? 0 : 8)
                        .frame(height: size == .list ? 80 : 60)
                        .background(Color.white)
                    , alignment: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
                .padding(.horizontal)
                .shadow(radius: size == .list ? 0 : 5)
                .onTapGesture {
                    vm.isShowingSpot.toggle()
                }
        } //: Geometry Reader

    }
    
    private var smallCard: some View {
        GeometryReader { geo in
            Image("driveway")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width - 64, height: (geo.size.height / 3) - 60, alignment: .center)
                .clipped()
                .overlay(
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Spot Name")
                                .modifier(TextMod(.title3, .semibold))

                            Text("$3.00 / Day")
                                .modifier(TextMod(.callout, .semibold))
                        } //: VStack

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(alignment: .center, spacing: 6) {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10)

                                Text("4.92")
                                    .modifier(TextMod(.footnote, .regular))
                            } //: HStack

                            Spacer().frame(maxHeight: .infinity)
                        } //: VStack
                    } //: HStack
                        .padding(8)
                        .frame(height: 60)
                        .background(Color.white)
                    , alignment: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
                .padding(.horizontal)
                .shadow(radius: 5)
                .onTapGesture {
                    vm.isShowingSpot.toggle()
                }
        } //: Geometry Reader
    }
}

struct SpotCardView_Previews: PreviewProvider {
    static var previews: some View {
        SpotCardView(size: .preview)
    }
}
