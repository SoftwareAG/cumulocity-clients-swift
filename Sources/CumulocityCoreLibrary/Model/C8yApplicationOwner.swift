//
// C8yApplicationOwner.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Reference to the tenant owning this application.
public struct C8yApplicationOwner: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	public var tenant: C8yTenant?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case tenant
	}

	public init() {
	}

	public struct C8yTenant: Codable {
	
		/// The tenant ID.
		public var id: String?
	
		enum CodingKeys: String, CodingKey {
			case id
		}
	
		public init() {
		}
	}
}
