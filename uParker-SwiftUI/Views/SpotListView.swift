//
//  SpotListView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI

struct SpotListView: View {
    // MARK: - PROPERTIES
    @State var initialHeight: CGFloat = 170
    @State var isExpanded: Bool = false
    @State private var isDragging = false
    
    @State private var viewHeight: CGFloat = 170
    
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    let threshold: CGFloat = 300
    
    @State private var prevDragTranslation: CGSize = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    self.isDragging = true
                }
                
                let dragAmount = val.translation.height - prevDragTranslation.height
                
                if viewHeight < initialHeight {
                    viewHeight += dragAmount / 10
                } else {
                    viewHeight += dragAmount
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = CGSize.zero
                isDragging = false
                
                
            }
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 0) {
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
                
                ZStack {
                    Capsule()
                        .frame(width: 40, height: 6)
                        .opacity(0.6)
                } //: ZStack
                .frame(height: 35)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.00001))
                .gesture(dragGesture)
                
            } //: VStack
            .frame(height: viewHeight)
            .frame(maxWidth: .infinity)
            .background (
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
            )
            .animation(self.isDragging ? nil : .easeInOut(duration: 0.45), value: true)
            .transition(.move(edge: .top))
            
        } //: ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .animation(.easeInOut, value: true)
        
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            SpotListView()
        }
    }
}
