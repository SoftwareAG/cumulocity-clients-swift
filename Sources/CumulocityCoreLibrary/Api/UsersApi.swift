//
// UsersApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to create, retrieve, update and delete users in Cumulocity IoT.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
public class UsersApi: AdaptableApi {

	/// Retrieve all users for a specific tenant
	/// 
	/// Retrieve all users for a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_READ *OR* ROLE_USER_MANAGEMENT_CREATE 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all users are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - groups:
	///     Numeric group identifiers. The response will contain only users which belong to at least one of the specified groups.
	///     
	///     **ⓘ Note** If you query for multiple user groups at once, comma-separate the values.
	///   - onlyDevices:
	///     If set to `true`, the response will only contain users created during bootstrap process (starting with ���device_���).If the flag is absent or `false` the result will not contain ���device_��� users.
	///   - owner:
	///     Exact username of the owner of the user
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - username:
	///     Prefix or full username
	///   - withSubusersCount:
	///     If set to `true`, then each of returned user will contain an additional field ���subusersCount���.It is the number of direct subusers (users with corresponding ���owner���).
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getUsers(tenantId: String, currentPage: Int? = nil, groups: [String]? = nil, onlyDevices: Bool? = nil, owner: String? = nil, pageSize: Int? = nil, username: String? = nil, withSubusersCount: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yUserCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.usercollection+json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "groups", value: groups, explode: .comma_separated)
			.add(queryItem: "onlyDevices", value: onlyDevices)
			.add(queryItem: "owner", value: owner)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "username", value: username)
			.add(queryItem: "withSubusersCount", value: withSubusersCount)
			.add(queryItem: "withTotalElements", value: withTotalElements)
			.add(queryItem: "withTotalPages", value: withTotalPages)
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
		}).decode(type: C8yUserCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a user for a specific tenant
	/// 
	/// Create a user for a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN *OR* ROLE_USER_MANAGEMENT_CREATE *AND* has access to roles, groups, device permissions and applications 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A user was created.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 409 Duplicate ��� The userName or alias already exists.
	/// * HTTP 422 Unprocessable Entity ��� invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func createUser(body: C8yUser, tenantId: String) -> AnyPublisher<C8yUser, Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.passwordStrength = nil
		requestBody.roles = nil
		requestBody.groups = nil
		requestBody.`self` = nil
		requestBody.shouldResetPassword = nil
		requestBody.id = nil
		requestBody.lastPasswordChange = nil
		requestBody.twoFactorAuthenticationEnabled = nil
		requestBody.devicePermissions = nil
		requestBody.applications = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yUser, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.user+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.user+json")
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
		}).decode(type: C8yUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific user for a specific tenant
	/// 
	/// Retrieve a specific user (by a given user ID) for a specific tenant (by a given tenant ID).
	/// 
	/// Users in the response are sorted by username in ascending order.Only objects which the user is allowed to see are returned to the user.The user password is never returned in a GET response. Authentication mechanism is provided by another interface.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_READ *OR* ROLE_USER_MANAGEMENT_CREATE *AND* is parent of the user 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the user is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 User not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - userId:
	///     Unique identifier of the a user.
	public func getUser(tenantId: String, userId: String) -> AnyPublisher<C8yUser, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.user+json")
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
		}).decode(type: C8yUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific user for a specific tenant
	/// 
	/// Update a specific user (by a given user ID) for a specific tenant (by a given tenant ID).
	/// 
	/// Any change in user's roles, device permissions and groups creates corresponding audit records with type "User" and activity "User updated" with information which properties have been changed.
	/// 
	/// When the user is updated with changed permissions or groups, a corresponding audit record is created with type "User" and activity "User updated".
	/// 
	/// Note that you cannot update the password or email of another user, they can only be updated for the current user.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN to update root users in a user hierarchy *OR* users that are not in any hierarchy
	///  ROLE_USER_MANAGEMENT_ADMIN to update non-root users in a user hierarchy *AND* whose parents have access to roles, groups, device permissions and applications being assigned
	///  ROLE_USER_MANAGEMENT_CREATE to update descendants of the current user in a user hierarchy *AND* whose parents have access to roles, groups, device permissions and applications being assigned 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 A user was updated.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 User not found.
	/// * HTTP 422 Unprocessable Entity ��� invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - userId:
	///     Unique identifier of the a user.
	public func updateUser(body: C8yUser, tenantId: String, userId: String) -> AnyPublisher<C8yUser, Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.passwordStrength = nil
		requestBody.roles = nil
		requestBody.groups = nil
		requestBody.`self` = nil
		requestBody.shouldResetPassword = nil
		requestBody.id = nil
		requestBody.lastPasswordChange = nil
		requestBody.userName = nil
		requestBody.twoFactorAuthenticationEnabled = nil
		requestBody.devicePermissions = nil
		requestBody.applications = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yUser, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.user+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.user+json")
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
		}).decode(type: C8yUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete a specific user for a specific tenant
	/// 
	/// Delete a specific user (by a given user ID) for a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN *OR* ROLE_USER_MANAGEMENT_CREATE *AND* is parent of the user *AND* not the current user 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A user was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 User not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - userId:
	///     Unique identifier of the a user.
	public func deleteUser(tenantId: String, userId: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)")
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
	
	/// Retrieve the TFA settings of a specific user
	/// 
	/// Retrieve the two-factor authentication settings for the specified user.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_READ *OR* (ROLE_USER_MANAGEMENT_CREATE *AND* is parent of the user) *OR* is the current user 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the TFA settings are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 User not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - userId:
	///     Unique identifier of the a user.
	public func getUserTfaSettings(tenantId: String, userId: String) -> AnyPublisher<C8yUserTfaData, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/users/\(userId)/tfa")
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
		}).decode(type: C8yUserTfaData.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a user by username in a specific tenant
	/// 
	/// Retrieve a user by username in a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN *OR* ROLE_USER_MANAGEMENT_CREATE *AND* is parent of the user 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the user is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 User not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - username:
	///     The username of the a user.
	public func getUserByUsername(tenantId: String, username: String) -> AnyPublisher<C8yUser, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/userByName/\(username)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.user+json")
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
		}).decode(type: C8yUser.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the users of a specific user group of a specific tenant
	/// 
	/// Retrieve the users of a specific user group (by a given user group ID) of a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_READ *OR* (ROLE_USER_MANAGEMENT_CREATE *AND* has access to the user group) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the users are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 Group not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - groupId:
	///     Unique identifier of the user group.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getUsersFromUserGroup(tenantId: String, groupId: Int, currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil) -> AnyPublisher<C8yUserReferenceCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/users")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.userreferencecollection+json")
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
		}).decode(type: C8yUserReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Add a user to a specific user group of a specific tenant
	/// 
	/// Add a user to a specific user group (by a given user group ID) of a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN to assign root users in a user hierarchy *OR* users that are not in any hierarchy to any group
	///  ROLE_USER_MANAGEMENT_ADMIN to assign non-root users in a user hierarchy to groups accessible by the parent of assigned user
	///  ROLE_USER_MANAGEMENT_CREATE to assign descendants of the current user in a user hierarchy to groups accessible by current user *AND* accessible by the parent of assigned user 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 The user was added to the group.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// * HTTP 404 Group not found.
	/// * HTTP 422 Unprocessable Entity ��� invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - groupId:
	///     Unique identifier of the user group.
	public func assignUserToUserGroup(body: C8ySubscribedUser, tenantId: String, groupId: Int) -> AnyPublisher<C8yUserReference, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yUserReference, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/users")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.userreference+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.userreference+json")
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
		}).decode(type: C8yUserReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific user from a specific user group of a specific tenant
	/// 
	/// Remove a specific user (by a given user ID) from a specific user group (by a given user group ID) of a specific tenant (by a given tenant ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN *OR* ROLE_USER_MANAGEMENT_CREATE *AND* is parent of the user *AND* is not the current user 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A user was removed from a group.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// * HTTP 404 User not found.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	///   - groupId:
	///     Unique identifier of the user group.
	///   - userId:
	///     Unique identifier of the a user.
	public func removeUserFromUserGroup(tenantId: String, groupId: Int, userId: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/\(tenantId)/groups/\(groupId)/users/\(userId)")
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
	
	/// Terminate a user's session
	/// 
	/// After logging out, a user has to enter valid credentials again to get access to the platform.
	/// 
	/// The request is responsible for removing cookies from the browser and invalidating internal platform access tokens.
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the user is logged out.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - cookie:
	///     The authorization cookie storing the access token of the user. This parameter is specific to OAI-Secure authentication.
	///   - xXSRFTOKEN:
	///     Prevents XRSF attack of the authenticated user. This parameter is specific to OAI-Secure authentication.
	public func logout(cookie: String? = nil, xXSRFTOKEN: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/logout")
			.set(httpMethod: "post")
			.add(header: "Cookie", value: cookie)
			.add(header: "X-XSRF-TOKEN", value: xXSRFTOKEN)
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
	
	/// Terminate all tenant users' sessions and invalidate tokens
	/// 
	/// The user with the role ROLE_USER_MANAGEMENT_ADMIN is authorized to log out all tenant users with a toked based access.
	/// 
	/// The request is responsible for terminating all tenant users' toked based sessions and invalidating internal platform access tokens.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_USER_MANAGEMENT_ADMIN *AND* is the current tenant 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the users (with a token based access) are logged out.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not enough permissions/roles to perform this operation.
	/// 
	/// - Parameters:
	///   - tenantId:
	///     Unique identifier of a Cumulocity IoT tenant.
	public func logoutAllUsers(tenantId: String) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/user/logout/\(tenantId)/allUsers")
			.set(httpMethod: "post")
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
