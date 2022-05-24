//
// LoginOptionsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
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
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- management 
	///		  If this is set to `true`, the management tenant login options will be returned.  > **&#9432; Info:** The `tenantId` parameter must not be present in the request when using the `management` parameter, otherwise it will cause an error. 
	public func getLoginOptions(tenantId: String? = nil, management: Bool? = nil) throws -> AnyPublisher<C8yLoginOptionCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = tenantId { queryItems.append(URLQueryItem(name: "tenantId", value: String(parameter)))}
		if let parameter = management { queryItems.append(URLQueryItem(name: "management", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/loginOptions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.loginoptioncollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yLoginOptionCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
