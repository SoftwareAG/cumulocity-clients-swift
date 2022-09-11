//
// IdentityApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Cumulocity IoT can associate devices and assets with multiple external identities.
/// For instance, devices can often be identified by the IMEI of their modem, by a micro-controller serial number or by an asset tag.
/// This is useful, for example, when you have non-functional hardware and must replace the hardware without losing the data that was recorded.
/// 
/// The identity API resource returns URIs and URI templates for associating external identifiers with unique identifiers.
/// 
public class IdentityApi: AdaptableApi {

	/// Retrieve URIs to collections of external IDs
	/// Retrieve URIs and URI templates for associating external identifiers with unique identifiers.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_IDENTITY_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getIdentityApiResource() throws -> AnyPublisher<C8yIdentityApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/identity")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.identityapi+json, application/vnd.com.nsn.cumulocity.error+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yIdentityApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
