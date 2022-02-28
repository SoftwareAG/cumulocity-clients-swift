//
// C8yMeasurementApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yMeasurementApiResource: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// Collection of all measurements
	public var measurements: C8yMeasurements?

	/// Read-only collection of all measurements for a specific source object. The placeholder {source} must be a unique ID of an object in the inventory.
	public var measurementsForSource: String?

	/// Read-only collection of all measurements of a particular type and a specific source object.
	public var measurementsForSourceAndType: String?

	/// Read-only collection of all measurements of a particular type.
	public var measurementsForType: String?

	/// Read-only collection of all measurements containing a particular fragment type.
	public var measurementsForValueFragmentType: String?

	/// Read-only collection of all measurements for a particular time range.
	public var measurementsForDate: String?

	/// Read-only collection of all measurements for a specific source object in a particular time range.
	public var measurementsForSourceAndDate: String?

	/// Read-only collection of all measurements for a specific fragment type and a particular time range.
	public var measurementsForDateAndFragmentType: String?

	/// Read-only collection of all measurements for a specific source object, particular fragment type and series, and an event type.
	public var measurementsForSourceAndValueFragmentTypeAndValueFragmentSeries: String?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case measurements
		case measurementsForSource
		case measurementsForSourceAndType
		case measurementsForType
		case measurementsForValueFragmentType
		case measurementsForDate
		case measurementsForSourceAndDate
		case measurementsForDateAndFragmentType
		case measurementsForSourceAndValueFragmentTypeAndValueFragmentSeries
	}

	public init() {
	}

	/// Collection of all measurements
	public struct C8yMeasurements: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		public var measurements: [C8yMeasurement]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case measurements
		}
	
		public init() {
		}
	}
}
