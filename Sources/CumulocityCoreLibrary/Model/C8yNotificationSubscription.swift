//
// C8yNotificationSubscription.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yNotificationSubscription: Codable {

	/// The context within which the subscription is to be processed.
	/// 
	/// > **ⓘ Note** If the value is `mo`, then `source` must also be provided in the request body.
	public var context: C8yContext?

	/// Transforms the data to *only* include specified custom fragments. Each custom fragment is identified by a unique name. If nothing is specified here, the data is forwarded as-is.
	public var fragmentsToCopy: [String]?

	/// Unique identifier of the subscription.
	public var id: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The managed object to which the subscription is associated.
	public var source: C8ySource?

	/// The subscription name. Each subscription is identified by a unique name within a specific context.
	public var subscription: String?

	/// Applicable filters to the subscription.
	public var subscriptionFilter: C8ySubscriptionFilter?

	enum CodingKeys: String, CodingKey {
		case context
		case fragmentsToCopy
		case id
		case `self` = "self"
		case source
		case subscription
		case subscriptionFilter
	}

	public init(context: C8yContext, subscription: String) {
		self.context = context
		self.subscription = subscription
	}

	/// The context within which the subscription is to be processed.
	/// 
	/// > **ⓘ Note** If the value is `mo`, then `source` must also be provided in the request body.
	public enum C8yContext: String, Codable {
		case mo = "mo"
		case tenant = "tenant"
	}


	/// The managed object to which the subscription is associated.
	public struct C8ySource: Codable {
	
		/// Unique identifier of the object.
		public var id: String?
	
		/// Human-readable name that is used for representing the object in user interfaces.
		public var name: String?
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		enum CodingKeys: String, CodingKey {
			case id
			case name
			case `self` = "self"
		}
	
		public init() {
		}
	}

	/// Applicable filters to the subscription.
	public struct C8ySubscriptionFilter: Codable {
	
		/// The Notifications are available for Alarms, Alarms with children, Device control, Events, Events with children, Inventory and Measurements for the `mo` context and for Alarms and Inventory for the `tenant` context. Alternatively, the wildcard `*` can be used to match all the permissible APIs within the bound context.
		/// 
		/// > **ⓘ Note** the wildcard `*` cannot be used in conjunction with other values.
		public var apis: [String]?
	
		/// The data needs to have the specified value in its `type` property to meet the filter criteria.
		public var typeFilter: String?
	
		enum CodingKeys: String, CodingKey {
			case apis
			case typeFilter
		}
	
		public init() {
		}
	}
}
