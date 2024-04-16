//
// C8yLoginForm.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yLoginForm: Codable {

	/// Used in case of SSO login. A code received from the external authentication server is exchanged to an internal access token.
	public var code: String?

	/// Dependent on the authentication type. PASSWORD is used for OAI-Secure.
	public var grantType: C8yGrantType?

	/// Used in case of OAI-Secure authentication.
	public var password: String?

	/// Current TFA code, sent by the user, if a TFA code is required to log in. Used in case of OAI-Secure authentication.
	public var tfaCode: String?

	/// Used in case of OAI-Secure authentication.
	public var username: String?

	enum CodingKeys: String, CodingKey {
		case code
		case grantType = "grant_type"
		case password
		case tfaCode = "tfa_code"
		case username
	}

	public init() {
	}

	/// Dependent on the authentication type. PASSWORD is used for OAI-Secure.
	public enum C8yGrantType: String, Codable {
		case password = "PASSWORD"
		case authorizationcode = "AUTHORIZATION_CODE"
	}

}
