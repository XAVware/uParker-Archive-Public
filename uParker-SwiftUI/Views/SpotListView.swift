//
//  SpotListView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI

struct SpotListView: View {
    // MARK: - PROPERTIES
    @State var isExpanded: Bool = false
    @State private var isDragging = false
    
    @State private var viewHeight: CGFloat = 120
    
    let minHeight: CGFloat = 120
    let maxHeight: CGFloat = 650
    let threshold: CGFloat = 420
    
    @State private var prevDragTranslation: CGSize = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    self.isDragging = true
                }
                
                let dragAmount = val.translation.height - prevDragTranslation.height
                
                if viewHeight < minHeight {
                    viewHeight += dragAmount / 10
                } else {
                    viewHeight += dragAmount
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = CGSize.zero
                isDragging = false
                
                if viewHeight >= threshold {
                    expandList()
                } else if viewHeight < threshold {
                    compressList()
                }
                
            }
    }
    
    // MARK: - FUNCTIONS
    func expandList() {
        withAnimation {
            viewHeight = maxHeight
            self.isExpanded = true
        }
    }
    
    func compressList() {
        withAnimation {
            viewHeight = minHeight
            self.isExpanded = false
        }
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 8) {
                Spacer()
                
                Button {
                    if self.isExpanded {
                        compressList()
                    } else {
                        expandList()
                    }
                } label: {

                    Text("List View")
                        .font(.footnote)
                        .onTapGesture {
                            if self.isExpanded {
                                compressList()
                            } else {
                                expandList()
                            }
                        }
                        .gesture(dragGesture)
                }
                .frame(height: 20)
                .frame(maxWidth: .infinity)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                
                Capsule()
                    .frame(width: 40, height: 6)
                    .opacity(0.6)
                    .padding(.bottom, 10)
                    .gesture(dragGesture)

            } //: VStack
            .frame(height: viewHeight)
            .frame(maxWidth: .infinity)
            .background (
                Color.white
                    .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                    .shadow(radius: 5)
                    .mask(Rectangle().padding(.bottom, -20))
            )
            .animation(self.isDragging ? nil : .easeInOut(duration: 0.45), value: true)
            .transition(.move(edge: .top))
            .gesture(dragGesture)
            .animation(.easeInOut, value: true)
        } //: ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

    } //: Body
} //: Struct

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            SpotListView()
        }
    }
}
