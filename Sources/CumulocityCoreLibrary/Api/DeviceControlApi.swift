//
// DeviceControlApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// The device control API resource returns URIs and URI templates to collections of operations so that they can be retrieved.
/// 
/// > **&#9432; Info:** In order to create/retrieve/update an operation for a device, the device must be in the “childDevices” hierarchy of an existing agent. To create an agent in the inventory, you should create a managed object with a fragment `com_cumulocity_model_Agent`.
/// 
public class DeviceControlApi: AdaptableApi {

	/// Retrieve URIs to collections of operations
	/// Retrieve URIs to collections of operations.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_DEVICE_CONTROL_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the URIs are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getDeviceControlApiResource() throws -> AnyPublisher<C8yDeviceControlApiResource, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/devicecontrol")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.devicecontrolapi+json, application/vnd.com.nsn.cumulocity.error+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yDeviceControlApiResource.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
