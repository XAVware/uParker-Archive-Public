//
//  SearchField.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI
import MapboxSearch
import MapboxSearchUI

struct SearchField: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var locationManager: LocationManager
    let iconSize: CGFloat = 15
    
    @State private var searchIsExpanded: Bool = false
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
    private func searchBarTapped() {
        withAnimation {
            self.searchIsExpanded = true
        }
    }
    
    private func closeSearch() {
        withAnimation {
            self.searchIsExpanded = false
        }
        self.destinationIsExpanded = true
        self.dateIsExpanded = false
    }
    
    private func searchTapped() {
        closeSearch()
    }
    
    private func resetTapped() {
        self.destination = "Beaver Stadium"
        self.date = Date()
        
        withAnimation {
            self.destinationIsExpanded = true
            self.dateIsExpanded = false
        }
    }
    
    // MARK: - BODY
    var body: some View {
        if self.searchIsExpanded {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        closeSearch()
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
                
                // MARK: - DESTINATION
                DisclosureGroup(isExpanded: $destinationIsExpanded) {
                    VStack {
                        AnimatedTextField(boundTo: $destination, placeholder: "Destination")
                            .padding(.top)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 8)
                        
                        SearchViewWrapper()
                    }
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
                    } //: HStack
                } //: Disclosure Group
//                .modifier(SearchCardMod())
                
                // MARK: - DATE
                DisclosureGroup(isExpanded: $dateIsExpanded) {
                    DatePicker( "Pick a date", selection: $date, in: dateClosedRange, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.top)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                        .clipped()
                } label: {
                    HStack {
                        Text("When?")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !dateIsExpanded {
                            Text(dateText)
                                .font(.footnote)
                        }
                    } //: HStack
                } //: Disclosure Group
                .modifier(SearchCardMod())
                
                Spacer()
            } //: VStack
            .padding()
            .background(.ultraThinMaterial)
            .opacity(self.searchIsExpanded ? 1 : 0)
            .overlay(
                HStack {
                    Button {
                        resetTapped()
                    } label: {
                        Text("Reset")
                            .underline()
                            .font(.callout)
                            .padding()
                    }
                    .frame(maxWidth: 100)
                    
                    Spacer()
                    
                    Button {
                        searchTapped()
                    } label: {
                        HStack(spacing: 15) {
                            Text("Search")
                            
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize)
                        }
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .frame(width: 150, height: 45)
                    .background(backgroundGradient)
                    .clipShape(Capsule())
                    .shadow(radius: 4)
                    
                } //: HStack
                    .padding()
                , alignment: .bottom)
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
                            .modifier(SmallTitleMod())
                        
                        Text("\(destination) - \(dateText)")
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
                .clipShape(RoundedRectangle(cornerRadius: searchBarHeight))
                .shadow(radius: 4)
                .onTapGesture {
                    searchBarTapped()
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
            .padding()
    }
}


// MARK: - VIEW WRAPPER
struct SearchViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = SearchViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext< SearchViewWrapper >) -> SearchViewController {
        return SearchViewController()
    }
    
    func updateUIViewController(_ searchViewController: SearchViewController, context: UIViewControllerRepresentableContext< SearchViewWrapper >) {
    }
}

extension SearchViewController: SearchControllerDelegate {
    public func searchResultSelected(_ searchResult: MapboxSearch.SearchResult) {
        //
    }
    
    public func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        //
    }
    
    public func userFavoriteSelected(_ userFavorite: MapboxSearch.FavoriteRecord) {
        //
    }
    
    
}


class SearchViewController: TextViewLoggerViewController {
    let searchEngine = SearchEngine()
    let textField = UITextField()
    let responseLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        textField.borderStyle = .line
        textField.addTarget(self, action: #selector(textFieldTextDidChanged), for: .editingChanged)
        responseLabel.lineBreakMode = .byTruncatingMiddle
        
        view.addSubview(textField)
        view.addSubview(responseLabel)
        
        searchEngine.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textField.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 50*2, height: 32)
        responseLabel.frame = CGRect(x: 50, y: textField.frame.maxY + 16, width: view.bounds.width - 50*2, height: 32)
    }
}

extension SearchViewController {
    @objc
    func textFieldTextDidChanged() {
        /// Update `SearchEngine.query` field as fast as you need. `SearchEngine` waits a short amount of time for the query string to optimize network usage.
        searchEngine.query = textField.text!
    }
}

extension SearchViewController: SearchEngineDelegate {
    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        dumpSuggestions(suggestions, query: searchEngine.query)
    }
    
    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        print("Dumping resolved result:", dump(result))
    }
    
    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        print("Error during search: \(searchError)")
    }
}

class TextViewLoggerViewController: UIViewController {
    let responseTextView = UITextView()
    
    func logUI(_ message: String) {
        responseTextView.text = "Response View"
    }
    
    func dumpSuggestions(_ suggestions: [SearchSuggestion], query: String) {
        print("Number of search results: \(suggestions.count) for query: \(query)")
        let headerText = "query: \(query), count: \(suggestions.count)"
        
        let suggestionsLog = suggestions.map { suggestion in
            var suggestionString = "\(suggestion.name)"
            if let description = suggestion.descriptionText {
                suggestionString += "\n\tdescription: \(description)"
            } else if let address = suggestion.address?.formattedAddress(style: .medium) {
                suggestionString += "\n\taddress: \(address)"
            }
            if let distance = suggestion.distance {
                suggestionString += "\n\tdistance: \(Int(distance / 1000)) km"
            }
            return suggestionString + "\n"
        }.joined(separator: "\n")
        
        logUI(headerText + "\n\n" + suggestionsLog)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        responseTextView.isEditable = false
        view.addSubview(responseTextView)
        
        addConstraints()
    }
    
    func addConstraints() {
        let textViewConstraints = [
            responseTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            responseTextView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            responseTextView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            responseTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 60)
        ]
        responseTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(textViewConstraints)
    }
}
