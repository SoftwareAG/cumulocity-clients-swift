//
// C8yAuthConfig.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Parameters determining the authentication process.
public struct C8yAuthConfig: Codable {

	/// SSO specific. Describes the fields in the access token from the external server containing user information.
	public var accessTokenToUserDataMapping: C8yAccessTokenToUserDataMapping?

	/// SSO specific. Token audience.
	public var audience: String?

	public var authorizationRequest: C8yRequestRepresentation?

	/// For basic authentication case only.
	public var authenticationRestrictions: C8yBasicAuthenticationRestrictions?

	/// SSO specific. Information for the UI about the name displayed on the external server login button.
	public var buttonName: String?

	/// SSO specific. The identifier of the Cumulocity IoT tenant on the external authorization server.
	public var clientId: String?

	/// The authentication configuration grant type identifier.
	public var grantType: C8yGrantType?

	/// Unique identifier of this login option.
	public var id: String?

	/// SSO specific. External token issuer.
	public var issuer: String?

	public var logoutRequest: C8yRequestRepresentation?

	/// Indicates whether the configuration is only accessible to the management tenant.
	public var onlyManagementTenantAccess: Bool?

	/// SSO specific. Describes the process of internal user creation during login with the external authorization server.
	public var onNewUser: C8yOnNewUser?

	/// The name of the authentication provider.
	public var providerName: String?

	/// SSO specific. URL used for redirecting to the Cumulocity IoT platform.
	public var redirectToPlatform: String?

	public var refreshRequest: C8yRequestRepresentation?

	/// A URL linking to this resource.
	public var `self`: String?

	/// The session configuration properties are only available for OAuth internal. See [Changing settings > OAuth internal](https://cumulocity.com/guides/users-guide/administration/#oauth-internal) for more details.
	public var sessionConfiguration: C8yOAuthSessionConfiguration?

	/// SSO specific and authorization server dependent. Describes the method of access token signature verification on the Cumulocity IoT platform.
	public var signatureVerificationConfig: C8ySignatureVerificationConfig?

	/// SSO specific. Template name used by the UI.
	public var template: String?

	public var tokenRequest: C8yRequestRepresentation?

	/// The authentication configuration type. Note that the value is case insensitive.
	public var type: C8yType?

	/// SSO specific. Points to the field in the obtained JWT access token that should be used as the username in the Cumulocity IoT platform.
	public var userIdConfig: C8yUserIdConfig?

	/// Indicates whether user data are managed internally by the Cumulocity IoT platform or by an external server. Note that the value is case insensitive.
	public var userManagementSource: C8yUserManagementSource?

	/// Information for the UI if the respective authentication form should be visible for the user.
	public var visibleOnLoginPage: Bool?

	enum CodingKeys: String, CodingKey {
		case accessTokenToUserDataMapping
		case audience
		case authorizationRequest
		case authenticationRestrictions
		case buttonName
		case clientId
		case grantType
		case id
		case issuer
		case logoutRequest
		case onlyManagementTenantAccess
		case onNewUser
		case providerName
		case redirectToPlatform
		case refreshRequest
		case `self` = "self"
		case sessionConfiguration
		case signatureVerificationConfig
		case template
		case tokenRequest
		case type
		case userIdConfig
		case userManagementSource
		case visibleOnLoginPage
	}

	public init(providerName: String, type: C8yType) {
		self.providerName = providerName
		self.type = type
	}

	/// The authentication configuration grant type identifier.
	public enum C8yGrantType: String, Codable {
		case authorizationcode = "AUTHORIZATION_CODE"
		case password = "PASSWORD"
	}

	/// The authentication configuration type. Note that the value is case insensitive.
	public enum C8yType: String, Codable {
		case basic = "BASIC"
		case oauth2 = "OAUTH2"
		case oauth2internal = "OAUTH2_INTERNAL"
	}

	/// Indicates whether user data are managed internally by the Cumulocity IoT platform or by an external server. Note that the value is case insensitive.
	public enum C8yUserManagementSource: String, Codable {
		case `internal` = "INTERNAL"
		case remote = "REMOTE"
	}

	/// SSO specific. Describes the fields in the access token from the external server containing user information.
	public struct C8yAccessTokenToUserDataMapping: Codable {
	
		/// The name of the field containing the user's email.
		public var emailClaimName: String?
	
		/// The name of the field containing the user's first name.
		public var firstNameClaimName: String?
	
		/// The name of the field containing the user's last name.
		public var lastNameClaimName: String?
	
		/// The name of the field containing the user's phone number.
		public var phoneNumberClaimName: String?
	
		enum CodingKeys: String, CodingKey {
			case emailClaimName
			case firstNameClaimName
			case lastNameClaimName
			case phoneNumberClaimName
		}
	
		public init() {
		}
	}


	/// SSO specific. Describes the process of internal user creation during login with the external authorization server.
	public struct C8yOnNewUser: Codable {
	
		/// Modern version of configuration of default groups and applications. This ensures backward compatibility.
		public var dynamicMapping: C8yDynamicMapping?
	
		enum CodingKeys: String, CodingKey {
			case dynamicMapping
		}
	
