//
// C8yCRLEntry.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yCRLEntry: Codable {

	/// Revoked certificate serial number in hexadecimal.
	public var serialNumberInHex: String?

	/// Date and time when the certificate is revoked.
	public var revocationDate: String?

	enum CodingKeys: String, CodingKey {
		case serialNumberInHex
		case revocationDate
	}

	public init(serialNumberInHex: String) {
		self.serialNumberInHex = serialNumberInHex
	}
}
