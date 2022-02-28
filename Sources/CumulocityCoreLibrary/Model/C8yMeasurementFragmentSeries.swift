//
// C8yMeasurementFragmentSeries.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yMeasurementFragmentSeries: Codable {

	/// The unit of the measurement.
	public var unit: String?

	/// The name of the measurement.
	public var name: String?

	/// The type of measurement.
	public var type: String?

	enum CodingKeys: String, CodingKey {
		case unit
		case name
		case type
	}

	public init() {
	}
}
