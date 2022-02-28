//
// C8yNotificationApiResource.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yNotificationApiResource: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// Collection of all notification subscriptions.
	public var notificationSubscriptions: C8yNotificationSubscriptions?

	/// Read-only collection of all notification subscriptions for a specific source object. The placeholder {source} must be a unique ID of an object in the inventory.
	public var notificationSubscriptionsBySource: String?

	/// Read-only collection of all notification subscriptions of a particular context and a specific source object.
	public var notificationSubscriptionsBySourceAndContext: String?

	/// Read-only collection of all notification subscriptions of a particular context.
	public var notificationSubscriptionsByContext: String?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case notificationSubscriptions
		case notificationSubscriptionsBySource
		case notificationSubscriptionsBySourceAndContext
		case notificationSubscriptionsByContext
	}

	public init() {
	}

	/// Collection of all notification subscriptions.
	public struct C8yNotificationSubscriptions: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		public var subscriptions: [C8yNotificationSubscription]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case subscriptions
		}
	
		public init() {
		}
	}
}
