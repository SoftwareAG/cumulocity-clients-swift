//
// TenantsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Tenants are physically separated data spaces with a separate URL, with own users, a separate application management and no sharing of data by default. Users in a single tenant by default share the same URL and the same data space.
/// 
/// > Tip: Tenant ID and tenant domain
/// The **tenant ID** is a unique identifier across all tenants in Cumulocity IoT and it follows the format t<number>, for example, t07007007. It is possible to specify the tenant ID while creating a subtenant, but the ID cannot be changed after creation. If the ID is not specified (recommended), it gets auto-generated for all tenant types.
/// 
/// The location where a tenant can be accessed is called **tenant domain**, for example, *mytenant.cumulocity.com*. It needs to be unique across all tenants and it can be changed after tenant creation.The tenant domain may contain only lowercase letters, digits and hyphens. It must start with a lowercase letter, hyphens are only allowed in the middle, and the minimum length is 2 characters. Note that the usage of underscore characters is deprecated but still possible for backward compatibility reasons.
/// 
/// In general, the tenant domain should be used for communication if it is known.
/// 
/// > **⚠️ Important:** For support user access, the tenant ID must be used and not the tenant domain.
/// See [Tenant > Current tenant](#operation/getCurrentTenantResource) for information on how to retrieve the tenant ID and domain of the current tenant via the API.
/// 
/// In the UI, the tenant ID is displayed in the user dropdown menu, see [Getting started > Get familiar with the UI > User options and settings](https://cumulocity.com/docs/get-familiar-with-the-ui/user-settings/) in the Cumulocity IoT user documentation.
/// 
/// > Tip: Access rights and permissions
/// There are two types of roles in Cumulocity IoT – global and inventory. Global roles are applied at the tenant level. In a Role Based Access Control (RBAC) approach you must use the inventory roles in order to have the correct level of separation. Apart from some global permissions (like "own user management") customer users will not be assigned any roles. Inventory roles must be created, or the default roles used, and then assigned to the user in combination with the assets the roles apply to. This needs to be done at least once for each customer.
/// 
/// In a multi-tenancy approach, as the tenant is completely separated from all other customers you do not necessarily need to be involved in setting up the access rights of the customer. If customers are given administration rights for their tenants, they can set up permissions on their own. It is not possible for customers to have any sight or knowledge of other customers.
/// 
/// In the RBAC approach, managing access is the most complicated part because a misconfiguration can potentially give customers access to data that they must not see, like other customers' data. The inventory roles allow you to granularly define access for only certain parts of data, but they don't protect you from accidental misconfigurations. A limitation here is that customers won't be able to create their own roles.
/// 
/// For more details, see [RBAC versus multi-tenancy approach](https://cumulocity.com/docs/concepts/tenant-hierarchy/#comparison-of-various-use-cases).
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class TenantsApi: AdaptableApi {

	/// Retrieve all subtenants
	/// 
	/// Retrieve all subtenants of the current tenant.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_MANAGEMENT_READ 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the subtenants are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - company:
	///     Company name associated with the Cumulocity IoT tenant.
	///   - domain:
	///     Domain name of the Cumulocity IoT tenant.
	///   - parent:
	///     Identifier of the Cumulocity IoT tenant's parent.
	public func getTenants(currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil, company: String? = nil, domain: String? = nil, parent: String? = nil) -> AnyPublisher<C8yTenantCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.tenantcollection+json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "withTotalElements", value: withTotalElements)
			.add(queryItem: "withTotalPages", value: withTotalPages)
			.add(queryItem: "company", value: company)
			.add(queryItem: "domain", value: domain)
			.add(queryItem: "parent", value: parent)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTenantCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a tenant
	/// 
	/// Create a subtenant for the current tenant.
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_CREATE) *AND* the current tenant is allowed to create subtenants 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A tenant was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 409 Conflict – The tenant domain/ID already exists.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func createTenant(body: C8yTenant) -> AnyPublisher<C8yTenant, Error> {
		var requestBody = body
		requestBody.allowCreateTenants = nil
		requestBody.parent = nil
		requestBody.creationTime = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.ownedApplications = nil
		requestBody.applications = nil
		requestBody.status = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yTenant, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.tenant+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.tenant+json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTenant.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the current tenant
	/// 
	/// Retrieve information about the current tenant.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_OWN_READ *OR* ROLE_SYSTEM 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the information is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - withParent:
	///     When set to `true`, the returned result will contain the parent of the current tenant.
	public func getCurrentTenant(withParent: Bool? = nil) -> AnyPublisher<C8yCurrentTenant, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/currentTenant")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.currenttenant+json")
			.add(queryItem: "withParent", value: withParent)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yCurrentTenant.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific tenant
	/// 
	/// Retrieve a specific tenant by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_MANAGEMENT_READ *AND* (the current tenant is its parent *OR* is the management tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the tenant is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Tenant not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func getTenant(tenantId: String) -> AnyPublisher<C8yTenant, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.tenant+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTenant.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific tenant
	/// 
	/// Update a specific tenant by a given ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  (ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_UPDATE) *AND*
	///  ((the current tenant is its parent *AND* the current tenant is allowed to create subtenants) *OR* is the management tenant) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 A tenant was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Tenant not found.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func updateTenant(body: C8yTenant, tenantId: String) -> AnyPublisher<C8yTenant, Error> {
		var requestBody = body
		requestBody.adminName = nil
		requestBody.allowCreateTenants = nil
		requestBody.parent = nil
		requestBody.creationTime = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.ownedApplications = nil
		requestBody.applications = nil
		requestBody.status = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yTenant, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.tenant+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.tenant+json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTenant.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific tenant
	/// 
	/// Remove a specific tenant by a given ID.
	/// 
	/// > **⚠️ Important:** Deleting a subtenant cannot be reverted. For security reasons, it is therefore only available in the management tenant. You cannot delete tenants from any tenant but the management tenant.
	/// Administrators in Enterprise Tenants are only allowed to suspend active subtenants, but not to delete them.
	/// 
	/// > Tip: Required roles
	///  ROLE_TENANT_MANAGEMENT_ADMIN *AND* is the management tenant 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A tenant was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Tenant not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func deleteTenant(tenantId: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve TFA settings of a specific tenant
	/// 
	/// Retrieve the two-factor authentication settings of a specific tenant by a given tenant ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ((ROLE_TENANT_MANAGEMENT_READ *OR* ROLE_USER_MANAGEMENT_READ) *AND* (the current tenant is its parent *OR* is the management tenant *OR* the current user belongs to the tenant)) *OR* (the user belongs to the tenant *AND* ROLE_USER_MANAGEMENT_OWN_READ) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the TFA settings are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Tenant not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func getTenantTfaSettings(tenantId: String) -> AnyPublisher<C8yTenantTfaData, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/tfa")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).decode(type: C8yTenantTfaData.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Sets TFA settings for a specific tenant
	/// 
	/// Sets the two-factor authentication settings of a specific tenant for a specific tenant ID.
	/// 
	/// 
	/// > Tip: Required roles
	///  ((ROLE_TENANT_MANAGEMENT_ADMIN *OR* ROLE_TENANT_MANAGEMENT_UPDATE) *AND* (the current tenant is its parent *OR* the current user belongs to the tenant))) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 The tenant's TFA configuration was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Tenant not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func updateTenantTfaSettings(body: C8yTenantTfaStrategy, tenantId: String) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/tenants/\(tenantId)/tfa")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					c8yError.httpResponse = httpResponse
					throw c8yError
				}
				throw BadResponseError(with: httpResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
}
