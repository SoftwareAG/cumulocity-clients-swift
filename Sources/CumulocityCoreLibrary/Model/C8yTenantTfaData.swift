//
// C8yTenantTfaData.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yTenantTfaData: Codable {

	/// Indicates whether two-factor authentication is enabled on system level or not.
	public var enabledOnSystemLevel: Bool?

	/// Indicates whether two-factor authentication is enabled on tenant level or not.
	public var enabledOnTenantLevel: Bool?

	/// Indicates whether two-factor authentication is enforced on system level or not.
	public var enforcedOnSystemLevel: Bool?

	/// Two-factor authentication is enforced for the specified group.
	public var enforcedUsersGroup: String?

	/// Two-factor authentication strategy.
	public var strategy: C8yStrategy?

	/// Indicates whether two-factor authentication is enforced on tenant level or not.
	public var totpEnforcedOnTenantLevel: Bool?

	enum CodingKeys: String, CodingKey {
		case enabledOnSystemLevel
		case enabledOnTenantLevel
		case enforcedOnSystemLevel
		case enforcedUsersGroup
		case strategy
		case totpEnforcedOnTenantLevel
	}

	public init() {
	}

	/// Two-factor authentication strategy.
	public enum C8yStrategy: String, Codable {
		case sms = "SMS"
		case totp = "TOTP"
	}

}
