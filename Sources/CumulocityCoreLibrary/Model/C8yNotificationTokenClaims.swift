//
// C8yNotificationTokenClaims.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
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

	/// The subscription type. Currently the only supported type is `notification` .Other types may be added in future.
	public var type: C8yType?

	/// If `true`, the token will be securely signed by the Cumulocity IoT platform.
	public var signed: Bool?

	/// If `true`, indicates that the token is used to create a shared consumer on the subscription.
	public var shared: Bool?

	/// If `true`, indicates that the created token refers to the non-persistent variant of the named subscription.
	public var nonPersistent: Bool?

	enum CodingKeys: String, CodingKey {
		case expiresInMinutes
		case subscriber
		case subscription
		case type
		case signed
		case shared
		case nonPersistent
	}

	public init(subscriber: String, subscription: String) {
		self.subscriber = subscriber
		self.subscription = subscription
	}

	/// The subscription type. Currently the only supported type is `notification` .Other types may be added in future.
	public enum C8yType: String, Codable {
		case notification = "notification"
	}

}
