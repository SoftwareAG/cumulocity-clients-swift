//
// C8yNetwork.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Device capability to either display or display and manage the WAN, LAN, and DHCP settings.
public struct C8yNetwork: Codable {

	/// Local network information.
	public var c8yLAN: C8yLAN?

	/// Mobile internet connectivity interface status.
	public var c8yWAN: C8yWAN?

	/// Information for DHCP server status.
	public var c8yDHCP: C8yDHCP?

	enum CodingKeys: String, CodingKey {
		case c8yLAN = "c8y_LAN"
		case c8yWAN = "c8y_WAN"
		case c8yDHCP = "c8y_DHCP"
	}

	public init() {
	}

	/// Local network information.
	public struct C8yLAN: Codable {
	
		/// Subnet mask configured for the network interface.
		public var netmask: String?
	
		/// IP address configured for the network interface.
		public var ip: String?
	
		/// Identifier for the network interface.
		public var name: String?
	
		/// Indicator showing if the interface is enabled.
		public var enabled: Int?
	
		/// MAC address of the network interface.
		public var mac: String?
	
		enum CodingKeys: String, CodingKey {
			case netmask
			case ip
			case name
			case enabled
			case mac
		}
	
		public init() {
		}
	}

	/// Mobile internet connectivity interface status.
	public struct C8yWAN: Codable {
	
		/// SIM connectivity password.
		public var password: String?
	
		/// SIM connection status.
		public var simStatus: String?
	
		/// Authentication type used by the SIM connectivity.
		public var authType: String?
	
		/// APN used for internet access.
		public var apn: String?
	
		/// SIM connectivity username.
		public var username: String?
	
		enum CodingKeys: String, CodingKey {
			case password
			case simStatus
			case authType
			case apn
			case username
		}
	
		public init() {
		}
	}

	/// Information for DHCP server status.
	public struct C8yDHCP: Codable {
	
		/// First configured DNS server.
		public var dns1: String?
	
		/// Second configured DNS server.
		public var dns2: String?
	
		/// Domain name configured for the device.
		public var domainName: String?
	
		/// IP address range.
		public var addressRange: C8yAddressRange?
	
		/// Indicator showing if the DHCP server is enabled.
		public var enabled: Int?
	
		enum CodingKeys: String, CodingKey {
			case dns1
			case dns2
			case domainName
			case addressRange
			case enabled
		}
	
		public init() {
		}
	
		/// IP address range.
		public struct C8yAddressRange: Codable {
		
			/// Start of address range assigned to DHCP clients.
			public var start: String?
		
			/// End of address range assigned to DHCP clients.
			public var end: String?
		
			enum CodingKeys: String, CodingKey {
				case start
				case end
			}
		
			public init() {
			}
		}
	}
}
