//
// C8yLatestMeasurementValue.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The read only fragment which contains the latest measurements series values reported by the device.
/// 
/// > **������ Feature Preview:** The feature is part of the Latest Measurement feature which is still under public feature preview.
public struct C8yLatestMeasurementValue: Codable {

	/// The unit of the measurement series.
	public var unit: String?

	/// The time of the measurement series.
	public var time: String?

	/// The value of the individual measurement.
	public var value: Double?

	enum CodingKeys: String, CodingKey {
		case unit
		case time
		case value
	}

	public init(value: Double) {
		self.value = value
	}
}
