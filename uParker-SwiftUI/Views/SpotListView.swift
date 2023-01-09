//
//  SpotListView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI

struct SpotListView: View {
    // MARK: - PROPERTIES
    @State var initialHeight: CGFloat = 110
    @State var isExpanded: Bool = false
    @State private var isDragging = false
    
    @State private var curHeight: CGFloat = 400
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    
    
    @State private var prevDragTranslation: CGSize = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    self.isDragging = true
                }
                let dragAmount = val.translation.height - prevDragTranslation.height
                if curHeight >= maxHeight || curHeight <= minHeight {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = CGSize.zero
                isDragging = false
                if curHeight > maxHeight {
                    curHeight = maxHeight
                } else if curHeight < minHeight {
                    curHeight = minHeight
                }
            }
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .edgesIgnoringSafeArea(.all)
                
            mainView
            .transition(.move(edge: .bottom))
        } //: ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: true)
        
    }
    
    var mainView: some View {
        VStack {
            ZStack {
                Capsule()
                    .frame(width: 40, height: 6)
            } //: ZStack
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            .gesture(dragGesture)
            
            ZStack {
                VStack {
                    Spacer()
                    
                    Button {
                        withAnimation { self.isExpanded.toggle() }
                    } label: {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                        
                        Spacer().frame(width: 12)
                        
                        Text("List View")
                            .font(.footnote)
                    }
                    .frame(height: 20)
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    
                    
                } //: VStack
            } //: ZStack

        } //: VStack
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background (
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                Rectangle()
                    .frame(height: curHeight / 2)
            }
            .foregroundColor(Color.white)
        )
        .animation(self.isDragging ? nil : .easeInOut(duration: 0.45), value: true)
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListView()
    }
}
