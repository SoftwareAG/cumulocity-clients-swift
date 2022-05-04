//
// C8yDescRetentionRuleDataType.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The data type(s) to which the rule is applied.
public enum C8yDescRetentionRuleDataType: String, Codable {
	case alarm = "ALARM"
	case audit = "AUDIT"
	case bulkoperation = "BULK_OPERATION"
	case event = "EVENT"
	case measurement = "MEASUREMENT"
	case operation = "OPERATION"
	case all = "*"
}
