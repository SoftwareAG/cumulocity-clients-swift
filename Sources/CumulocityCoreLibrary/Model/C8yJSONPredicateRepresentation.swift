//
// C8yJSONPredicateRepresentation.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Represents a predicate for verification. It acts as a condition which is necessary to assign a user to the given groups, permit access to the specified applications or to assign specific inventory roles to device groups.
public struct C8yJSONPredicateRepresentation: Codable {

	/// Nested predicates.
	public var childPredicates: [C8yJSONPredicateRepresentation]?

	/// Operator executed on the parameter from the JWT access token claim pointed by `parameterPath` and the provided parameter `value`.
	public var `operator`: C8yOperator?

	/// Path to the claim from the JWT access token from the external authorization server.
	public var parameterPath: String?

	/// Given value used for parameter verification.
	public var value: String?

	enum CodingKeys: String, CodingKey {
		case childPredicates
		case `operator` = "operator"
		case parameterPath
		case value
	}

	public init() {
	}

	/// Operator executed on the parameter from the JWT access token claim pointed by `parameterPath` and the provided parameter `value`.
	public enum C8yOperator: String, Codable {
		case eq = "EQ"
		case neq = "NEQ"
		case gt = "GT"
		case lt = "LT"
		case gte = "GTE"
		case lte = "LTE"
		case `in` = "IN"
		case and = "AND"
		case or = "OR"
	}

}
