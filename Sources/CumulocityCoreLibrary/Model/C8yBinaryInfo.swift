//
// C8yBinaryInfo.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Contains information about the file.
public struct C8yBinaryInfo: Codable {

	/// Name of the binary object.
	public var name: String?

	/// Media type of the file.
	public var type: String?

	enum CodingKeys: String, CodingKey {
		case name
		case type
	}

	public init() {
	}
}
