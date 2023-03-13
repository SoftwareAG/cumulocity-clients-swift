//
// C8yCurrentUserTotpSecretActivity.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yCurrentUserTotpSecretActivity: Codable {

	/// Indicates whether the two-factor authentication secret is active.
	public var isActive: Bool?

	enum CodingKeys: String, CodingKey {
		case isActive
	}

	public init(isActive: Bool) {
		self.isActive = isActive
	}
}
