//
// C8yVerifyCertificateChain.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yVerifyCertificateChain: Codable {

	/// The result of validating the certificate chain.
	public var successfullyValidated: Bool?

	/// The tenant ID used for validation.
	public var tenantId: String?

	/// The name of the organization which signed the certificate.
	public var issuer: String?

	/// The name of the organization to which the certificate belongs.
	public var subject: String?

	enum CodingKeys: String, CodingKey {
		case successfullyValidated
		case tenantId
		case issuer
		case subject
	}

	public init() {
	}
}
