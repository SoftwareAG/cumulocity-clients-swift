//
// C8yNotificationSubscription.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yNotificationSubscription: Codable {

	/// The Context within which the subscription is to be processed.
	/// > **&#9432; Info:** If the value is `mo`, then `source` must also be provided in the request body.
	/// 
	public var context: C8ySubscriptionContext?

	/// Transforms the data to *only* include specified custom fragments. Each custom fragment is identified by a unique name. If nothing is specified here, the data is forwarded as-is.
	public var fragmentsToCopy: [String]?

	/// Unique identifier of the subscription.
	public var id: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The managed object to which the subscription is associated.
	public var source: C8yNotificationSubscriptionSource?

	/// The subscription name. Each subscription is identified by a unique name within a specific context.
	public var subscription: String?

	/// Apply applicable filters to the subscription.
	public var subscriptionFilter: C8yNotificationSubscriptionFilter?

	enum CodingKeys: String, CodingKey {
		case context
		case fragmentsToCopy
		case id
		case `self` = "self"
		case source
		case subscription
		case subscriptionFilter
	}

	public init() {
	}
}
