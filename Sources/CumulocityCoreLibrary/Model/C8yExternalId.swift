//
// C8yExternalId.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yExternalId: Codable {

	/// The identifier used in the external system that Cumulocity IoT interfaces with.
	public var externalId: String?

	/// The managed object linked to the external ID.
	public var managedObject: C8yManagedObject?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The type of the external identifier.
	public var type: String?

	enum CodingKeys: String, CodingKey {
		case externalId
		case managedObject
		case `self` = "self"
		case type
	}

	public init(externalId: String, type: String) {
		self.externalId = externalId
		self.type = type
	}

	/// The managed object linked to the external ID.
	public struct C8yManagedObject: Codable {
	
		/// Unique identifier of the object.
		public var id: String?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case id
			case `self` = "self"
		}
	
		public init() {
		}
	}
}
