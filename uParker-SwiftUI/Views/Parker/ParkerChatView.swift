//
//  ParkerChatView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI
import MapboxSearch
import MapboxSearchUI

struct ParkerChatView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(leftItem: nil, title: nil, rightItem: nil)
            
            if sessionManager.isLoggedIn == false {
                NeedLoginView(title: "Chat", mainHeadline: "Login to view conversations", mainDetail: "Once you login, your message inbox will appear here.")
            } else {
                SearchControllerWrapper()
            }
            
            Spacer()
        } //: VStack
        .padding()
    }
}

// MARK: - PREVIEW
struct ParkerChatView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerChatView()
            .environmentObject(SessionManager())
    }
}


class SearchController: UIViewController {
    let searchController = MapboxSearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        
        let panelController = MapboxPanelController(rootViewController: searchController)
        addChild(panelController)
    }
}

extension SearchController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [MapboxSearch.SearchResult]) {
        //
    }
    
    func searchResultSelected(_ searchResult: SearchResult) {
        print("Called")
    }
    func categorySearchResultsReceived(results: [SearchResult]) { }
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) { }
}

struct SearchControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SearchController {
        SearchController()
    }
    
    func updateUIViewController(_ uiViewController: SearchController, context: Context) {
        //
    }
    
    typealias UIViewControllerType = SearchController
    
    
}