		public init() {
		}
	
		/// Modern version of configuration of default groups and applications. This ensures backward compatibility.
		public struct C8yDynamicMapping: Codable {
		
			/// Configuration of the mapping.
			public var configuration: C8yConfiguration?
		
			/// Represents rules used to assign groups and applications.
			public var mappings: [C8yMappings]?
		
			enum CodingKeys: String, CodingKey {
				case configuration
				case mappings
			}
		
			public init() {
			}
		
			/// Configuration of the mapping.
			public struct C8yConfiguration: Codable {
			
				/// Indicates whether the mapping should be evaluated always or only during the first external login when the internal user is created.
				public var mapRolesOnlyForNewUser: Bool?
			
				enum CodingKeys: String, CodingKey {
					case mapRolesOnlyForNewUser
				}
			
				public init() {
				}
			}
		
			/// Represents information of mapping access to groups and applications.
			public struct C8yMappings: Codable {
			
				/// Represents a predicate for verification. It acts as a condition which is necessary to assign a user to the given groups and permit access to the specified applications.
				public var when: C8yJSONPredicateRepresentation?
			
				/// List of the applications' identifiers.
				public var thenApplications: [Int]?
			
				/// List of the groups' identifiers.
				public var thenGroups: [Int]?
			
				enum CodingKeys: String, CodingKey {
					case when
					case thenApplications
					case thenGroups
				}
			
				public init() {
				}
			}
		}
	}

	/// SSO specific and authorization server dependent. Describes the method of access token signature verification on the Cumulocity IoT platform.
	public struct C8ySignatureVerificationConfig: Codable {
	
		/// AAD signature verification configuration.
		public var aad: C8yAad?
	
		/// ADFS manifest signature verification configuration.
		public var adfsManifest: C8yAdfsManifest?
	
		/// The address of the endpoint which is used to retrieve the public key used to verify the JWT access token signature.
		public var jwks: C8yJwks?
	
		/// Describes the process of verification of JWT access token with the public keys embedded in the provided X.509 certificates.
		public var manual: C8yManual?
	
		enum CodingKeys: String, CodingKey {
			case aad
			case adfsManifest
			case jwks
			case manual
		}
	
		public init() {
		}
	
		/// AAD signature verification configuration.
		public struct C8yAad: Codable {
		
			/// URL used to retrieve the public key used for signature verification.
			public var publicKeyDiscoveryUrl: String?
		
			enum CodingKeys: String, CodingKey {
				case publicKeyDiscoveryUrl
			}
		
			public init() {
			}
		}
	
		/// ADFS manifest signature verification configuration.
		public struct C8yAdfsManifest: Codable {
		
			/// The URI to the manifest resource.
			public var manifestUrl: String?
		
			enum CodingKeys: String, CodingKey {
				case manifestUrl
			}
		
			public init() {
			}
		}
	
		/// The address of the endpoint which is used to retrieve the public key used to verify the JWT access token signature.
		public struct C8yJwks: Codable {
		
			/// The URI to the public key resource.
			public var jwksUrl: String?
		
			enum CodingKeys: String, CodingKey {
				case jwksUrl
			}
		
			public init() {
			}
		}
	
		/// Describes the process of verification of JWT access token with the public keys embedded in the provided X.509 certificates.
		public struct C8yManual: Codable {
		
			/// The name of the field in the JWT access token containing the certificate identifier.
			public var certIdField: String?
		
			/// Indicates whether the certificate identifier should be read from the JWT access token.
			public var certIdFromField: Bool?
		
			/// Details of the certificates.
			public var certificates: C8yCertificates?
		
			enum CodingKeys: String, CodingKey {
				case certIdField
				case certIdFromField
				case certificates
			}
		
			public init() {
			}
		
			/// Details of the certificates.
			public struct C8yCertificates: Codable {
			
				/// The signing algorithm of the JWT access token.
				public var alg: C8yAlg?
			
				/// The public key certificate.
				public var publicKey: String?
			
				/// The validity start date of the certificate.
				public var validFrom: String?
			
				/// The expiry date of the certificate.
				public var validTill: String?
			
				enum CodingKeys: String, CodingKey {
					case alg
					case publicKey
					case validFrom
					case validTill
				}
			
				public init() {
				}
			
				/// The signing algorithm of the JWT access token.
				public enum C8yAlg: String, Codable {
					case rsa = "RSA"
					case pcks = "PCKS"
				}
			
			}
		}
	}


	/// SSO specific. Points to the field in the obtained JWT access token that should be used as the username in the Cumulocity IoT platform.
	public struct C8yUserIdConfig: Codable {
	
		/// Used only when `useConstantValue` is set to `true`.
		public var constantValue: String?
	
		/// The name of the field containing the JWT.
		public var jwtField: String?
	
		/// Not recommended. If set to `true`, all SSO users will share one account in the Cumulocity IoT platform.
		public var useConstantValue: Bool?
	
		enum CodingKeys: String, CodingKey {
			case constantValue
			case jwtField
			case useConstantValue
		}
	
		public init() {
		}
	}

}
