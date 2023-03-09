//
// C8yError.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public class C8yError: BadResponseError, Codable {
	
	public required init(from decoder: Decoder) throws {
		super.init()
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.error = try container.decodeIfPresent(String.self, forKey: .error)
		self.message = try container.decodeIfPresent(String.self, forKey: .message)
		self.info = try container.decodeIfPresent(String.self, forKey: .info)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(self.error, forKey: .error)
		try container.encodeIfPresent(self.message, forKey: .message)
		try container.encodeIfPresent(self.info, forKey: .info)
	}

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

	public override init() {
		super.init() 
	}
}
