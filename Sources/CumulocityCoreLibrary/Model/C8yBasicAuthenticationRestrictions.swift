//
// C8yBasicAuthenticationRestrictions.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// For basic authentication case only.
public struct C8yBasicAuthenticationRestrictions: Codable {

	/// List of types of clients which are not allowed to use basic authentication. Currently the only supported option is WEB_BROWSERS.
	public var forbiddenClients: [String]?

	/// List of user agents, passed in `User-Agent` HTTP header, which are blocked if basic authentication is used.
	public var forbiddenUserAgents: [String]?

	/// List of user agents, passed in `User-Agent` HTTP header, which are allowed to use basic authentication.
	public var trustedUserAgents: [String]?

	enum CodingKeys: String, CodingKey {
		case forbiddenClients
		case forbiddenUserAgents
		case trustedUserAgents
	}

	public init() {
	}
}
