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
/// > **&#9432; Info:** The Accept header should be provided in all PUT/POST requests, otherwise an empty response body will be returned.
/// 
public class RolesApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve all user roles
	/// Retrieve all user roles.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and has access to the user role
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all user roles are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getRoleCollectionResource() throws -> AnyPublisher<C8yUserRoleCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/roles")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.rolecollection+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
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
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE <b>AND</b> current user has acces to the role with this name
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the user role is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- name 
	///		  The name of the user role.
	public func getRoleCollectionResourceByName(name: String) throws -> AnyPublisher<C8yRole, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/roles/\(name)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.rolereference+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yRole.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Assign a user role to a specific user group in a specific tenant
	/// Assign a user role to a specific user group (by a given user group ID) in a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A user role was assigned to a user group.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- groupId 
	///		  Unique identifier of the user group.
	public func postGroupsRoleReferenceCollectionResource(body: C8ySubscribedRole, tenantId: String, groupId: String) throws -> AnyPublisher<C8yUserRoleReference, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/roles")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.rolereference+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.rolereference+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUserRoleReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Unassign a specific user role for a specific user group in a specific tenant
	/// Unassign a specific user role (given by a role ID) for a specific user group (by a given user group ID) in a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A user role was unassigned for a user group.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- groupId 
	///		  Unique identifier of the user group.
	/// 	- roleId 
	///		  Unique identifier of the user role.
	public func deleteGroupRoleReferenceResource(tenantId: String, groupId: String, roleId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/roles/\(roleId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Assign a user role to specific user in a specific tenant
	/// Assign a user role to a specific user (by a given user ID) in a specific tenant (by a given tenant ID).
	/// 
	/// When a user role is assigned to a user, a corresponding audit record is created with type "User" and activity "User updated".
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and is parent of the user
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A user role was assigned to a user.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- userId 
	///		  Unique identifier of the a user.
	public func postUsersRoleReferenceCollectionResource(body: C8ySubscribedRole, tenantId: String, userId: String) throws -> AnyPublisher<C8yUserRoleReference, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/roles")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.rolereference+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.rolereference+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUserRoleReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Unassign a specific user role for a specific user in a specific tenant
	/// Unassign a specific user role (by a given role ID) for a specific user (by a given user ID) in a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and is parent of the user and has access to roles
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A user role was unassigned from a user.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- userId 
	///		  Unique identifier of the a user.
	/// 	- roleId 
	///		  Unique identifier of the user role.
	public func deleteUserRoleReferenceResource(tenantId: String, userId: String, roleId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/roles/\(roleId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
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
