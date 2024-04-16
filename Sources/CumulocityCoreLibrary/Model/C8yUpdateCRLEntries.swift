//
// C8yUpdateCRLEntries.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A list of serial numbers.
public struct C8yUpdateCRLEntries: Codable {

	public var crls: [C8yCRLEntry]?

	enum CodingKeys: String, CodingKey {
		case crls
	}

	public init() {
	}
}
