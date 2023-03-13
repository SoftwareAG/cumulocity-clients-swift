//
// C8yPosition.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Reports the geographical location of an asset in terms of latitude, longitude and altitude.
/// 
/// Altitude is given in meters. To report the current location of an asset or a device, `c8y_Position` is added to the managed object representing the asset or device. To trace the position of an asset or a device, `c8y_Position` is sent as part of an event of type `c8y_LocationUpdate`.
public struct C8yPosition: Codable {

	/// In meters.
	public var alt: Double?

	public var lng: Double?

	public var lat: Double?

	/// Describes in which protocol the tracking context of a positioning report was sent.
	public var trackingProtocol: String?

	/// Describes why the tracking context of a positioning report was sent.
	public var reportReason: String?

	enum CodingKeys: String, CodingKey {
		case alt
		case lng
		case lat
		case trackingProtocol
		case reportReason
	}

	public init() {
	}
}
