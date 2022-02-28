//
// C8yNotificationSubscriptionFilter.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Apply applicable filters to the subscription.
public struct C8yNotificationSubscriptionFilter: Codable {

	/// The data needs to have the specified value in its `type` property to meet the filter criteria.
	public var typeFilter: String?

	/// The Notifications are available for Alarms, Device control, Events, Inventory and Measurements for the `mo` context and for Alarms and Inventory for the `tenant` context. Alternatively, the wildcard `*` can be used to match all the permissible APIs within the bound context.
	/// The allowed values are:
	/// 
	/// * `measurements`
	/// * `alarms`
	/// * `events`
	/// * `managedobjects`
	/// * `operations`
	/// * `*`
	/// 
	/// > **&#9432; Info:** the wildcard `*` cannot be used in conjunction with other values.
	/// 
	public var api: [String]?

	enum CodingKeys: String, CodingKey {
		case typeFilter
		case api
	}

	public init() {
	}
}
