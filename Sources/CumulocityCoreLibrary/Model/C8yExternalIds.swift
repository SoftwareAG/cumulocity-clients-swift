//
// C8yExternalIds.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yExternalIds: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// An array containing the details of all external IDs (if any).
	public var externalIds: [C8yExternalId]?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case externalIds
	}

	public init() {
	}
}
