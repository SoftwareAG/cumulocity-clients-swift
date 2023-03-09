//
// C8yMicroserviceApplicationManifest.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

/// The manifest of the microservice application.
public struct C8yMicroserviceApplicationManifest: Codable {

	/// Document type format discriminator, for future changes in format.
	public var apiVersion: String?

	/// The billing mode of the application.
	/// 
	/// In case of RESOURCES, the number of resources used is exposed for billing calculation per usage.In case of SUBSCRIPTION, all resources usage is counted for the microservice owner and the subtenant is charged for subscription.
	public var billingMode: C8yBillingMode?

	/// The context path in the URL makes the application accessible.
	public var contextPath: String?

	/// A list of URL extensions for this microservice application.
	public var extensions: [C8yExtensions]?

	/// Deployment isolation.In case of PER_TENANT, there is a separate instance for each tenant.Otherwise, there is one single instance for all subscribed tenants.This will affect billing.
	public var isolation: C8yIsolation?

	public var livenessProbe: C8yApplicationManifestProbe?

	/// Application provider information.Simple name allowed for predefined providers, for example, c8y.Detailed object for external provider.
	public var provider: C8yProvider?

	public var readinessProbe: C8yApplicationManifestProbe?

	/// The minimum required resources for the microservice application.
	public var requestResources: C8yRequestResources?

	/// The recommended resources for this microservice application.
	public var resources: C8yResources?

	/// Roles provided by the microservice.
	public var roles: [String]?

	/// List of permissions required by a microservice to work.
	public var requiredRoles: [String]?

	/// Allows to configure a microservice auto scaling policy.If the microservice uses a lot of CPU resources, a second instance will be created automatically when this is set to `AUTO`.The default is `NONE`, meaning auto scaling will not happen.
	public var scale: C8yScale?

	/// A list of settings objects for this microservice application.
	public var settings: [C8yApplicationSettings]?

	/// Allows to specify a custom category for microservice settings.By default, `contextPath` is used.
	public var settingsCategory: String?

	/// Application version.Must be a correct [SemVer](https://semver.org/) value but the "+" sign is disallowed.
	public var version: String?

	enum CodingKeys: String, CodingKey {
		case apiVersion
		case billingMode
		case contextPath
		case extensions
		case isolation
		case livenessProbe
		case provider
		case readinessProbe
		case requestResources
		case resources
		case roles
		case requiredRoles
		case scale
		case settings
		case settingsCategory
		case version
	}

	public init() {
	}

	/// The billing mode of the application.
	/// 
	/// In case of RESOURCES, the number of resources used is exposed for billing calculation per usage.In case of SUBSCRIPTION, all resources usage is counted for the microservice owner and the subtenant is charged for subscription.
	public enum C8yBillingMode: String, Codable {
		case resources = "RESOURCES"
		case subscription = "SUBSCRIPTION"
	}

	/// Deployment isolation.In case of PER_TENANT, there is a separate instance for each tenant.Otherwise, there is one single instance for all subscribed tenants.This will affect billing.
	public enum C8yIsolation: String, Codable {
		case multitenant = "MULTI_TENANT"
		case pertenant = "PER_TENANT"
	}

	/// Allows to configure a microservice auto scaling policy.If the microservice uses a lot of CPU resources, a second instance will be created automatically when this is set to `AUTO`.The default is `NONE`, meaning auto scaling will not happen.
	public enum C8yScale: String, Codable {
		case none = "NONE"
		case auto = "AUTO"
	}


	public struct C8yExtensions: Codable {
	
		/// The relative path in Cumulocity IoT for this microservice application.
		public var path: String?
	
		/// The type of this extension.
		public var type: String?
	
		enum CodingKeys: String, CodingKey {
			case path
			case type
		}
	
		public init() {
		}
	}


	/// Application provider information.Simple name allowed for predefined providers, for example, c8y.Detailed object for external provider.
	public struct C8yProvider: Codable {
	
		/// The name of the application provider.
		public var name: String?
	
		enum CodingKeys: String, CodingKey {
			case name
		}
	
		public init() {
		}
	}

	/// The minimum required resources for the microservice application.
	public struct C8yRequestResources: Codable {
	
		/// The required CPU resource for this microservice application.
		public var cpu: String?
	
		/// The required memory resource for this microservice application.
		public var memory: String?
	
		enum CodingKeys: String, CodingKey {
			case cpu
			case memory
		}
	
		public init() {
		}
	}

	/// The recommended resources for this microservice application.
	public struct C8yResources: Codable {
	
		/// The required CPU resource for this microservice application.
		public var cpu: String?
	
		/// The required memory resource for this microservice application.
		public var memory: String?
	
		enum CodingKeys: String, CodingKey {
			case cpu
			case memory
		}
	
		public init() {
		}
	}

}
