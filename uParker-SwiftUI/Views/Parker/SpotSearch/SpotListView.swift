//
//  SpotListView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI

struct SpotListView: View {
    // MARK: - PROPERTIES
    @State private var isExpanded: Bool = false
    @State private var isDragging = false
    @State private var prevDragTranslation: CGSize = CGSize.zero
    @State private var velocity: CGFloat = 0
    @GestureState var isDetectingLongPress = false
    
    @Binding var viewHeight: CGFloat
    let minHeight: CGFloat
    let maxHeight: CGFloat
    
    private var viewButtonOpacity: CGFloat {
        if viewHeight < threshold {
            return (threshold - viewHeight) / (threshold - minHeight)
        } else {
            return (viewHeight - threshold) / (maxHeight - threshold)
        }
    }
    
    private var listCornerRad: CGFloat {
        if viewHeight == minHeight {
            return 30
        } else if viewHeight < maxHeight {
            
            return 30 * (minHeight / viewHeight)
        } else {
            return 0
        }
    }
    
    private var listShadowRad: CGFloat {
        if viewHeight == maxHeight {
            return 0
        } else {
            return 5
        }
    }
    
    private var threshold: CGFloat {
        return (maxHeight - minHeight) / 2
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    self.isDragging = true
                }
                
                velocity = val.predictedEndLocation.y - val.location.y

                let dragAmount = val.translation.height - prevDragTranslation.height
                
                if viewHeight >= maxHeight && dragAmount > 0 {
                    viewHeight += 0
                } else if viewHeight < minHeight {
                    viewHeight += dragAmount / 10
                } else {
                    viewHeight += dragAmount
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = CGSize.zero
                isDragging = false
                
                if velocity > 200 {
                    expandList()
                } else if velocity < -200 {
                    compressList()
                }
                
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
                
                if viewHeight < threshold {
                    Text("List View")
                        .modifier(FootTextMod())
                        .opacity(viewButtonOpacity)
                        .onTapGesture {
                            expandList()
                        }
                        .gesture(dragGesture)
                } else {
                    Button {
                        compressList()
                    } label: {
                        Image(systemName: "map.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                        
                        Text("Map")
                            .modifier(FootTextMod())
                    }
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .frame(height: 30)
                    .background(backgroundGradient)
                    .clipShape(Capsule())
                    .shadow(radius: 5)
                    .opacity(viewButtonOpacity)
                    .padding(.bottom)
                    
                }
                
                if viewHeight < maxHeight {
                    Capsule()
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 6)
                        .opacity(self.isDragging ? 1.0 : 0.6)
                        .padding(.bottom, 10)
                        .gesture(dragGesture)
                }
                
            } //: VStack
            .frame(height: viewHeight)
            .frame(maxWidth: .infinity)
            .background (
                Color.white
                    .cornerRadius(listCornerRad, corners: [.bottomLeft, .bottomRight])
                    .shadow(radius: listShadowRad)
                    .mask(Rectangle().padding(.bottom, -20))
            )
            .transition(.move(edge: .top))
            .gesture(dragGesture)
            .animation(.linear, value: true)
        } //: ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    } //: Body
} //: Struct

// MARK: - PREVIEW
struct SpotListView_Previews: PreviewProvider {
    @State static var viewHeight: CGFloat = 650
    static let minHeight: CGFloat = 120
    static let maxHeight: CGFloat = 650
    static var previews: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            SpotListView(viewHeight: $viewHeight, minHeight: minHeight, maxHeight: maxHeight)
        }
    }
}
