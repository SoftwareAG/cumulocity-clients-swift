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

	/// Indicates whether the messages for this subscription are persistent or non-persistent, meaning they can be lost if consumer is not connected.
	public var nonPersistent: Bool?

	enum CodingKeys: String, CodingKey {
		case context
		case fragmentsToCopy
		case id
		case `self` = "self"
		case source
		case subscription
		case subscriptionFilter
		case nonPersistent
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
	
		/// The Notifications are available for Alarms, Alarms with children, Device control, Events, Events with children, Inventory and Measurements for the `mo` context and for Alarms, Events and Inventory for the `tenant` context. Alternatively, the wildcard `*` can be used to match all the permissible APIs within the bound context.
		/// 
		/// > **ⓘ Note** The wildcard `*` cannot be used in conjunction with other values.
		/// > **ⓘ Note** When filtering Events in the `tenant` context it is required to also specify the `typeFilter`.
		public var apis: [String]?
	
		/// Used to match the `type` property of the data. An OData expression must be provided.
		/// 
		/// > **ⓘ Note** The use of a `type` attribute is assumed, for example when using only a string literal `'c8y_Temperature'` it is equivalent to a `type eq 'c8y_Temperature'` OData expression.
		/// > **ⓘ Note** Currently only the `or` operator is allowed in the expression mode. Example usage is `'c8y_Temperature' or 'c8y_Pressure'` which will match all the data with types `c8y_Temperature` or `c8y_Pressure`.
		public var typeFilter: String?
	
		enum CodingKeys: String, CodingKey {
			case apis
			case typeFilter
		}
	
		public init() {
		}
	}
}
