//
// C8yDeviceCredentials.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yDeviceCredentials: Codable {

	/// The external ID of the device.
	public var id: String?

	/// Password of these device credentials.
	public var password: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Tenant ID for these device credentials.
	public var tenantId: String?

	/// Username of these device credentials.
	public var username: String?

	/// Security token which is required and verified against during device request acceptance.See [Security token policy](https://cumulocity.com/docs/device-management-application/registering-devices/#security-token-policy) for more details on configuration.See [Update specific new device request status](/#operation/putNewDeviceRequestResource) for details on submitting token upon device acceptance.
	public var securityToken: String?

	enum CodingKeys: String, CodingKey {
		case id
		case password
		case `self` = "self"
		case tenantId
		case username
		case securityToken
	}

	public init() {
	}
}
