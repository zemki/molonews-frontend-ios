//
//  ArticleListIntent.swift
//  ArticleList
//

import Domain
import Foundation

public enum ArticleListIntent {
    case loadArticles(searchString: String = "", filter: OrganizationType = .all)
    case loadMoreArticles(offset: Int, filter: OrganizationType = .all)
    case pullToRefresh
    case onClickArticle(id: Int)
    case onClickOrganization(id: Int)
    case onClickDeletePosting(id: Int)
}
