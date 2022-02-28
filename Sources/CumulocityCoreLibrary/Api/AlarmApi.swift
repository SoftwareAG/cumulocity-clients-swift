//
// AlarmApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The alarm API resource returns URIs and URI templates to collections of alarms, so that all alarms or alarms of a specified source device and/or status can be retrieved.
public class AlarmApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve URIs to collections of alarms
	/// Retrieve URIs and URI templates to collections of alarms.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_ALARM_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getAlarmsApiResource() throws -> AnyPublisher<C8yAlarmsApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/alarm")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.alarmapi+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yAlarmsApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
