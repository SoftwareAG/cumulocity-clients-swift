//
// C8yError.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yError: Codable {

	/// The type of error returned.
	public var error: String?

	/// A human-readable message providing more details about the error.
	public var message: String?

	/// A URI reference [[RFC3986](https://tools.ietf.org/html/rfc3986)] that identifies the error code reported.
	public var info: String?

	enum CodingKeys: String, CodingKey {
		case error
		case message
		case info
	}

	public init() {
	}
}
