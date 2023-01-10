//
//  HeaderView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct HeaderView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    
    enum BackButtonType { case xmark, chevron }
    
    var sideItemWidth: CGFloat = 16
    let leftItem: BackButtonType?
    let title: String?
    let rightItem: AnyView?
    
    // MARK: - BODY
    var body: some View {
        HStack(alignment: .center) {
            switch self.leftItem {
            case .xmark:
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .fontWeight(.light)
                        .frame(width: sideItemWidth)
                }
                .buttonStyle(PlainButtonStyle())
                
            case .chevron:
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .fontWeight(.light)
                        .frame(width: sideItemWidth)
                }
                .buttonStyle(PlainButtonStyle())
            default:
                Spacer()
                    .frame(width: sideItemWidth)
            }

            Text(title ?? " ")
                .font(.title3)
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity)
            
            rightItem ?? AnyView(Spacer().frame(width: sideItemWidth))
                        
        } //: HStack
        .frame(height: 30)
    }
}

// MARK: - PREVIEW
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(leftItem: .xmark, title: "Log In or Sign Up", rightItem: nil)
            .previewLayout(.sizeThatFits)
    }
}
