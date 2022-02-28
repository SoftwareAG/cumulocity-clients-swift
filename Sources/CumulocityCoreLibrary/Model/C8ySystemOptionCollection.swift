//
// C8ySystemOptionCollection.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// All available system options of the tenant.
public struct C8ySystemOptionCollection: Codable {

	/// An array containing the predefined system options.
	public var options: [C8ySystemOption]?

	enum CodingKeys: String, CodingKey {
		case options
	}

	public init() {
	}
}
