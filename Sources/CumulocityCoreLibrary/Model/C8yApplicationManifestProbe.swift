//
// C8yApplicationManifestProbe.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public struct C8yApplicationManifestProbe: Codable {

	/// The probe failure threshold.
	public var failureThreshold: Int?

	/// The probe period in seconds.
	public var periodSeconds: Int?

	/// The probe timeout in seconds.
	public var timeoutSeconds: Int?

	/// The probe success threshold.
	public var successThreshold: Int?

	/// The probe's initial delay in seconds.
	public var initialDelaySeconds: Int?

	/// The probe's HTTP GET method information.
	public var httpGet: C8yHttpGet?

	enum CodingKeys: String, CodingKey {
		case failureThreshold
		case periodSeconds
		case timeoutSeconds
		case successThreshold
		case initialDelaySeconds
		case httpGet
	}

	public init() {
	}

	/// The probe's HTTP GET method information.
	public struct C8yHttpGet: Codable {
	
		/// The HTTP path.
		public var path: String?
	
		/// The HTTP port.
		public var port: Int?
	
		enum CodingKeys: String, CodingKey {
			case path
			case port
		}
	
		public init() {
		}
	}
}
