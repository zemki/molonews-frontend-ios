//
//  ArticleDetailState.swift
//  Explore
//

import Domain
import Foundation

enum ArticleDetailState {
    case idle
    case loading
    case success(article: Article)
}
