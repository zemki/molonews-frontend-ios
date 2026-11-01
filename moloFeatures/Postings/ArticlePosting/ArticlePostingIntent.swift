//
//  ArticlePostingIntent.swift
//  Postings
//

import Foundation

enum ArticlePostingIntent {
    case willAppear
    case onClickToDetails(title: String, description: String)
    case onClickToPreview
    case onClickPrevious
    case onImageSelected(imageData: Data, filename: String)
    case onImageSourceSet(name: String)
    case storeArticleData(link: String, tags: Set<Int>)
    case onClickSubmit(asDraft: Bool = false)
    case onClose
}
