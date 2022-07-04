//
// C8yNotificationTokenClaims.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yNotificationTokenClaims: Codable {

	/// The token expiration duration.
	public var expiresInMinutes: Int?

	/// The subscriber name which the client wishes to be identified with.
	public var subscriber: String?

	/// The subscription name. This value must match the same that was used when the subscription was created.
	public var subscription: String?

	enum CodingKeys: String, CodingKey {
		case expiresInMinutes
		case subscriber
		case subscription
	}

	public init(subscriber: String, subscription: String) {
		self.subscriber = subscriber
		self.subscription = subscription
	}
}
