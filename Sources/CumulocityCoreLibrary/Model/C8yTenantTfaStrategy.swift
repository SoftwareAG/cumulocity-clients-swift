//
// C8yTenantTfaStrategy.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yTenantTfaStrategy: Codable {

	/// Two-factor authentication strategy.
	public var strategy: C8yStrategy?

	enum CodingKeys: String, CodingKey {
		case strategy
	}

	public init(strategy: C8yStrategy) {
		self.strategy = strategy
	}

	/// Two-factor authentication strategy.
	public enum C8yStrategy: String, Codable {
		case sms = "SMS"
		case totp = "TOTP"
	}

}
