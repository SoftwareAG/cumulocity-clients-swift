//
// ApplicationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve, create, update and delete applications.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all PUT/POST requests, otherwise an empty response body will be returned.
/// 
public class ApplicationsApi: AdaptableApi {

	public override init() {
		super.init()
	}

	public override init(requestBuilder: URLRequestBuilder) {
		super.init(requestBuilder: requestBuilder)
	}

	/// Retrieve all applications
	/// Retrieve all applications on your tenant.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the list of applications is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- name 
	///		  The name of the application.
	/// 	- owner 
	///		  The ID of the tenant that owns the applications.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- providedFor 
	///		  The ID of a tenant that is subscribed to the applications but doesn't own them.
	/// 	- subscriber 
	///		  The ID of a tenant that is subscribed to the applications.
	/// 	- tenant 
	///		  The ID of a tenant that either owns the application or is subscribed to the applications.
	/// 	- type 
	///		  The type of the application.
	/// 	- user 
	///		  The ID of a user that has access to the applications.
	/// 	- withTotalPages 
	///		  When set to true, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getAbstractApplicationCollectionResource(currentPage: Int? = nil, name: String? = nil, owner: String? = nil, pageSize: Int? = nil, providedFor: String? = nil, subscriber: String? = nil, tenant: String? = nil, type: String? = nil, user: String? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yApplicationCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter)))}
		if let parameter = name { queryItems.append(URLQueryItem(name: "name", value: String(parameter)))}
		if let parameter = owner { queryItems.append(URLQueryItem(name: "owner", value: String(parameter)))}
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter)))}
		if let parameter = providedFor { queryItems.append(URLQueryItem(name: "providedFor", value: String(parameter)))}
		if let parameter = subscriber { queryItems.append(URLQueryItem(name: "subscriber", value: String(parameter)))}
		if let parameter = tenant { queryItems.append(URLQueryItem(name: "tenant", value: String(parameter)))}
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter)))}
		if let parameter = user { queryItems.append(URLQueryItem(name: "user", value: String(parameter)))}
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
			.set(queryItems: queryItems)
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an application
	/// Create an application on your tenant.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  An application was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 409
	///		  Duplicate key/name.
	/// - Parameters:
	/// 	- body 
	public func postApplicationCollectionResource(body: C8yApplication) throws -> AnyPublisher<C8yApplication, Swift.Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.globalTitle = nil
		requestBody.legacy = nil
		requestBody.dynamicOptionsUrl = nil
		requestBody.upgrade = nil
		requestBody.requiredRoles = nil
		requestBody.manifest = nil
		requestBody.rightDrawer = nil
		requestBody.roles = nil
		requestBody.availability = nil
		requestBody.contentSecurityPolicy = nil
		requestBody.resourcesUrl = nil
		requestBody.activeVersionId = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.breadcrumbs = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.application+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific application
	/// Retrieve a specific application (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_READ <b>OR</b> current user has explicit access to the application
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the application is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Application not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	public func getApplicationResource(id: String) throws -> AnyPublisher<C8yApplication, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific application
	/// 
	/// Update a specific application (by a given ID).
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  An application was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Application not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the application.
	public func putApplicationResource(body: C8yApplication, id: String) throws -> AnyPublisher<C8yApplication, Swift.Error> {
		var requestBody = body
		requestBody.globalTitle = nil
		requestBody.legacy = nil
		requestBody.owner?.`self` = nil
		requestBody.dynamicOptionsUrl = nil
		requestBody.upgrade = nil
		requestBody.requiredRoles = nil
		requestBody.manifest = nil
		requestBody.rightDrawer = nil
		requestBody.roles = nil
		requestBody.contentSecurityPolicy = nil
		requestBody.activeVersionId = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.breadcrumbs = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.application+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
			.set(httpBody: try JSONEncoder().encode(requestBody))
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Delete an application
	/// Delete an application (by a given ID).
	/// This method is not supported by microservice applications.
	/// 
	/// > **&#9432; Info:** With regards to a hosted application, there is a caching mechanism in place that keeps the information about the placement of application files (html, javascript, css, fonts, etc.). Removing a hosted application, in normal circumstances, will cause the subsequent requests for application files to fail with an HTTP 404 error because the application is removed synchronously, its files are immediately removed on the node serving the request and at the same time the information is propagated to other nodes – but in rare cases there might be a delay with this propagation. In such situations, the files of the removed application can be served from those nodes up until the aforementioned cache expires. For the same reason, the cache can also cause HTTP 404 errors when the application is updated as it will keep the path to the files of the old version of the application. The cache is filled on demand, so there should not be issues if application files were not accessed prior to the delete request. The expiration delay of the cache can differ, but should not take more than one minute.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN <b>AND</b> tenant is the owner of the application
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  An application was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  Application not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	/// 	- force 
	///		  Force deletion by unsubscribing all tenants from the application first and then deleting the application itself.
	public func deleteApplicationResource(id: String, force: Bool? = nil) throws -> AnyPublisher<Data, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = force { queryItems.append(URLQueryItem(name: "force", value: String(parameter)))}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
			.set(queryItems: queryItems)
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Copy an application
	/// Copy an application (by a given ID).
	/// 
	/// This method is not supported by microservice applications.
	/// 
	/// A request to the “clone” resource creates a new application based on an already existing one.
	/// 
	/// The properties are copied to the newly created application. For name, key and context path a “clone” prefix is added in order to be unique.
	/// 
	/// If the target application is hosted and has an active version, the new application will have the active version with the same content.
	/// 
	/// The response contains a representation of the newly created application.
	/// 
	/// <div class="reqRoles"><div><h5></h5></div><div>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN
	/// </div></div>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An application was copied.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	public func postApplicationResource(id: String) throws -> AnyPublisher<C8yApplication, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/clone")
			.set(httpMethod: "post")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
		return URLSession.shared.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				throw URLError(.badServerResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
