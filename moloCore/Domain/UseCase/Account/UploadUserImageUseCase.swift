//
//  UploadUserImageUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class UploadUserImageUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?
    
    private let file: Data
    private let filename: String
    private let source: String
    
    public init(file: Data, filename: String, source: String) {
        self.file = file
        self.filename = filename
        self.source = source
    }
    
    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }
        
        return try await accountRepository.upload(image: file, filename: filename, from: source)
    }
}
