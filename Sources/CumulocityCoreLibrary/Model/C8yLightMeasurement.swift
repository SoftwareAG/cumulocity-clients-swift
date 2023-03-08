//
// C8yLightMeasurement.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Light is measured with two main alternative sets of units.
/// 
/// Radiometry consists of measurements of light power at all wavelengths, while photometry measures light with wavelength weighted with respect to a standardized model of human brightness perception. Photometry is useful, for example, to quantify illumination (lighting) intended for human use.
public struct C8yLightMeasurement: Codable {

	/// A measurement is a value with a unit.
	public var e: C8yMeasurementValue?

	enum CodingKeys: String, CodingKey {
		case e
	}

	public init() {
	}
}
