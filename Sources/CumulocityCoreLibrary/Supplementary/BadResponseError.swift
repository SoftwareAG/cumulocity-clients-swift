//
// BadResponseError.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

public class BadResponseError : LocalizedError {

	/// The response object returned by failed REST calls
    public var httpResponse: HTTPURLResponse?

    public var errorDescription: String? {
		return "Request failed with \(String(describing: self.failureReason)) return code."
	}

	public var failureReason: String? {
		if let statusCode = httpResponse?.statusCode {
			return String(describing: statusCode)
		}
		return nil
	}

	public init() {
	}

    public init(with httpResponse: HTTPURLResponse) {
		self.httpResponse = httpResponse
	}
}

public class BadResponseErrorAwareData : BadResponseError {

    public var data: Codable?

    public init(with httpResponse: HTTPURLResponse, data: Codable?) {
        super.init(with: httpResponse)
        self.data = data
    }
}

public extension Subscribers.Completion {

	public func error() throws -> BadResponseError? {
		if case .failure(let failure) = self {
			if let error = failure as? BadResponseError {
				return error
			}
		}
		return nil
	}
}
