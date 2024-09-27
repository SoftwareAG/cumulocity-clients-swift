//
// C8yNewDeviceRequest.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yNewDeviceRequest: Codable {

	/// External ID of the device.
	public var id: String?

	/// ID of the group to which the device will be assigned.
	public var groupId: String?

	/// Type of the device.
	public var type: String?

	/// Tenant who owns the device.
	public var tenantId: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// Status of this new device request.
	public var status: C8yStatus?

	/// Owner of the device.
	public var owner: String?

	/// Date and time when the device was created in the database.
	public var creationTime: String?

	/// When accepting a device request, the security token is verified against the token submitted by the device when requesting credentials.See [Security token policy](https://cumulocity.com/docs/device-management-application/registering-devices/#security-token-policy) for details on configuration.See [Create device credentials](/#operation/postDeviceCredentialsCollectionResource) for details on creating token for device registration.`securityToken` parameter can be added only when submitting `ACCEPTED` status.
	public var securityToken: String?

	enum CodingKeys: String, CodingKey {
		case id
		case groupId
		case type
		case tenantId
		case `self` = "self"
		case status
		case owner
		case creationTime
		case securityToken
	}

	public init() {
	}

	/// Status of this new device request.
	public enum C8yStatus: String, Codable {
		case waitingforconnection = "WAITING_FOR_CONNECTION"
		case pendingacceptance = "PENDING_ACCEPTANCE"
		case accepted = "ACCEPTED"
	}

}
