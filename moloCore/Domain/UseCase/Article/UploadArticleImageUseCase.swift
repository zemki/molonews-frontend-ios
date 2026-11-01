//
//  UploadArticleImageUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class UploadArticleImageUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.articlesRepository) private var articlesRepository: ArticleRepositoryType?

    private let articleId: Int
    private let file: Data
    private let filename: String
    private let source: String

    public init(articleId: Int, file: Data, filename: String, source: String) {
        self.articleId = articleId
        self.file = file
        self.filename = filename
        self.source = source
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let articlesRepository else {
            throw RepositoryError.diError
        }

        return try await articlesRepository.upload(image: file, filename: filename, for: articleId, from: source)
    }
}
