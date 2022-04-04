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
/// > **&#9432; Info:** The Accept header should be provided in all PUT requests, otherwise an empty response body will be returned.
/// 
public class CurrentApplicationApi: AdaptableApi {

	/// Retrieve the current application
	/// Retrieve the current application.
	/// This only works inside an application, e.g. a microservice.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// Microservice bootstrap user required.
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the current application sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	public func getCurrentApplicationResource() throws -> AnyPublisher<C8yApplication, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update the current application
	/// 
	/// Update the current application.
	/// This only works inside an application, e.g. a microservice. This method is deprecated as it is only used by legacy microservices that are not running on Kubernetes.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// Microservice bootstrap user required.
	/// </div></div>
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
	public func putCurrentApplicationResource(body: C8yApplication) throws -> AnyPublisher<C8yApplication, Swift.Error> {
		var requestBody = body
		requestBody.globalTitle = nil
		requestBody.legacy = nil
		requestBody.owner?.`self` = nil
		requestBody.dynamicOptionsUrl = nil
		requestBody.upgrade = nil
		requestBody.activeVersionId = nil
		requestBody.manifest = nil
		requestBody.rightDrawer = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.contentSecurityPolicy = nil
		requestBody.breadcrumbs = nil
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
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the current application settings
	/// Retrieve the current application settings.
	/// This only works inside an application, e.g. a microservice.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// Microservice bootstrap user <b>OR</b> microservice service user required.
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the current application settings are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not enough permissions/roles to perform this operation.
	public func getCurrentApplicationResourceSettings() throws -> AnyPublisher<[C8yApplicationSettings], Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication/settings")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationsettings+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: [C8yApplicationSettings].self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve the subscribed users of the current application
	/// Retrieve the subscribed users of the current application.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// Microservice bootstrap user required.
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the list of subscribed users for the current application is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	public func getApplicationUserCollectionRepresentation() throws -> AnyPublisher<C8yApplicationUserCollection, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/currentApplication/subscriptions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.applicationusercollection+json, application/vnd.com.nsn.cumulocity.error+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplicationUserCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
