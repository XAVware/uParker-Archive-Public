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
    enum TrailingButtonType { case settings }
    
    var sideItemWidth: CGFloat = 16
    let leftItem: BackButtonType?
    let title: String?
    let rightItem: TrailingButtonType?
    
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
                        .frame(height: 20)
                        .frame(width: sideItemWidth)
                }
                .buttonStyle(PlainButtonStyle())
            default:
                Spacer().frame(width: sideItemWidth)
            }

            Text(title ?? " ")
                .modifier(TextMod(.title3, .semibold))
                .frame(maxWidth: .infinity)
            
            switch self.rightItem {
            case .settings:
                Button {
//                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .fontWeight(.light)
                        .frame(width: sideItemWidth + 5)
                }
                .buttonStyle(PlainButtonStyle())
                
            default:
                Spacer().frame(width: sideItemWidth)
            }
            
//            rightItem ?? AnyView(Spacer().frame(width: sideItemWidth))
                        
        } //: HStack
        .frame(height: 30)
    }
}

// MARK: - PREVIEW
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(leftItem: .chevron, title: "Log In or Sign Up", rightItem: nil)
            .previewLayout(.sizeThatFits)
    }
}
