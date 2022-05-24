//
// RolesApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to create, retrieve, update and delete user roles.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST requests, otherwise an empty response body will be returned.
/// 
public class RolesApi: AdaptableApi {

	/// Retrieve all user roles
	/// Retrieve all user roles.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE <b>AND</b> has access to the user role
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all user roles are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- withTotalPages 
	///		  When set to true, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getUserRoles(currentPage: Int? = nil, pageSize: Int? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yUserRoleCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter)))}
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter)))}
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/roles")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.rolecollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUserRoleCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a user role by name
	/// Retrieve a user role by name.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE <b>AND</b> current user has acces to the role with this name
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the user role is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Role not found.
	/// - Parameters:
	/// 	- name 
	///		  The name of the user role.
	public func getUserRole(name: String) throws -> AnyPublisher<C8yRole, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/roles/\(name)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.role+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yRole.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve all roles assigned to a specific user group in a specific tenant
	/// Retrieve all roles assigned to a specific user group (by a given user group ID) in a specific tenant (by a given tenant ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request succeeded and the roles are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// 	- 404
	///		  Group not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- groupId 
	///		  Unique identifier of the user group.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	public func getGroupRoles(tenantId: String, groupId: Int, currentPage: Int? = nil, pageSize: Int? = nil) throws -> AnyPublisher<[C8yRoleReferenceCollection], Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter)))}
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/roles")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.rolereferencecollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: [C8yRoleReferenceCollection].self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Assign a role to a specific user group in a specific tenant
	/// Assign a role to a specific user group (by a given user group ID) in a specific tenant (by a given tenant ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A user role was assigned to a user group.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  Group not found.
	/// 	- 409
	///		  Conflict – Role already assigned to the user group.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- groupId 
	///		  Unique identifier of the user group.
	public func assignGroupRole(body: C8ySubscribedRole, tenantId: String, groupId: Int) throws -> AnyPublisher<C8yRoleReference, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/roles")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.rolereference+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.rolereference+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yRoleReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Unassign a specific role for a specific user group in a specific tenant
	/// Unassign a specific role (given by a role ID) for a specific user group (by a given user group ID) in a specific tenant (by a given tenant ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A role was unassigned from a user group.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  Role not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- groupId 
	///		  Unique identifier of the user group.
	/// 	- roleId 
	///		  Unique identifier of the user role.
	public func unassignGroupRole(tenantId: String, groupId: Int, roleId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/roles/\(roleId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Assign a role to specific user in a specific tenant
	/// Assign a role to a specific user (by a given user ID) in a specific tenant (by a given tenant ID).
	/// 
	/// When a role is assigned to a user, a corresponding audit record is created with type "User" and activity "User updated".
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE <b>AND</b> is parent of the user
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A user role was assigned to a user.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// 	- 404
	///		  User not found.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- userId 
	///		  Unique identifier of the a user.
	public func assignUserRole(body: C8ySubscribedRole, tenantId: String, userId: String) throws -> AnyPublisher<C8yRoleReference, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/roles")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.rolereference+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.rolereference+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yRoleReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Unassign a specific role from a specific user in a specific tenant
	/// Unassign a specific role (by a given role ID) from a specific user (by a given user ID) in a specific tenant (by a given tenant ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE <b>AND</b> is parent of the user <b>AND</b> has access to roles
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A user role was unassigned from a user.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  User not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- userId 
	///		  Unique identifier of the a user.
	/// 	- roleId 
	///		  Unique identifier of the user role.
	public func unassignUserRole(tenantId: String, userId: String, roleId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/roles/\(roleId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
}
