//
// C8yMoistureMeasurement.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// There are three main measurements of moisture; absolute, relative and specific.
/// 
/// Absolute moisture is the absolute water content of a substance. Relative moisture, expressed as a percentage, measures the current absolute moisture relative to the maximum for that temperature. Specific humidity is a ratio of the water vapour content of the mixture to the total substance content on a mass basis.
public struct C8yMoistureMeasurement: Codable {

	/// A measurement is a value with a unit.
	public var moisture: C8yMeasurementValue?

	enum CodingKeys: String, CodingKey {
		case moisture
	}

	public init() {
	}
}
