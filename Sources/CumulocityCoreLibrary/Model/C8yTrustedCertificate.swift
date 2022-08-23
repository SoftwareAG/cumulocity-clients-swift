//
// C8yTrustedCertificate.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yTrustedCertificate: Codable {

	/// Algorithm used to decode/encode the certificate.
	public var algorithmName: String?

	/// Indicates whether the automatic device registration is enabled or not.
	public var autoRegistrationEnabled: Bool?

	/// Trusted certificate in PEM format.
	public var certInPemFormat: String?

	/// Unique identifier of the trusted certificate.
	public var fingerprint: String?

	/// The name of the organization which signed the certificate.
	public var issuer: String?

	/// Name of the certificate.
	public var name: String?

	/// The end date and time of the certificate's validity.
	public var notAfter: String?

	/// The start date and time of the certificate's validity.
	public var notBefore: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The certificate's serial number.
	public var serialNumber: String?

	/// Indicates if the certificate is active and can be used by the device to establish a connection to the Cumulocity IoT platform.
	public var status: C8yStatus?

	/// Name of the organization to which the certificate belongs.
	public var subject: String?

	/// Version of the X.509 certificate standard.
	public var version: Int?

	enum CodingKeys: String, CodingKey {
		case algorithmName
		case autoRegistrationEnabled
		case certInPemFormat
		case fingerprint
		case issuer
		case name
		case notAfter
		case notBefore
		case `self` = "self"
		case serialNumber
		case status
		case subject
		case version
	}

	public init() {
	}

	/// Indicates if the certificate is active and can be used by the device to establish a connection to the Cumulocity IoT platform.
	public enum C8yStatus: String, Codable {
		case enabled = "ENABLED"
		case disabled = "DISABLED"
	}

}
