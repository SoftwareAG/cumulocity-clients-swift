//
// Errors.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

public enum Errors: Error {
	/// Thrown when the HTTP status code did not match any response declarations in OpenAPI.
	case undescribedError(response: HTTPURLResponse)
	/// Thrown when the resource is finished but the HTTP statuc code does not match a successful operation.
	case badResponseError(response: HTTPURLResponse, reason: Codable)

	public func response() -> HTTPURLResponse {
		switch self {
		case .undescribedError(let response):
			return response
		case .badResponseError(let response, _):
			return response
		}
	}

	public func statusCode() -> Int {
    	return response().statusCode
	}

	public func reason() -> Codable? {
		switch self {
		case .undescribedError(_):
			return nil
		case .badResponseError(_, let reason):
			return reason
		}
	}
}

public extension Subscribers.Completion {

	public func error() throws -> Errors? {
		if case .failure(let failure) = self {
			if let error = failure as? Errors {
				return error
 			}
		}
		return nil
	}
}
