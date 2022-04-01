//
// C8yMotionMeasurement.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yMotionMeasurement: Codable {

	/// Boolean value indicating if motion has been detected (non-zero value) or not (zero value).
	public var motionDetected: C8yMotionDetected?

	public var speed: C8yMeasurementValue?

	enum CodingKeys: String, CodingKey {
		case motionDetected
		case speed
	}

	public init() {
	}

	/// Boolean value indicating if motion has been detected (non-zero value) or not (zero value).
	public struct C8yMotionDetected: Codable {
	
		public var value: Double?
	
		public var type: String?
	
		enum CodingKeys: String, CodingKey {
			case value
			case type
		}
	
		public init() {
		}
	}
}
