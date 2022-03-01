//
// C8yObjectChildDevices.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A collection of references to child devices.
public struct C8yObjectChildDevices: Codable {

	/// Link to this resource's child devices.
	public var `self`: String?

	/// An array with the references to child devices.
	public var references: [C8yManagedObjectReferenceTuple]?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case references
	}

	public init() {
	}
}
