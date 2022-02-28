//
// C8yMobile.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Holds basic connectivity-related information, such as the equipment identifier of the modem (IMEI) in the device. This identifier is globally unique and often used to identify a mobile device.
/// 
public struct C8yMobile: Codable {

	/// The equipment identifier (IMEI) of the modem in the device.
	public var imei: String?

	/// The identifier of the cell in the mobile network that the device is currently connected with.
	public var cellId: String?

	/// The identifier of the SIM card that is currently in the device (often printed on the card).
	public var iccid: String?

	/// Other possible values are: `c8y_Mobile.imsi`, `c8y_Mobile.currentOperator`, `c8y_Mobile.currentBand`, `c8y_Mobile.connType`, `c8y_Mobile.rssi`, `c8y_Mobile.ecn0`, `c8y_Mobile.rcsp`, `c8y_Mobile.mnc`, `c8y_Mobile.lac` and `c8y_Mobile.msisdn`.
	/// 
	public var customFragments: [String: String]? = [:]

	enum CodingKeys: String, CodingKey {
		case imei
		case cellId
		case iccid
		case customFragments
	}

	public init(imei: String, cellId: String, iccid: String) {
		self.imei = imei
		self.cellId = cellId
		self.iccid = iccid
	}
}
