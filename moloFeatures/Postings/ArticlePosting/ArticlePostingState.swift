//
//  ArticlePostingState.swift
//  Postings
//

import Domain
import Foundation

enum ArticlePostingState {
    case idle
    case loading
    case firstStep(article: PostingArticle)
    case secondStep(article: PostingArticle)
    case previewStep(article: PostingArticle)
}
