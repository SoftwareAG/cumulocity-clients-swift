//
// C8yFeatureToggle.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yFeatureToggle: Codable {

	/// A unique key of the feature toggle.
	public var key: String?

	/// Current phase of feature toggle rollout.
	public var phase: C8yPhase?

	/// Current value of the feature toggle marking whether the feature is active or not.
	public var active: Bool?

	/// The source of the feature toggle value - either it's feature toggle definition provided default, or per tenant provided override.
	public var strategy: C8yStrategy?

	enum CodingKeys: String, CodingKey {
		case key
		case phase
		case active
		case strategy
	}

	public init() {
	}

	/// Current phase of feature toggle rollout.
	public enum C8yPhase: String, Codable {
		case indevelopment = "IN_DEVELOPMENT"
		case privatepreview = "PRIVATE_PREVIEW"
		case publicpreview = "PUBLIC_PREVIEW"
		case generallyavailable = "GENERALLY_AVAILABLE"
	}

	/// The source of the feature toggle value - either it's feature toggle definition provided default, or per tenant provided override.
	public enum C8yStrategy: String, Codable {
		case default = "DEFAULT"
		case tenant = "TENANT"
	}


}
