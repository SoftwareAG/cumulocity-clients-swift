//
// C8ySupportedMeasurements.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8ySupportedMeasurements: Codable {

	/// An array containing all supported measurements of the specified managed object.
	public var c8ySupportedMeasurements: [String]?

	enum CodingKeys: String, CodingKey {
		case c8ySupportedMeasurements = "c8y_SupportedMeasurements"
	}

	public init() {
	}
}
