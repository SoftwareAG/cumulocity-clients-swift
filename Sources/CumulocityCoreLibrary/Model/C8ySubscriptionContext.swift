//
// C8ySubscriptionContext.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The Context within which the subscription is to be processed.
/// > **&#9432; Info:** If the value is `mo`, then `source` must also be provided in the request body.
/// 
public enum C8ySubscriptionContext: String, Codable {
	case mo = "mo"
	case tenant = "tenant"
}
