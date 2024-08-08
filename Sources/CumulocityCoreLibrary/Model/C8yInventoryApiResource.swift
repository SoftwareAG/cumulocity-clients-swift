//
// C8yInventoryApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yInventoryApiResource: Codable {

	/// Read-only collection of all managed objects with a particular fragment type or capability (placeholder {fragmentType}).
	public var managedObjectsForFragmentType: String?

	/// Read-only collection of all managed objects of a particular type (placeholder {type}).
	public var managedObjectsForType: String?

	/// Read-only collection of managed objects fetched for a given list of ids, for example, ���ids=41,43,68���.
	public var managedObjectsForListOfIds: String?

	/// Collection of all managed objects
	public var managedObjects: C8yManagedObjects?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case managedObjectsForFragmentType
		case managedObjectsForType
		case managedObjectsForListOfIds
		case managedObjects
		case `self` = "self"
	}

	public init() {
	}

	/// Collection of all managed objects
	public struct C8yManagedObjects: Codable {
	
		/// An array containing the referenced managed objects.
		public var references: [C8yManagedObject]?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case references
			case `self` = "self"
		}
	
		public init() {
		}
	}
}
