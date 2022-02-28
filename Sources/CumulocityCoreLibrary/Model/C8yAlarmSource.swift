//
// C8yAlarmSource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The managed object to which the alarm is associated.
public struct C8yAlarmSource: Codable {

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
