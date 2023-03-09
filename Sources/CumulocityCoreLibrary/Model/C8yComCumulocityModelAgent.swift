//
// C8yComCumulocityModelAgent.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// An empty fragment stored in the device managed object using the inventory API endpoints. It declares that the device is able to receive operations extended capabilities. This fragment is optional. If not present, the extended capabilities will not be certified.
public struct C8yComCumulocityModelAgent: Codable {

	public init() {
	}
}
