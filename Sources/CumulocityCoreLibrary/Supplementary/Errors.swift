//
// Errors.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

public enum Errors: Error {
	/// Thrown when the HTTP status code did not match any response declarations in OpenAPI.
	case undescribedError(statusCode: Int, response: HTTPURLResponse)
	/// Thrown when the resource is finished but the HTTP statuc code does not match a successful operation.
    case badResponseError(statusCode: Int, reason: Codable)
}

public extension Subscribers.Completion {

    func error() throws -> (statusCode: Int, reason: Codable?) {
        if case .failure(let failure) = self {
            if let error = failure as? Errors {
                if case Errors.undescribedError(let statusCode, _) = error {
                    return (statusCode: statusCode, reason: nil)
                }
                if case Errors.badResponseError(let statusCode, let reason) = error {
                    return (statusCode: statusCode, reason: reason)
                }
            }
        }
        throw FinishedCompletionError.error
    }

    private enum FinishedCompletionError: Error { case error }
}
