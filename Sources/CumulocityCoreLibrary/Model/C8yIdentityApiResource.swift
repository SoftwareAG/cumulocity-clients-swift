//
// C8yIdentityApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yIdentityApiResource: Codable {

	/// Single external ID, represented by the type and the value of the external ID.
	public var externalId: String?

	/// Represents a collection of external IDs for a specified global ID.
	public var externalIdsOfGlobalId: String?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case externalId
		case externalIdsOfGlobalId
		case `self` = "self"
	}

	public init() {
	}
}
