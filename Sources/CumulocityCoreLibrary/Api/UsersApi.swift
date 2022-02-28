//
// UsersApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to create, retrieve, update and delete users in Cumulocity IoT.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all PUT/POST requests, otherwise an empty response body will be returned.
/// 
public class UsersApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve all users for a specific tenant
	/// Retrieve all users for a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all users are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- username 
	///		  Prefix or full username
	/// 	- groups 
	///		  Numeric group identifiers separated by commas. The response will contain only users which belong to at least one of the specified groups.
	/// 	- owner 
	///		  Exact username of the owner of the user
	/// 	- onlyDevices 
	///		  If set to `true`, the response will only contain users created during bootstrap process (starting with “device_”). If the flag is absent or `false` the result will not contain “device_” users. 
	/// 	- withSubusersCount 
	///		  If set to `true`, then each of returned user will contain an additional field “subusersCount”. It is the number of direct subusers (users with corresponding “owner”). 
	public func getUserCollectionResource(tenantId: String, username: String? = nil, groups: String? = nil, owner: String? = nil, onlyDevices: Bool? = nil, withSubusersCount: Bool? = nil) throws -> AnyPublisher<C8yUserCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = username { queryItems.append(URLQueryItem(name: "username", value: String(parameter)))}
		if let parameter = groups { queryItems.append(URLQueryItem(name: "groups", value: String(parameter)))}
		if let parameter = owner { queryItems.append(URLQueryItem(name: "owner", value: String(parameter)))}
		if let parameter = onlyDevices { queryItems.append(URLQueryItem(name: "onlyDevices", value: String(parameter)))}
		if let parameter = withSubusersCount { queryItems.append(URLQueryItem(name: "withSubusersCount", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.usercollection+json")
			.set(queryItems: queryItems)
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUserCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a user for a specific tenant
	/// Create a user for a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and has access to roles, groups, device permissions and applications
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A user was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func postUserCollectionResource(body: C8yUser, tenantId: String) throws -> AnyPublisher<C8yUser, Swift.Error> {
		var requestBody = body
		requestBody.newsletter = nil
		requestBody.passwordStrength = nil
		requestBody.customProperties = nil
		requestBody.displayName = nil
		requestBody.roles = nil
		requestBody.`self` = nil
		requestBody.groups = nil
		requestBody.shouldResetPassword = nil
		requestBody.id = nil
		requestBody.lastPasswordChange = nil
		requestBody.applications = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.user+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.user+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific user for a specific tenant
	/// Retrieve a specific user (by a given user ID) for a specific tenant (by a given tenant ID).
	/// 
	/// Users in the response are sorted by username in ascending order.
	/// Only objects which the user is allowed to see are returned to the user.
	/// The user password is never returned in a GET response. Authentication mechanism is provided by another interface.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and is parent of the user
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the user is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  User not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- userId 
	///		  Unique identifier of the a user.
	public func getUserResource(tenantId: String, userId: String) throws -> AnyPublisher<C8yUser, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.user+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific user for a specific tenant
	/// Update a specific user (by a given user ID) for a specific tenant (by a given tenant ID).
	/// 
	/// Any change in user’s roles, device permissions and groups creates corresponding audit records with type "User" and activity "User updated" with information which properties have been changed.
	/// 
	/// When the user is updated with changed permissions or groups, a corresponding audit record is created with type ‘User’ and activity ‘User updated’.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and has access to device permissions and applications
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A user was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
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
	public func putUserResource(body: C8yUser, tenantId: String, userId: String) throws -> AnyPublisher<C8yUser, Swift.Error> {
		var requestBody = body
		requestBody.newsletter = nil
		requestBody.passwordStrength = nil
		requestBody.customProperties = nil
		requestBody.displayName = nil
		requestBody.roles = nil
		requestBody.`self` = nil
		requestBody.groups = nil
		requestBody.shouldResetPassword = nil
		requestBody.id = nil
		requestBody.lastPasswordChange = nil
		requestBody.applications = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.user+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.user+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a specific user for a specific tenant
	/// Delete a specific user (by a given user ID) for a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and is parent of the user and not the current user
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A user was removed.
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
	public func deleteUserResource(tenantId: String, userId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)")
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
	
	/// Retrieve a user by name in a specific tenant
	/// Retrieve a user by name in a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and is parent of the user
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the user is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  User not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- username 
	///		  The username of the a user.
	public func getUsersByNameResource(tenantId: String, username: String) throws -> AnyPublisher<C8yUser, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/userByName/\(username)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.user+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the users of a specific user group of a specific tenant
	/// Retrieve the users of a specific user group (by a given user group ID) of a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_READ <b>OR</b> (ROLE_USER_MANAGEMENT_CREATE <b>AND</b> has access to the user group)
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the users are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- groupId 
	///		  Unique identifier of the user group.
	public func getUserReferenceCollectionResource(tenantId: String, groupId: String) throws -> AnyPublisher<C8yUserReferenceCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/users")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.usercollection+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUserReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Add a user for a specific user group of a specific tenant
	/// Add a user for a specific user group (by a given user group ID) of a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and is parent of the user
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  The user was added to the group.
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
	public func postUserReferenceCollectionResource(body: C8ySubscribedUser, tenantId: String, groupId: String) throws -> AnyPublisher<C8yUser, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/users")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.userreference+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.userreference+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a specific user from a specific user group of a specific tenant
	/// Delete a specific user (by a given user ID) from a specific user group (by a given user group ID) of a specific tenant (by a given tenant ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN <b>OR</b> ROLE_USER_MANAGEMENT_CREATE and is parent of the user and is not the current user
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A user was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  User not found.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- groupId 
	///		  Unique identifier of the user group.
	/// 	- userId 
	///		  Unique identifier of the a user.
	public func deleteUserReferenceResource(tenantId: String, groupId: String, userId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/users/\(userId)")
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
