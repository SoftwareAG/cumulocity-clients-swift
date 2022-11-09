//
// C8yCurrentUserTotpSecret.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yCurrentUserTotpSecret: Codable {

	/// Secret used by two-factor authentication applications to generate the TFA codes.
	public var rawSecret: String?

	/// URL used to set the two-factor authentication secret for the TFA application.
	public var secretQrUrl: String?

	enum CodingKeys: String, CodingKey {
		case rawSecret
		case secretQrUrl
	}

	public init() {
	}
}
