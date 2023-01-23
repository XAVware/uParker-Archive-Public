//
//  SearchViewWrapper.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/20/23.
//

import SwiftUI
import MapboxSearch
//import MapboxSearchUI


// MARK: - VIEW WRAPPER
struct SearchViewWrapper: UIViewControllerRepresentable {
    @Binding var searchText: String
    typealias UIViewControllerType = SearchViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SearchViewWrapper>) -> SearchViewController {
        return SearchViewController(text: searchText)
    }
    
    func updateUIViewController(_ searchViewController: SearchViewController, context: UIViewControllerRepresentableContext<SearchViewWrapper>) {
        searchViewController.updateQuery(text: searchText)
    }
}


class SearchViewController: UIViewController, SearchEngineDelegate {
    var searchText: String
    let searchEngine = SearchEngine()
    let responseTextView = UITextView()

    // MARK: - INITIALIZER
    init(text: String) {
        searchText = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchEngine.delegate = self
        
        responseTextView.frame = CGRect(x: 0, y: 0, width: 350, height: 300)
        view.addSubview(responseTextView)
    }
    
    // MARK: - TEXT VIEW LOGGER METHODS
    var suggestionList: [SearchSuggestion] = .init()
    
    func dumpSuggestions(_ suggestions: [SearchSuggestion], query: String) {
        self.suggestionList = suggestions
//        print("Number of search results: \(suggestions.count) for query: \(query)")
//        let suggestionsLog = suggestions.map { suggestion in
//            var suggestionString = "\(suggestion.name)"
//            if let description = suggestion.descriptionText {
//                suggestionString += "\n\tdescription: \(description)"
//            } else if let address = suggestion.address?.formattedAddress(style: .medium) {
//                suggestionString += "\n\taddress: \(address)"
//            }
//            if let distance = suggestion.distance {
//                suggestionString += "\n\tdistance: \(Int(distance / 1000)) km"
//            }
//            return suggestionString + "\n"
//        }.joined(separator: "\n")

        let buttonHeight: CGFloat = 50
        
        suggestions.enumerated().forEach { (index, name) in
            let sugBtn: UIButton = UIButton()
            sugBtn.frame = CGRect(x: 0, y: buttonHeight * CGFloat(index), width: view.bounds.width, height: buttonHeight)
            sugBtn.tintColor = .black
            sugBtn.setTitle(suggestions[index].name, for: .normal)
            
            sugBtn.contentHorizontalAlignment = .left
            sugBtn.setTitleColor(.black, for: .normal)
            sugBtn.backgroundColor = .white
            sugBtn.tag = index
            
            sugBtn.addTarget(self, action: #selector(suggestionTapped), for: .touchUpInside)
            
            responseTextView.addSubview(sugBtn)
        }
    }
    
    @objc func suggestionTapped(_ sender: UIButton) {
//        print("Selected \(suggestionList?[sender.tag].name ?? "No suggestion") selected")
        print("Selected \(suggestionList[sender.tag].name)")
        print("\(searchEngine.select(suggestion: suggestionList[sender.tag]))")
    }
    
    @objc func updateQuery(text: String) {
        searchEngine.query = text
    }
    
    // MARK: - SEARCH ENGINE DELEGATE FUNCTIONS
    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        dumpSuggestions(suggestions, query: searchEngine.query)
    }
    
    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        print("Dumping resolved result:", dump(result))
    }
    
    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        print("Error during search: \(searchError)")
    }
    
    // MARK: - SEARCH CONTROLLER DELEGATE FUNCTIONS
    public func searchResultSelected(_ searchResult: MapboxSearch.SearchResult) {}
    public func userFavoriteSelected(_ userFavorite: MapboxSearch.FavoriteRecord) {}
    
}

