//
// C8yLoginOption.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Login option properties.
public struct C8yLoginOption: Codable {

	/// For basic authentication case only.
	public var authenticationRestrictions: C8yAuthenticationRestrictions?

	/// Indicates if password strength is enforced.
	public var enforceStrength: Bool?

	/// The grant type of the OAuth configuration.
	public var grantType: C8yGrantType?

	/// Minimum length for the password when the strength validation is enforced.
	public var greenMinLength: Int?

	/// Unique identifier of this login option.
	public var id: String?

	/// A URL linking to the token generating endpoint.
	public var initRequest: String?

	/// The tenant domain
	public var loginRedirectDomain: String?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The session configuration properties are only available for OAuth internal. See [Changing settings > OAuth internal](https://cumulocity.com/guides/users-guide/administration/#oauth-internal) for more details.
	public var sessionConfiguration: C8ySessionConfiguration?

	/// Enforce password strength validation on subtenant level. `enforceStrength` enforces it on all tenants in the platform.
	public var strengthValidity: Bool?

	/// Two-factor authentication being used by this login option. TFA supported: SMS and TOTP.
	public var tfaStrategy: String?

	/// The type of authentication. See [Authentication](#section/Authentication) for more details.
	public var type: String?

	/// Specifies if the users are managed internally by Cumulocity IoT (`INTERNAL`) or if the users data are managed by a external system (`REMOTE`).
	public var userManagementSource: String?

	/// Indicates if this login option is available in the login page (only for SSO).
	public var visibleOnLoginPage: Bool?

	/// The type of authentication.
	@available(*, deprecated)
	public var pType: String?

	enum CodingKeys: String, CodingKey {
		case authenticationRestrictions
		case enforceStrength
		case grantType
		case greenMinLength
		case id
		case initRequest
		case loginRedirectDomain
		case `self` = "self"
		case sessionConfiguration
		case strengthValidity
		case tfaStrategy
		case type
		case userManagementSource
		case visibleOnLoginPage
		case pType
	}

	public init() {
	}

	/// The grant type of the OAuth configuration.
	public enum C8yGrantType: String, Codable {
		case password = "PASSWORD"
		case authorizationcode = "AUTHORIZATION_CODE"
	}

	/// For basic authentication case only.
	public struct C8yAuthenticationRestrictions: Codable {
	
		/// List of types of clients which are not allowed to use basic authentication. Currently the only supported option is WEB_BROWSERS.
		public var forbiddenClients: [String]?
	
		/// List of user agents, passed in `User-Agent` HTTP header, which are blocked if basic authentication is used.
		public var forbiddenUserAgents: [String]?
	
		/// List of user agents, passed in `User-Agent` HTTP header, which are allowed to use basic authentication.
		public var trustedUserAgents: [String]?
	
		enum CodingKeys: String, CodingKey {
			case forbiddenClients
			case forbiddenUserAgents
			case trustedUserAgents
		}
	
		public init() {
		}
	}


	/// The session configuration properties are only available for OAuth internal. See [Changing settings > OAuth internal](https://cumulocity.com/guides/users-guide/administration/#oauth-internal) for more details.
	public struct C8ySessionConfiguration: Codable {
	
		/// Maximum session duration (in milliseconds) during which a user does not have to login again.
		public var absoluteTimeoutMillis: Int?
	
		/// Maximum number of parallel sessions for one user.
		public var maximumNumberOfParallelSessions: Int?
	
		/// Amount of time before a token expires (in milliseconds) during which the token may be renewed.
		public var renewalTimeoutMillis: Int?
	
		/// Switch to turn additional user agent verification on or off during the session.
		public var userAgentValidationRequired: Bool?
	
		enum CodingKeys: String, CodingKey {
			case absoluteTimeoutMillis
			case maximumNumberOfParallelSessions
			case renewalTimeoutMillis
			case userAgentValidationRequired
		}
	
		public init() {
		}
	}
}
