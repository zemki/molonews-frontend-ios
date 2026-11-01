//
//  ArticleListState.swift
//  ArticleList
//

import Domain
import Foundation

public enum ArticleListState {
    case idle
    case loading(searchString: String)
    case success(articles: [Article], count: Int, searchString: String)
}
