//
// CurrentApplicationApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve and update the current application and to retrieve its subscribers.
/// It is the authenticated microservice user's application.
/// 
public class CurrentApplicationApi: AdaptableApi {

	/// Retrieve the current application
	/// Retrieve the current application.
	/// This only works inside an application, for example, a microservice.
	/// 
	/// <section><h5>Required roles</h5>
	/// Microservice bootstrap user required.
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the current application sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	public func getCurrentApplication() throws -> AnyPublisher<C8yApplication, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				let decoder = JSONDecoder()
				let error403 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error403)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update the current application
	/// Update the current application.
	/// This only works inside an application, for example, a microservice. This method is deprecated as it is only used by legacy microservices that are not running on Kubernetes.
	/// 
	/// <section><h5>Required roles</h5>
	/// Microservice bootstrap user required.
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The current application was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	/// - Parameters:
	/// 	- body 
	@available(*, deprecated)
	public func updateApplication(body: C8yApplication) throws -> AnyPublisher<C8yApplication, Swift.Error> {
		var requestBody = body
		requestBody.owner?.`self` = nil
		requestBody.activeVersionId = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.resourcesUrl = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.application+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				let decoder = JSONDecoder()
				let error403 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error403)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the current application settings
	/// Retrieve the current application settings.
	/// This only works inside an application, for example, a microservice.
	/// 
	/// <section><h5>Required roles</h5>
	/// Microservice bootstrap user <b>OR</b> microservice service user required.
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the current application settings are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	public func getCurrentApplicationSettings() throws -> AnyPublisher<[C8yApplicationSettings], Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication/settings")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationsettings+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				let decoder = JSONDecoder()
				let error403 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error403)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: [C8yApplicationSettings].self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the subscribed users of the current application
	/// Retrieve the subscribed users of the current application.
	/// 
	/// <section><h5>Required roles</h5>
	/// Microservice bootstrap user required.
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the list of subscribed users for the current application is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getSubscribedUsers() throws -> AnyPublisher<C8yApplicationUserCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication/subscriptions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.applicationusercollection+json, application/vnd.com.nsn.cumulocity.error+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yApplicationUserCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
