//
// C8yMotionSensor.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// A motion sensor detects motion. Simple motion sensors may just detect if there is motion or not, based on some predefined threshold. More complicated motion sensors (such as police speed radars) can measure the actual speed of the motion. It is assumed in the model that only the speed towards or away from the sensor is measured. The unit for this sensor type are kilometres per hour (km/h). In a managed object, a motion sensor is modeled as a simple empty fragment.
public struct C8yMotionSensor: Codable {

	public init() {
	}
}
