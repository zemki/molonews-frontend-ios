//
//  PostArticleUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class PostArticleUseCase: BaseUseCaseExecuter<Int>, UseCaseExecuter {
    @Injected(\.articlesRepository) private var articlesRepository: ArticleRepositoryType?
    
    private let article: PostingArticle
    
    public init(article: PostingArticle) {
        self.article = article
    }
    
    override func execute(with deviceId: String) async throws -> Result<Int, RepositoryError> {
        guard let articlesRepository else {
            throw RepositoryError.diError
        }
        
        return try await articlesRepository.postUserArticle(article)
    }
}
