//
//  SearchField.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI

struct SearchField: View {
    // MARK: - PROPERTIES
    let iconSize: CGFloat = 15
    
    @State private var searchIsExpanded: Bool = true
    @State private var destinationIsExpanded = true
    @State private var dateIsExpanded = false
    @State private var destination: String = "Beaver Stadium"
    @State private var date: Date = Date()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var dateClosedRange: ClosedRange<Date> {
      let min = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
      let max = Calendar.current.date(byAdding: .day, value: 180, to: Date())!
      return min...max
    }
    
    var dateText: String {
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
            return "Today"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    // MARK: - FUNCTIONS
//    private func convertDateToString(_ date: Date) -> {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//
//        return formatter.string(from: date)
//
//    }
    
    // MARK: - BODY
    var body: some View {
        if self.searchIsExpanded {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        withAnimation {
                            self.searchIsExpanded = false
                        }
                        self.destinationIsExpanded = true
                        self.dateIsExpanded = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize)
                    }
                    .frame(width: 30, height: 30)
                    .overlay(Circle().stroke(.gray))
                    
                    Text("Search")
                        .modifier(SmallTitleMod())
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    
                    Spacer().frame(width: 30)
                } //: HStack
                
                DisclosureGroup(isExpanded: $destinationIsExpanded) {
                    AnimatedTextField(boundTo: $destination, placeholder: "Destination")
                        .padding(.top)
                } label: {
                    HStack {
                        Text("Where to?")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !destinationIsExpanded {
                            Text(destination)
                                .font(.footnote)
                        }
                    }
                }
                .modifier(SearchCardMod())
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("When?")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(dateText)
                            .font(.footnote)
                    }
                    
                    if dateIsExpanded {
                        DatePicker( "Pick a date", selection: $date, in: dateClosedRange, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                    }
                    
                } //: VStack
                .padding(.horizontal)
                .frame(height: self.dateIsExpanded ? 380 : 60)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
                .shadow(radius: 4)
                .onTapGesture {
                    withAnimation {
                        self.destinationIsExpanded = false
                        self.dateIsExpanded = true
                    }
                }
                
                
                
                Spacer()
            } //: VStack
            .padding()
            .animation(.linear, value: true)
            .background(.ultraThinMaterial)
            .opacity(self.searchIsExpanded ? 1 : 0)
        } else {
            // MARK: - SEARCH BAR
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize)
                    
                    VStack(alignment: .leading) {
                        Text("Where to?")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("\(destination) - \(date)")
                            .font(.caption)
                    } //: VStack
                    .fontDesign(.rounded)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        //
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize)
                    }
                    .frame(width: 35, height: 35)
                    .overlay(Circle().stroke(.gray))
                } //: HStack
                .padding(.horizontal)
                .frame(height: searchBarHeight)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: searchBarHeight)
                )
                .shadow(radius: 4)
                .onTapGesture {
                    withAnimation {
                        self.searchIsExpanded = true
                    }
                }
                
                Spacer()
            } //: VStack
            .padding()
            .opacity(self.searchIsExpanded ? 0 : 1)
        }
        
    }
}

// MARK: - PREVIEW
struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField()
            .previewLayout(.sizeThatFits)
        //            .background(.blue)
            .padding()
    }
}
