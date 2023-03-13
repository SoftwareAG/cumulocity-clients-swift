//
// C8yEventBinary.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yEventBinary: Codable {

	/// Name of the attachment. If it is not provided in the request, it will be set as the event ID.
	public var name: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Unique identifier of the event.
	public var source: String?

	/// Media type of the attachment.
	public var type: String?

	enum CodingKeys: String, CodingKey {
		case name
		case `self` = "self"
		case source
		case type
	}

	public init() {
	}
}
