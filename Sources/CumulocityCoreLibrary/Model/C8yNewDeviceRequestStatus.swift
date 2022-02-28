//
// C8yNewDeviceRequestStatus.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Status of this new device request.
public enum C8yNewDeviceRequestStatus: String, Codable {
	case waiting_for_connection = "WAITING_FOR_CONNECTION"
	case pending_acceptance = "PENDING_ACCEPTANCE"
	case accepted = "ACCEPTED"
}
