//
// C8yUser.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yUser: Codable {

	/// A URL linking to this resource.
	public var `self`: String?

	/// The user's first name.
	public var firstName: String?

	/// The user's last name.
	public var lastName: String?

	/// The user's username. It can have a maximum of 1000 characters.
	public var userName: String?

	/// A unique identifier for this user.
	public var id: String?

	/// The user's display name in Cumulocity IoT.
	public var displayName: String?

	/// The user's phone number.
	public var phone: String?

	/// The user's email address.
	public var email: String?

	/// Indicates whether the user is subscribed to the newsletter or not.
	public var newsletter: Bool?

	/// The date and time when the user's password was last changed, in [ISO 8601 datetime format](https://www.w3.org/TR/NOTE-datetime).
	public var lastPasswordChange: String?

	/// Indicates whether the user should reset their password or not.
	public var shouldResetPassword: Bool?

	/// When set to `true`, this field will cause Cumulocity IoT to send a password reset email to the email address specified.
	/// If there is no password specified when creating a new user with a POST request, this must be specified and it must be set to `true`.
	/// 
	public var sendPasswordResetEmail: Bool?

	/// The user's password. Only Latin1 characters are allowed. If you do not specify a password when creating a new user with a POST request, it must contain the field `sendPasswordResetEmail` with a value of `true`.
	/// 
	public var password: String?

	/// Indicates the password strength. The value can be GREEN, YELLOW or RED for decreasing password strengths.
	public var passwordStrength: C8yPasswordStrength?

	/// Indicates whether the user is enabled or not.
	/// Disabled users cannot log in or perform API requests.
	/// 
	public var enabled: Bool?

	/// An object with a list of custom properties for this user.
	public var customProperties: C8yCustomProperties?

	/// An object with a list of user groups.
	public var groups: C8yGroups?

	/// An object with a list of user roles.
	public var roles: C8yRoles?

	/// An object with a list of the user's device permissions.
	@available(*, deprecated)
	public var devicePermissions: C8yDevicePermissions?

	/// A list of applications for this user.
	public var applications: [C8yApplication]?

	enum CodingKeys: String, CodingKey {
		case `self` = "self"
		case firstName
		case lastName
		case userName
		case id
		case displayName
		case phone
		case email
		case newsletter
		case lastPasswordChange
		case shouldResetPassword
		case sendPasswordResetEmail
		case password
		case passwordStrength
		case enabled
		case customProperties
		case groups
		case roles
		case devicePermissions
		case applications
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
		public var references: [C8yGroup]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case references
		}
	
		public init() {
		}
	}

	/// An object with a list of user roles.
	public struct C8yRoles: Codable {
	
		/// A URL linking to this resource.
		public var `self`: String?
	
		/// A list of user role references.
		public var references: [C8yRole]?
	
		enum CodingKeys: String, CodingKey {
			case `self` = "self"
			case references
		}
	
		public init() {
		}
	}
}
