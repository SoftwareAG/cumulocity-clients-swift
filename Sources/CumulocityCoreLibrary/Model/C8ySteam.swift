//
// C8ySteam.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A type of measurement fragment.
public struct C8ySteam: Codable {

	public var temperature: C8yTemperature?

	enum CodingKeys: String, CodingKey {
		case temperature = "Temperature"
	}

	public init() {
	}

	public struct C8yTemperature: Codable {
	
		/// The unit of the measurement.
		public var unit: String?
	
		/// The value of the individual measurement.
		public var value: Double?
	
		enum CodingKeys: String, CodingKey {
			case unit
			case value
		}
	
		public init(value: Double) {
			self.value = value
		}
	}
}
