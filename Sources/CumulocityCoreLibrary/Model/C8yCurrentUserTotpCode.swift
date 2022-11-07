//
// C8yCurrentUserTotpCode.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yCurrentUserTotpCode: Codable {

	/// Two-factor authentication code entered by the user to log in to the platform.
	public var code: String?

	enum CodingKeys: String, CodingKey {
		case code
	}

	public init(code: String) {
		self.code = code
	}
}
