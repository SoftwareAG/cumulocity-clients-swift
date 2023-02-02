//
// LoginOptionsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve the login options configured in the tenant.
/// 
/// More detailed information about the parameters and their meaning can be found in [Administration > Changing settings](https://cumulocity.com/guides/users-guide/administration/#changing-settings) in the *Users guide*.
/// > **&#9432; Info:** If OAuth external is the only login option shown in the response, the user will be automatically redirected to the SSO login screen.
/// 
public class LoginOptionsApi: AdaptableApi {

	/// Retrieve the login options
	/// Retrieve the login options available in the tenant.
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the login options are sent in the response.
	/// 	- 400
	///		  Bad request – invalid parameters.
	/// - Parameters:
	/// 	- management 
	///		  If this is set to `true`, the management tenant login options will be returned.  > **&#9432; Info:** The `tenantId` parameter must not be present in the request when using the `management` parameter, otherwise it will cause an error. 
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func getLoginOptions(management: Bool? = nil, tenantId: String? = nil) -> AnyPublisher<C8yLoginOptionCollection, Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = management { queryItems.append(URLQueryItem(name: "management", value: String(parameter))) }
		if let parameter = tenantId { queryItems.append(URLQueryItem(name: "tenantId", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.loginoptioncollection+json")
			.set(queryItems: queryItems)
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
		}).decode(type: C8yLoginOptionCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a login option
	/// Create an authentication configuration on your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_TENANT_ADMIN <b>OR</b> ROLE_TENANT_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A login option was created.
	/// 	- 400
	///		  Duplicated – The login option already exists.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	public func createLoginOption(body: C8yAuthConfig) -> AnyPublisher<C8yAuthConfig, Error> {
		var requestBody = body
		requestBody.`self` = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yAuthConfig, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.authconfig+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.authconfig+json")
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
		}).decode(type: C8yAuthConfig.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a tenant's access to the login option
	/// Update the tenant's access to the authentication configuration.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_TENANT_MANAGEMENT_ADMIN <b>AND</b> is the management tenant
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The login option was updated.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  Tenant not found.
	/// - Parameters:
	/// 	- body 
	/// 	- typeOrId 
	///		  The type or ID of the login option. The type's value is case insensitive and can be `OAUTH2`, `OAUTH2_INTERNAL` or `BASIC`.
	/// 	- targetTenant 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func updateLoginOption(body: C8yAuthConfigAccess, typeOrId: String, targetTenant: String) -> AnyPublisher<C8yAuthConfig, Error> {
		let requestBody = body
		var queryItems: [URLQueryItem] = []
		queryItems.append(URLQueryItem(name: "targetTenant", value: String(targetTenant)))
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yAuthConfig, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions\\(typeOrId)/restrict")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.authconfig+json")
			.set(queryItems: queryItems)
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
		}).decode(type: C8yAuthConfig.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
