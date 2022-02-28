//
// C8yAuditType.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// Identifies the platform component of the audit.
public enum C8yAuditType: String, Codable {
	case alarm = "Alarm"
	case application = "Application"
	case bulkoperation = "BulkOperation"
	case cepmodule = "CepModule"
	case connector = "Connector"
	case event = "Event"
	case group = "Group"
	case inventory = "Inventory"
	case inventoryrole = "InventoryRole"
	case operation = "Operation"
	case option = "Option"
	case report = "Report"
	case singlesignon = "SingleSignOn"
	case smartrule = "SmartRule"
	case system = "SYSTEM"
	case tenant = "Tenant"
	case tenantauthconfig = "TenantAuthConfig"
	case trustedcertificates = "TrustedCertificates"
	case userauthentication = "UserAuthentication"
}
