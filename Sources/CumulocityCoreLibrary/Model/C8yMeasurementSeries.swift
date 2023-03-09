//
// C8yMeasurementSeries.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yMeasurementSeries: Codable {

	/// Each property contained here is a date taken from the measurement and it contains an array of objects specifying `min` and `max` pair of values. Each pair corresponds to a single series object in the `series` array. If there is no aggregation used, `min` is equal to `max` in every pair.
	public var values: C8yValues?

	/// An array containing the type of series and units.
	public var series: [C8yMeasurementFragmentSeries]?

	/// If there were more than 5000 values, the final result was truncated.
	public var truncated: Bool?

	enum CodingKeys: String, CodingKey {
		case values
		case series
		case truncated
	}

	public init() {
	}

	/// Each property contained here is a date taken from the measurement and it contains an array of objects specifying `min` and `max` pair of values. Each pair corresponds to a single series object in the `series` array. If there is no aggregation used, `min` is equal to `max` in every pair.
	public struct C8yValues: Codable {
	
		public init() {
		}
	}
}
