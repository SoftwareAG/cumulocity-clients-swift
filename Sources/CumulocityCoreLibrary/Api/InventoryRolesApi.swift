//
// InventoryRolesApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to create, retrieve, update and delete inventory roles.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class InventoryRolesApi: AdaptableApi {

	/// Retrieve all inventory roles
	/// 
	/// Retrieve all inventory roles.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_READ *OR* ROLE_USER_MANAGEMENT_CREATE 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request succeeded and all inventory roles are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getInventoryRoles(currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil) -> AnyPublisher<C8yInventoryRoleCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/inventoryroles")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.inventoryrolecollection+json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "withTotalElements", value: withTotalElements)
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
		}).decode(type: C8yInventoryRoleCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an inventory role
	/// 
	/// Create an inventory role.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 An inventory role was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 409 Duplicate – The inventory role already exists.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	public func createInventoryRole(body: C8yInventoryRole) -> AnyPublisher<C8yInventoryRole, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yInventoryRole, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/inventoryroles")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.inventoryrole+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.inventoryrole+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yInventoryRole.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific inventory role
	/// 
	/// Retrieve a specific inventory role (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_READ *OR* ROLE_USER_MANAGEMENT_CREATE *AND* has access to the inventory role 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request succeeded and the inventory role is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Role not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the inventory role.
	public func getInventoryRole(id: Int) -> AnyPublisher<C8yInventoryRole, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/inventoryroles/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.inventoryrole+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yInventoryRole.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific inventory role
	/// 
	/// Update a specific inventory role (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 An inventory role was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Role not found.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the inventory role.
	public func updateInventoryRole(body: C8yInventoryRole, id: Int) -> AnyPublisher<C8yInventoryRole, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yInventoryRole, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/inventoryroles/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.inventoryrole+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.inventoryrole+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yInventoryRole.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific inventory role
	/// 
	/// Remove a specific inventory role (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 An inventory role was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Role not found.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the inventory role.
	public func deleteInventoryRole(id: Int) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/inventoryroles/\(id)")
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
	
	/// Retrieve all inventory roles assigned to a user
	/// 
	/// Retrieve all inventory roles assigned to a specific user (by a given user ID) in a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_READ *OR* ROLE_USER_MANAGEMENT_CREATE *AND* is the parent of the user 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the inventory roles are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 User not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - userId:
	///     Unique identifier of the a user.
	public func getUserInventoryRoles(tenantId: String, userId: String) -> AnyPublisher<C8yInventoryAssignmentCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/roles/inventory")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.inventoryassignmentcollection+json")
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
		}).decode(type: C8yInventoryAssignmentCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Assign an inventory role to a user
	/// 
	/// Assign an existing inventory role to a specific user (by a given user ID) in a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN to assign any inventory role to root users in a user hierarchy *OR* users that are not in any hierarchy
	///  ROLE_USER_MANAGEMENT_ADMIN to assign inventory roles accessible by the parent of the assigned user to non-root users in a user hierarchy
	///  ROLE_USER_MANAGEMENT_CREATE to assign inventory roles accessible by the current user *AND* accessible by the parent of the assigned user to the descendants of the current user in a user hierarchy 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 An inventory role was assigned to a user.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 User not found.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - userId:
	///     Unique identifier of the a user.
	public func assignUserInventoryRole(body: C8yInventoryAssignment, tenantId: String, userId: String) -> AnyPublisher<C8yInventoryAssignment, Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yInventoryAssignment, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/roles/inventory")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.inventoryassignment+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.inventoryassignment+json")
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
		}).decode(type: C8yInventoryAssignment.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific inventory role assigned to a user
	/// 
	/// Retrieve a specific inventory role (by a given ID) assigned to a specific user (by a given user ID) in a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_READ *OR* ROLE_USER_MANAGEMENT_CREATE *AND* is the parent of the user 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the inventory role is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 Role not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - userId:
	///     Unique identifier of the a user.
	///   - id:
	///     Unique identifier of the inventory assignment.
	public func getUserInventoryRole(tenantId: String, userId: String, id: Int) -> AnyPublisher<C8yInventoryAssignment, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/roles/inventory/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.inventoryassignment+json")
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
		}).decode(type: C8yInventoryAssignment.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific inventory role assigned to a user
	/// 
	/// Update a specific inventory role (by a given ID) assigned to a specific user (by a given user ID) in a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN to update the assignment of any inventory roles to root users in a user hierarchy *OR* users that are not in any hierarchy
	///  ROLE_USER_MANAGEMENT_ADMIN to update the assignment of inventory roles accessible by the assigned user parent, to non-root users in a user hierarchy
	///  ROLE_USER_MANAGEMENT_CREATE to update the assignment of inventory roles accessible by the current user *AND* the parent of the assigned user to the descendants of the current user in the user hierarchy 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 An inventory assignment was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 Role not found.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - userId:
	///     Unique identifier of the a user.
	///   - id:
	///     Unique identifier of the inventory assignment.
	public func updateUserInventoryRole(body: C8yInventoryAssignmentReference, tenantId: String, userId: String, id: Int) -> AnyPublisher<C8yInventoryAssignment, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yInventoryAssignment, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/roles/inventory/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.inventoryassignment+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.inventoryassignment+json")
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
		}).decode(type: C8yInventoryAssignment.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific inventory role assigned to a user
	/// 
	/// Remove a specific inventory role (by a given ID) assigned to a specific user (by a given user ID) in a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN *AND* (is not in user hierarchy *OR* is root in the user hierarchy) *OR* ROLE_USER_MANAGEMENT_ADMIN *AND* is in user hiararchy *AND* has parent access to inventory assignments *OR* ROLE_USER_MANAGEMENT_CREATE *AND* is parent of the user *AND* is not the current user *AND* has current user access to inventory assignments *AND* has parent access to inventory assignments 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 An inventory assignment was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 Role not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - userId:
	///     Unique identifier of the a user.
	///   - id:
	///     Unique identifier of the inventory assignment.
	public func unassignUserInventoryRole(tenantId: String, userId: String, id: Int) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/roles/inventory/\(id)")
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
}
