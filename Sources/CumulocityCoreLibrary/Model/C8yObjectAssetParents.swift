//
// C8yObjectAssetParents.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A collection of references to asset parent objects.
public struct C8yObjectAssetParents: Codable {

	/// An array with the references to asset parent objects.
	public var references: [C8yManagedObjectReferenceTuple]?

	/// Link to this resource's asset parent objects.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case references
		case `self` = "self"
	}

	public init() {
	}
}
