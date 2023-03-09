//
// C8yBinary.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yBinary: Codable {

	/// Fragment to identify this managed object as a file.
	public var c8yIsBinary: C8yIsBinary?

	/// Media type of the file.
	public var contentType: String?

	/// Unique identifier of the object.
	public var id: String?

	/// Date and time of the file's last update.
	public var lastUpdated: String?

	/// Size of the file in bytes.
	public var length: Int?

	/// Name of the managed object. It is set from the `object` contained in the payload.
	public var name: String?

	/// Username of the owner of the file.
	public var owner: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Type of the managed object. It is set from the `object` contained in the payload.
	public var type: String?

	enum CodingKeys: String, CodingKey {
		case c8yIsBinary = "c8y_IsBinary"
		case contentType
		case id
		case lastUpdated
		case length
		case name
		case owner
		case `self` = "self"
		case type
	}

	public init() {
	}

	/// Fragment to identify this managed object as a file.
	public struct C8yIsBinary: Codable {
	
		public init() {
		}
	}
}
