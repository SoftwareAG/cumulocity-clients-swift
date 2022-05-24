//
// C8yEventsApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yEventsApiResource: Codable {

	/// Collection of all events
	public var events: C8yEvents?

	/// Read-only collection of all events for a specific source object. The placeholder {source} must be a unique ID of an object in the inventory.
	public var eventsForSource: String?

	/// Read-only collection of all events of a particular type and a specific source object.
	public var eventsForSourceAndType: String?

	/// Read-only collection of all events of a particular type.
	public var eventsForType: String?

	/// Read-only collection of all events containing a particular fragment type.
	public var eventsForFragmentType: String?

	/// Read-only collection of all events for a particular time range.
	public var eventsForTime: String?

	/// Read-only collection of all events for a specific source object in a particular time range.
	public var eventsForSourceAndTime: String?

	/// A URL linking to this resource.
	public var `self`: String?

	enum CodingKeys: String, CodingKey {
		case events
		case eventsForSource
		case eventsForSourceAndType
		case eventsForType
		case eventsForFragmentType
		case eventsForTime
		case eventsForSourceAndTime
		case `self` = "self"
	}

	public init() {
	}

	/// Collection of all events
	public struct C8yEvents: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		public var events: [C8yEvent]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case events
		}
	
		public init() {
		}
	}
}
