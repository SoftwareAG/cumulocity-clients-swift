//
// C8ySupportedSeries.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8ySupportedSeries: Codable {

	/// An array containing all supported measurement series of the specified device.
	public var c8ySupportedSeries: [String]?

	enum CodingKeys: String, CodingKey {
		case c8ySupportedSeries = "c8y_SupportedSeries"
	}

	public init() {
	}
}
