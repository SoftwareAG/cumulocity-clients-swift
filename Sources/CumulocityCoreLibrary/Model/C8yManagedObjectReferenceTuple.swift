//
// C8yManagedObjectReferenceTuple.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yManagedObjectReferenceTuple: Codable {

	/// Details of the referenced managed object.
	public var managedObject: C8yManagedObject?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case managedObject
		case `self` = "self"
	}

	public init() {
	}

	/// Details of the referenced managed object.
	public struct C8yManagedObject: Codable {
	
		/// Unique identifier of the object.
		public var id: String?
	
		/// Human-readable name that is used for representing the object in user interfaces.
		public var name: String?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case id
			case name
			case `self` = "self"
		}
	
		public init() {
		}
	}
}
