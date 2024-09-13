//
// C8yTenantFeatureToggleValue.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yTenantFeatureToggleValue: Codable {

	/// Identifier of a tenant this feature toggle value is for.
	public var tenantId: String?

	/// Current value of the feature toggle marking whether the feature is active or not.
	public var active: Bool?

	enum CodingKeys: String, CodingKey {
		case tenantId
		case active
	}

	public init() {
	}
}