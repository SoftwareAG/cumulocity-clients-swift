//
// C8yLoginOptionCollection.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// All available login options of the tenant.
public struct C8yLoginOptionCollection: Codable {

	/// An array containing the available login options.
	public var loginOptions: [C8yLoginOption]?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case loginOptions
		case `self` = "self"
	}

	public init() {
	}
}
