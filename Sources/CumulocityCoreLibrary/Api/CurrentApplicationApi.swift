//
// CurrentApplicationApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
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
	public func getCurrentApplication() -> AnyPublisher<C8yApplication, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
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
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	@available(*, deprecated)
	public func updateCurrentApplication(body: C8yApplication, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yApplication, Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.activeVersionId = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.resourcesUrl = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yApplication, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.application+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
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
	public func getCurrentApplicationSettings() -> AnyPublisher<[C8yApplicationSettings], Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication/settings")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationsettings+json")
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
	public func getSubscribedUsers() -> AnyPublisher<C8yApplicationUserCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication/subscriptions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.applicationusercollection+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yApplicationUserCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
