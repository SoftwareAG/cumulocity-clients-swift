//
// C8yDescC8yMeasurementValue.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yDescC8yMeasurementValue: Codable {

	public var value: Int?

	public var unit: String?

	enum CodingKeys: String, CodingKey {
		case value
		case unit
	}

	public init() {
	}
}
