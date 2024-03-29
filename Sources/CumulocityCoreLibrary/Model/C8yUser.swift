//
// C8yUser.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yUser: Codable {

	/// A list of applications for this user.
	public var applications: [C8yApplication]?

	/// An object with a list of custom properties.
	public var customProperties: C8yCustomProperties?

	/// The user's display name in Cumulocity IoT.
	public var displayName: String?

	/// The user's email address.
	public var email: String?

	/// Indicates whether the user is enabled or not. Disabled users cannot log in or perform API requests.
	public var enabled: Bool?

	/// The user's first name.
	public var firstName: String?

	/// An object with a list of user groups.
	public var groups: C8yGroups?

	/// A unique identifier for this user.
	public var id: String?

	/// The user's last name.
	public var lastName: String?

	/// The date and time when the user's password was last changed, in [ISO 8601 datetime format](https://www.w3.org/TR/NOTE-datetime).
	public var lastPasswordChange: String?

	/// Indicates whether the user is subscribed to the newsletter or not.
	public var newsletter: Bool?

	/// Identifier of the parent user. If present, indicates that a user belongs to a user hierarchy by pointing to its direct ancestor. Can only be set by users with role USER_MANAGEMENT_ADMIN during user creation. Otherwise it's assigned automatically.
	public var owner: String?

	/// The user's password. Only Latin1 characters are allowed.
	/// 
	/// If you do not specify a password when creating a new user with a POST request, it must contain the property `sendPasswordResetEmail` with a value of `true`.
	public var password: String?

	/// Indicates the password strength. The value can be GREEN, YELLOW or RED for decreasing password strengths.
	public var passwordStrength: C8yPasswordStrength?

	/// The user's phone number.
	public var phone: String?

	/// An object with a list of user roles.
	public var roles: C8yRoles?

	/// A URL linking to this resource.
	public var `self`: String?

	/// When set to `true`, this field will cause Cumulocity IoT to send a password reset email to the email address specified.
	/// 
	/// If there is no password specified when creating a new user with a POST request, this must be specified and it must be set to `true`.
	public var sendPasswordResetEmail: Bool?

	/// Indicates if the user should reset the password on the next login.
	public var shouldResetPassword: Bool?

	/// Indicates if the user has to use two-factor authentication to log in.
	public var twoFactorAuthenticationEnabled: Bool?

	/// The user's username. It can have a maximum of 1000 characters.
	public var userName: String?

	/// An object with a list of the user's device permissions.
	@available(*, deprecated)
	public var devicePermissions: C8yDevicePermissions?

	enum CodingKeys: String, CodingKey {
		case applications
		case customProperties
		case displayName
		case email
		case enabled
		case firstName
		case groups
		case id
		case lastName
		case lastPasswordChange
		case newsletter
		case owner
		case password
		case passwordStrength
		case phone
		case roles
		case `self` = "self"
		case sendPasswordResetEmail
		case shouldResetPassword
		case twoFactorAuthenticationEnabled
		case userName
		case devicePermissions
	}

	public init() {
	}

	/// Indicates the password strength. The value can be GREEN, YELLOW or RED for decreasing password strengths.
	public enum C8yPasswordStrength: String, Codable {
		case green = "GREEN"
		case yellow = "YELLOW"
		case red = "RED"
	}

	/// An object with a list of user groups.
	public struct C8yGroups: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		/// A list of user group references.
		public var references: [C8yGroupReference]?
	
		/// Information about paging statistics.
		public var statistics: C8yPageStatistics?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case references
			case statistics
		}
	
		public init() {
		}
	}


	/// An object with a list of user roles.
	public struct C8yRoles: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		/// A list of user role references.
		public var references: [C8yRoleReference]?
	
		/// Information about paging statistics.
		public var statistics: C8yPageStatistics?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case references
			case statistics
		}
	
		public init() {
		}
	}
}
