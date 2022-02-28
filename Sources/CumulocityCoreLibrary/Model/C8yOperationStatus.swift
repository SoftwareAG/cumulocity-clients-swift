//
// C8yOperationStatus.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The status of the operation.
public enum C8yOperationStatus: String, Codable {
	case successful = "SUCCESSFUL"
	case failed = "FAILED"
	case executing = "EXECUTING"
	case pending = "PENDING"
}
