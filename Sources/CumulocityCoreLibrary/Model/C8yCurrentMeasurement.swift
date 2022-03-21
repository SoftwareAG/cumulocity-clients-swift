//
// C8yCurrentMeasurement.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yCurrentMeasurement: Codable {

	public var current: C8yMeasurementValue?

	enum CodingKeys: String, CodingKey {
		case current
	}

	public init() {
	}
}
