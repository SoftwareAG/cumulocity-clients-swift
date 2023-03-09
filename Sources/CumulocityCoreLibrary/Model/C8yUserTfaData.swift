//
// C8yUserTfaData.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yUserTfaData: Codable {

	/// Latest date and time when the user has used two-factor authentication to log in.
	public var lastTfaRequestTime: String?

	/// Two-factor authentication strategy.
	public var strategy: C8yStrategy?

	/// Indicates whether the user has enabled two-factor authentication or not.
	public var tfaEnabled: Bool?

	/// Indicates whether two-factor authentication is enforced by the tenant admin or not.
	public var tfaEnforced: Bool?

	enum CodingKeys: String, CodingKey {
		case lastTfaRequestTime
		case strategy
		case tfaEnabled
		case tfaEnforced
	}

	public init() {
	}

	/// Two-factor authentication strategy.
	public enum C8yStrategy: String, Codable {
		case sms = "SMS"
		case totp = "TOTP"
	}

}
