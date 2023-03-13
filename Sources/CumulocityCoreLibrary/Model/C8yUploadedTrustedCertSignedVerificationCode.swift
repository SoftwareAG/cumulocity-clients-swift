//
// C8yUploadedTrustedCertSignedVerificationCode.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The signed verification code to prove the user's possession of the certificate.
public struct C8yUploadedTrustedCertSignedVerificationCode: Codable {

	/// A signed verification code that proves the right to use the certificate.
	public var proofOfPossessionSignedVerificationCode: String?

	enum CodingKeys: String, CodingKey {
		case proofOfPossessionSignedVerificationCode
	}

	public init() {
	}
}
