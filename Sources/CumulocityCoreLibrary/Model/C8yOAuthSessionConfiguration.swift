//
// C8yOAuthSessionConfiguration.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The session configuration properties are only available for OAI-Secure. See [Platform administration > Authentication > Basic settings > OAI Secure session configuration ](https://cumulocity.com/docs/authentication/basic-settings/#oai-secure-session-configuration) in the Cumulocity IoT user documentation.
public struct C8yOAuthSessionConfiguration: Codable {

	/// Maximum session duration (in milliseconds) during which a user does not have to login again.
	public var absoluteTimeoutMillis: Int?

	/// Maximum number of parallel sessions for one user.
	public var maximumNumberOfParallelSessions: Int?

	/// Amount of time before a token expires (in milliseconds) during which the token may be renewed.
	public var renewalTimeoutMillis: Int?

	/// Switch to turn additional user agent verification on or off during the session.
	public var userAgentValidationRequired: Bool?

	enum CodingKeys: String, CodingKey {
		case absoluteTimeoutMillis
		case maximumNumberOfParallelSessions
		case renewalTimeoutMillis
		case userAgentValidationRequired
	}

	public init() {
	}
}
