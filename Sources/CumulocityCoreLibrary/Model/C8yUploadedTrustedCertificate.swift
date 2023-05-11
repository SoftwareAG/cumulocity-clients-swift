//
// C8yUploadedTrustedCertificate.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yUploadedTrustedCertificate: Codable {

	/// Indicates whether the automatic device registration is enabled or not.
	public var autoRegistrationEnabled: Bool?

	/// Trusted certificate in PEM format.
	public var certInPemFormat: String?

	/// Name of the certificate.
	public var name: String?

	/// Indicates if the certificate is active and can be used by the device to establish a connection to the Cumulocity IoT platform.
	public var status: C8yStatus?

	enum CodingKeys: String, CodingKey {
		case autoRegistrationEnabled
		case certInPemFormat
		case name
		case status
	}

	public init(certInPemFormat: String, status: C8yStatus) {
		self.certInPemFormat = certInPemFormat
		self.status = status
	}

	/// Indicates if the certificate is active and can be used by the device to establish a connection to the Cumulocity IoT platform.
	public enum C8yStatus: String, Codable {
		case enabled = "ENABLED"
		case disabled = "DISABLED"
	}

}
