//
// C8yHumidityMeasurement.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// There are three main measurements of humidity; absolute, relative and specific.
/// 
/// Absolute humidity is the water content of air. Relative humidity, expressed as a percentage, measures the current absolute humidity relative to the maximum for that temperature. Specific humidity is a ratio of the water vapour content of the mixture to the total air content on a mass basis.
/// 
public struct C8yHumidityMeasurement: Codable {

	public var h: C8yMeasurementValue?

	enum CodingKeys: String, CodingKey {
		case h
	}

	public init() {
	}
}
