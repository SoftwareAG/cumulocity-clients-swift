//
// C8yActiveAlarmsStatus.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The number of currently active and acknowledged alarms is stored in this fragment.
public struct C8yActiveAlarmsStatus: Codable {

	public var critical: Int?

	public var major: Int?

	public var minor: Int?

	public var warning: Int?

	enum CodingKeys: String, CodingKey {
		case critical
		case major
		case minor
		case warning
	}

	public init() {
	}
}
