//
//  SuggestionController.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/22/23.
//

import SwiftUI
import MapboxSearch

class SuggestionController: SearchEngineDelegate, ObservableObject {

    @Published var suggestionList: [SearchSuggestion] = []
    let searchEngine = SearchEngine()
    var searchText: String = ""
    
    @Published var lastSelectedSuggestion: SimpleSuggestion?
    
    init() {
        searchEngine.delegate = self
    }
    
    func selectSuggestion(_ suggestion: SearchSuggestion, completion: @escaping (SimpleSuggestion?) -> Void) {
        searchEngine.select(suggestion: suggestion)
        
        DispatchQueue.main.async {
            guard self.lastSelectedSuggestion != nil else {return}
            completion(self.lastSelectedSuggestion)
        }
    }
    
    @objc func updateQuery(text: String) {
        searchEngine.query = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dumpSuggestions(_ suggestions: [SearchSuggestion], query: String) {
        self.suggestionList = suggestions
    }
     
    // MARK: - SEARCH ENGINE DELEGATE METHODS
    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        dumpSuggestions(suggestions, query: searchEngine.query)
    }
    
    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        lastSelectedSuggestion = SimpleSuggestion(name: result.name, address: result.address, coordinate: result.coordinate, categories: result.categories)
    }
    
    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        print("Error during search: \(searchError)")
    }
    
    
}
