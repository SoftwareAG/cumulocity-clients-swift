//
// SystemOptionsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve the read-only properties predefined in the platform's configuration.
/// 
/// For security reasons, a few system options are considered secured, which means the user must have the required role **ROLE_OPTION_MANAGEMENT_ADMIN** to read their values.
/// 
/// List of options:
/// 
/// |         Category          | Key                           | Considered as secured ||:-------------------------:|:------------------------------|:----------------------||         password          | green.min-length              | yes                   || two-factor-authentication | pin.validity                  | yes                   || two-factor-authentication | token.length                  | yes                   || two-factor-authentication | token.validity                | yes                   ||      authentication       | badRequestCounter             | yes                   ||           files           | microservice.zipped.max.size  | yes                   ||           files           | microservice.unzipped.max.size| yes                   ||           files           | webapp.zipped.max.size        | yes                   ||           files           | webapp.unzipped.max.size      | yes                   || two-factor-authentication | enforced                      | no                    ||       reportMailer        | available                     | no                    ||          system           | version                       | no                    ||          plugin           | eventprocessing.enabled       | no                    ||         password          | limit.validity                | no                    ||         password          | enforce.strength              | no                    || two-factor-authentication | strategy                      | no                    || two-factor-authentication | pin.length                    | no                    || two-factor-authentication | enabled                       | no                    || two-factor-authentication | enforced.group                | no                    || two-factor-authentication | tenant-scope-settings.enabled | no                    || two-factor-authentication | logout-on-browser-termination | no                    ||       connectivity        | microservice.url              | no                    ||       support-user        | enabled                       | no                    ||          support          | url                           | no                    ||         trackers          | supported.models              | no                    ||         encoding          | test                          | no                    ||        data-broker        | bootstrap.period              | no                    ||           files           | max.size                      | no                    ||      device-control       | bulkoperation.creationramp    | no                    ||         gainsight         | api.key                       | no                    ||            cep            | deprecation.alarm             | no                    ||       remoteaccess        | pass-through.enabled          | no                    ||    device-registration    | security-token.policy         | no                    |
public class SystemOptionsApi: AdaptableApi {

	/// Retrieve all system options
	/// 
	/// Retrieve all the system options available on the tenant.
	/// 
	/// > **������ Important:** Note that it is possible to call this endpoint without the ROLE_OPTION_MANAGEMENT_ADMIN role, but options that are considered secured (see the list of options above) will be obfuscated with a constant value `"<<Encrypted>>"`.
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the system options are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	public func getSystemOptions() -> AnyPublisher<C8ySystemOptionCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/system/options")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.optioncollection+json")
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
		}).decode(type: C8ySystemOptionCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific system option
	/// 
	/// Retrieve a specific system option (by a given category and key) on your tenant.
	/// 
	/// > **������ Important:** Note that it is possible to call this endpoint without the ROLE_OPTION_MANAGEMENT_ADMIN role, but only the options that are considered not secured (see the list of options above) will be returned. Otherwise, if the option is considered secured and the user does not have the required role, an HTTP response 403 will be returned.
	/// 
	/// > Tip: Required roles
	///  ROLE_OPTION_MANAGEMENT_ADMIN 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the system option is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 403 Not authorized to perform this operation.
	/// 
	/// - Parameters:
	///   - category:
	///     The category of the system options.
	///   - key:
	///     The key of a system option.
	public func getSystemOption(category: String, key: String) -> AnyPublisher<C8ySystemOption, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/system/options/\(category)/\(key)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.option+json")
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
		}).decode(type: C8ySystemOption.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
