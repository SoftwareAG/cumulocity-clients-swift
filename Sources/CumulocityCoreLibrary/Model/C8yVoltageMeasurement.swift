//
// C8yVoltageMeasurement.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A voltage sensor measures the voltage difference between two points in an electric circuit.
public struct C8yVoltageMeasurement: Codable {

	/// A measurement is a value with a unit.
	public var voltage: C8yMeasurementValue?

	enum CodingKeys: String, CodingKey {
		case voltage
	}

	public init() {
	}
}
