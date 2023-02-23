//
// C8yNotificationSubscriptionResult.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yNotificationSubscriptionResult: Codable {

	/// The status of the notification subscription deletion.
	public var result: C8yResult?

	enum CodingKeys: String, CodingKey {
		case result
	}

	public init() {
	}

	/// The status of the notification subscription deletion.
	public enum C8yResult: String, Codable {
		case done = "DONE"
		case scheduled = "SCHEDULED"
	}

}
