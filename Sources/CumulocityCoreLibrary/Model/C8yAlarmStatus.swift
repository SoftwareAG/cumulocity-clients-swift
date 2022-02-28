//
// C8yAlarmStatus.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The status of the alarm. If not specified, a new alarm will be created as ACTIVE.
public enum C8yAlarmStatus: String, Codable {
	case active = "ACTIVE"
	case acknowledged = "ACKNOWLEDGED"
	case cleared = "CLEARED"
}
