//
// C8yThreePhaseEnergyMeasurement.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Measurement of the three phase energy meter.
public struct C8yThreePhaseEnergyMeasurement: Codable {

	public var additionalProperties: [String: C8yMeasurementValue] = [:]
	
	public subscript(key: String) -> C8yMeasurementValue? {
	        get {
	            return additionalProperties[key]
	        }
	        set(newValue) {
	            additionalProperties[key] = newValue
	        }
	    }

	enum CodingKeys: String, CodingKey {
		case additionalProperties
	}

	public init() {
	}
}
