//
// ApplicationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve, create, update and delete applications.
/// 
/// ### Application names
/// 
/// For each tenant, Cumulocity IoT manages the subscribed applications and provides a number of applications of various types.
/// In case you want to subscribe a tenant to an application using an API, you must use the application name in the argument (as name).
/// 
/// Refer to the tables in [Administration > Managing applications](https://cumulocity.com/guides/10.7.0/users-guide/administration#managing-applications) in the User guide for the respective application name to be used.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
/// 
public class ApplicationsApi: AdaptableApi {

	/// Retrieve all applications
	/// Retrieve all applications on your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </section>
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
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getApplications(currentPage: Int? = nil, name: String? = nil, owner: String? = nil, pageSize: Int? = nil, providedFor: String? = nil, subscriber: String? = nil, tenant: String? = nil, type: String? = nil, user: String? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yApplicationCollection, Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = name { queryItems.append(URLQueryItem(name: "name", value: String(parameter))) }
		if let parameter = owner { queryItems.append(URLQueryItem(name: "owner", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = providedFor { queryItems.append(URLQueryItem(name: "providedFor", value: String(parameter))) }
		if let parameter = subscriber { queryItems.append(URLQueryItem(name: "subscriber", value: String(parameter))) }
		if let parameter = tenant { queryItems.append(URLQueryItem(name: "tenant", value: String(parameter))) }
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter))) }
		if let parameter = user { queryItems.append(URLQueryItem(name: "user", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an application
	/// Create an application on your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An application was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 409
	///		  Duplicate key/name.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	public func createApplication(body: C8yApplication) -> AnyPublisher<C8yApplication, Error> {
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
			.set(resourcePath: "/application/applications")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.application+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific application
	/// Retrieve a specific application (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_READ <b>OR</b> current user has explicit access to the application
	/// </section>
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
	public func getApplication(id: String) -> AnyPublisher<C8yApplication, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific application
	/// Update a specific application (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_USER_MANAGEMENT_ADMIN
	/// </section>
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
	public func updateApplication(body: C8yApplication, id: String) -> AnyPublisher<C8yApplication, Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.activeVersionId = nil
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.type = nil
		requestBody.resourcesUrl = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yApplication, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)")
			.set(httpMethod: "put")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.application+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
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
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN <b>AND</b> tenant is the owner of the application
	/// </section>
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
	public func deleteApplication(id: String, force: Bool? = nil) -> AnyPublisher<Data, Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = force { queryItems.append(URLQueryItem(name: "force", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Copy an application
	/// Copy an application (by a given ID).
	/// 
	/// This method is not supported by microservice applications.
	/// 
	/// A request to the "clone" resource creates a new application based on an already existing one.
	/// 
	/// The properties are copied to the newly created application and the prefix "clone" is added to the properties `name`, `key` and `contextPath` in order to be unique.
	/// 
	/// If the target application is hosted and has an active version, the new application will have the active version with the same content.
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  An application was copied.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – method not supported
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the application.
	public func copyApplication(id: String) -> AnyPublisher<C8yApplication, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applications/\(id)/clone")
			.set(httpMethod: "post")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.application+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8yApplication.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve applications by name
	/// Retrieve applications by name.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the applications are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- name 
	///		  The name of the application.
	public func getApplicationsByName(name: String) -> AnyPublisher<C8yApplicationCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applicationsByName/\(name)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve applications by tenant
	/// Retrieve applications subscribed or owned by a particular tenant (by a given tenant ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the applications are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	public func getApplicationsByTenant(tenantId: String) -> AnyPublisher<C8yApplicationCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applicationsByTenant/\(tenantId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve applications by owner
	/// Retrieve all applications owned by a particular tenant (by a given tenant ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_APPLICATION_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the applications are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- tenantId 
	///		  Unique identifier of a Cumulocity IoT tenant.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getApplicationsByOwner(tenantId: String, currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yApplicationCollection, Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applicationsByOwner/\(tenantId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve applications by user
	/// Retrieve all applications for a particular user (by a given username).
	/// 
	/// <section><h5>Required roles</h5>
	/// (ROLE_USER_MANAGEMENT_OWN_READ <b>AND</b> is the current user) <b>OR</b> (ROLE_USER_MANAGEMENT_READ <b>AND</b> ROLE_APPLICATION_MANAGEMENT_READ)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the applications are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- username 
	///		  The username of the a user.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getApplicationsByUser(username: String, currentPage: Int? = nil, pageSize: Int? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yApplicationCollection, Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/application/applicationsByUser/\(username)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.applicationcollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard (200..<300) ~= httpResponse.statusCode else {
				if let c8yError = try? JSONDecoder().decode(C8yError.self, from: element.data) {
					throw Errors.badResponseError(response: httpResponse, reason: c8yError)
				}
				throw Errors.undescribedError(response: httpResponse)
			}
			return element.data
		}).decode(type: C8yApplicationCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
