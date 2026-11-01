//
//  BaseUseCaseExecuter.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class BaseUseCaseExecuter<T> {
    typealias DeviceId = String
    typealias Areas = String

    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    public func execute() -> AnyPublisher<UseCaseState<T>, Never> {
        guard let accountRepository else {
            return Just(.error(.diError))
                .eraseToAnyPublisher()
        }

        if let _ = self as? any UseCaseObserver {
            return observeExecution(accountRepository)
        } else {
            return resultExecution(accountRepository)
        }
    }

    private func observeExecution(_ accountRepository: AccountRepositoryType) -> AnyPublisher<UseCaseState<T>, Never> {
        Future<String, Never> { promise in
            Task {
                let deviceId = (try? await accountRepository.fetchDeviceId().get()) ?? ""
                promise(.success(deviceId))
            }
        }
        .flatMap { deviceId in
            self.observe(with: deviceId).map { observationValue in
                .success(observationValue)
            }
        }
        .eraseToAnyPublisher()
    }

    private func resultExecution(_ accountRepository: AccountRepositoryType) -> AnyPublisher<UseCaseState<T>, Never> {
        var task: Task<Void, Never>?

        return Future<UseCaseState<T>, Never> { promise in
            task = Task {
                let deviceId = (try? await accountRepository.fetchDeviceId().get()) ?? ""
                let result = try? await self.execute(with: deviceId)

                if task?.isCancelled ?? false {
                    return
                }

                switch result {
                case let .success(data):
                    promise(.success(.success(data)))
                case let .failure(error):
                    print("[ERROR] in use case result execution", error.localizedDescription)
                    promise(.success(.error(error.toUseCaseError())))
                case .none:
                    print("[ERROR] in use case result execution, no result")
                    promise(.success(.error(.resultExecutionError)))
                }
            }
        }
        .handleEvents(receiveCancel: {
            task?.cancel()
        })
        .prepend(.isLoading)
        .eraseToAnyPublisher()
    }

    func execute(with deviceId: String) async throws -> Result<T, RepositoryError> {
        fatalError("Child classes must override this method")
    }

    func observe(with deviceId: String) -> AnyPublisher<T, Never> {
        fatalError("Child classes must override this method")
    }
}
