//
// ChildOperationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Managed objects can contain collections of references to child devices, additions and assets.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST requests, otherwise an empty response body will be returned.
/// 
public class ChildOperationsApi: AdaptableApi {

	/// Retrieve all child additions of a specific managed object
	/// Retrieve all child additions of a specific managed object by a given ID, or a subset based on queries.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all child additions are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- query 
	///		  Use query language to perform operations and/or filter the results. Details about the properties and supported operations can be found in [Query language](#tag/Query-language).
	/// 	- withChildren 
	///		  Determines if children with ID and name should be returned when fetching the managed object. Set it to `false` to improve query performance.
	/// 	- withChildrenCount 
	///		  When set to `true`, the returned result will contain the total number of children in the respective objects (`childAdditions`, `childAssets` and `childDevices`).
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getChildAdditions(id: String, currentPage: Int? = nil, pageSize: Int? = nil, query: String? = nil, withChildren: Bool? = nil, withChildrenCount: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yManagedObjectReferenceCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = query { queryItems.append(URLQueryItem(name: "query", value: String(parameter))) }
		if let parameter = withChildren { queryItems.append(URLQueryItem(name: "withChildren", value: String(parameter))) }
		if let parameter = withChildrenCount { queryItems.append(URLQueryItem(name: "withChildrenCount", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				let decoder = JSONDecoder()
				let error422 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error422)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yManagedObjectReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child addition
	/// The possible ways to assign child objects are:
	/// 
	/// *  Assign an existing managed object (by a given child ID) as child addition of another managed object (by a given ID).
	/// *  Assign multiple existing managed objects (by given child IDs) as child additions of another managed object (by a given ID).
	/// *  Create a managed object in the inventory and assign it as a child addition to another managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ((owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source) <b>AND</b> (owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the child))
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was assigned as child addition.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func assignAsChildAddition(body: C8yChildOperationsAddOne, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child addition
	/// The possible ways to assign child objects are:
	/// 
	/// *  Assign an existing managed object (by a given child ID) as child addition of another managed object (by a given ID).
	/// *  Assign multiple existing managed objects (by given child IDs) as child additions of another managed object (by a given ID).
	/// *  Create a managed object in the inventory and assign it as a child addition to another managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ((owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source) <b>AND</b> (owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the child))
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was assigned as child addition.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func assignAsChildAddition(body: C8yChildOperationsAddMultiple, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child addition
	/// The possible ways to assign child objects are:
	/// 
	/// *  Assign an existing managed object (by a given child ID) as child addition of another managed object (by a given ID).
	/// *  Assign multiple existing managed objects (by given child IDs) as child additions of another managed object (by a given ID).
	/// *  Create a managed object in the inventory and assign it as a child addition to another managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ((owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source) <b>AND</b> (owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the child))
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was assigned as child addition.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func assignAsChildAddition(body: C8yManagedObject, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.additionParents = nil
		requestBody.lastUpdated = nil
		requestBody.childDevices = nil
		requestBody.childAssets = nil
		requestBody.creationTime = nil
		requestBody.childAdditions = nil
		requestBody.`self` = nil
		requestBody.assetParents = nil
		requestBody.deviceParents = nil
		requestBody.id = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Remove specific child additions from its parent
	/// Remove specific child additions (by given child IDs) from its parent (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the source (parent) <b>OR</b> owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source (parent)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  Child additions were removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Unprocessable Entity ??? invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func unassignChildAdditions(body: C8yChildOperationsAddMultiple, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "delete")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: "Unprocessable Entity ??? invalid payload.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific child addition of a specific managed object
	/// Retrieve a specific child addition (by a given child ID) of a specific managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> MANAGE_OBJECT_READ permission on the source (parent)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the child addition is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- childId 
	///		  Unique identifier of the child object.
	public func getChildAddition(id: String, childId: String) throws -> AnyPublisher<C8yManagedObjectReference, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions/\(childId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json, application/vnd.com.nsn.cumulocity.error+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				let decoder = JSONDecoder()
				let error422 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error422)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yManagedObjectReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific child addition from its parent
	/// Remove a specific child addition (by a given child ID) from its parent (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the source (parent) <b>OR</b> owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source (parent)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A child addition was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- childId 
	///		  Unique identifier of the child object.
	public func unassignChildAddition(id: String, childId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions/\(childId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				let decoder = JSONDecoder()
				let error422 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error422)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve all child assets of a specific managed object
	/// Retrieve all child assets of a specific managed object by a given ID, or a subset based on queries.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all child assets are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- query 
	///		  Use query language to perform operations and/or filter the results. Details about the properties and supported operations can be found in [Query language](#tag/Query-language).
	/// 	- withChildren 
	///		  Determines if children with ID and name should be returned when fetching the managed object. Set it to `false` to improve query performance.
	/// 	- withChildrenCount 
	///		  When set to `true`, the returned result will contain the total number of children in the respective objects (`childAdditions`, `childAssets` and `childDevices`).
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getChildAssets(id: String, currentPage: Int? = nil, pageSize: Int? = nil, query: String? = nil, withChildren: Bool? = nil, withChildrenCount: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yManagedObjectReferenceCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = query { queryItems.append(URLQueryItem(name: "query", value: String(parameter))) }
		if let parameter = withChildren { queryItems.append(URLQueryItem(name: "withChildren", value: String(parameter))) }
		if let parameter = withChildrenCount { queryItems.append(URLQueryItem(name: "withChildrenCount", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				let decoder = JSONDecoder()
				let error422 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error422)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yManagedObjectReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child asset
	/// The possible ways to assign child objects are:
	/// 
	/// *  Assign an existing managed object (by a given child ID) as child asset of another managed object (by a given ID).
	/// *  Assign multiple existing managed objects (by given child IDs) as child assets of another managed object (by a given ID).
	/// *  Create a managed object in the inventory and assign it as a child asset to another managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ((owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source) <b>AND</b> (owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the child))
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was assigned as child asset.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func assignAsChildAsset(body: C8yChildOperationsAddOne, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child asset
	/// The possible ways to assign child objects are:
	/// 
	/// *  Assign an existing managed object (by a given child ID) as child asset of another managed object (by a given ID).
	/// *  Assign multiple existing managed objects (by given child IDs) as child assets of another managed object (by a given ID).
	/// *  Create a managed object in the inventory and assign it as a child asset to another managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ((owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source) <b>AND</b> (owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the child))
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was assigned as child asset.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func assignAsChildAsset(body: C8yChildOperationsAddMultiple, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child asset
	/// The possible ways to assign child objects are:
	/// 
	/// *  Assign an existing managed object (by a given child ID) as child asset of another managed object (by a given ID).
	/// *  Assign multiple existing managed objects (by given child IDs) as child assets of another managed object (by a given ID).
	/// *  Create a managed object in the inventory and assign it as a child asset to another managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ((owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source) <b>AND</b> (owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the child))
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was assigned as child asset.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func assignAsChildAsset(body: C8yManagedObject, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.additionParents = nil
		requestBody.lastUpdated = nil
		requestBody.childDevices = nil
		requestBody.childAssets = nil
		requestBody.creationTime = nil
		requestBody.childAdditions = nil
		requestBody.`self` = nil
		requestBody.assetParents = nil
		requestBody.deviceParents = nil
		requestBody.id = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Remove specific child assets from its parent
	/// Remove specific child assets (by given child IDs) from its parent (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the source (parent) <b>OR</b> owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source (parent)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  Child assets were removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Unprocessable Entity ??? invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func unassignChildAssets(body: C8yChildOperationsAddMultiple, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "delete")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: "Unprocessable Entity ??? invalid payload.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific child asset of a specific managed object
	/// Retrieve a specific child asset (by a given child ID) of a specific managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> MANAGE_OBJECT_READ permission on the source (parent)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the child asset is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- childId 
	///		  Unique identifier of the child object.
	public func getChildAsset(id: String, childId: String) throws -> AnyPublisher<C8yManagedObjectReference, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets/\(childId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json, application/vnd.com.nsn.cumulocity.error+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				let decoder = JSONDecoder()
				let error422 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error422)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yManagedObjectReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific child asset from its parent
	/// Remove a specific child asset (by a given child ID) from its parent (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the source (parent) <b>OR</b> owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source (parent)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A child asset was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- childId 
	///		  Unique identifier of the child object.
	public func unassignChildAsset(id: String, childId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets/\(childId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				let decoder = JSONDecoder()
				let error422 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error422)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve all child devices of a specific managed object
	/// Retrieve all child devices of a specific managed object by a given ID, or a subset based on queries.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> owner of the source <b>OR</b> MANAGE_OBJECT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all child devices are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- query 
	///		  Use query language to perform operations and/or filter the results. Details about the properties and supported operations can be found in [Query language](#tag/Query-language).
	/// 	- withChildren 
	///		  Determines if children with ID and name should be returned when fetching the managed object. Set it to `false` to improve query performance.
	/// 	- withChildrenCount 
	///		  When set to `true`, the returned result will contain the total number of children in the respective objects (`childAdditions`, `childAssets` and `childDevices`).
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getChildDevices(id: String, currentPage: Int? = nil, pageSize: Int? = nil, query: String? = nil, withChildren: Bool? = nil, withChildrenCount: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) throws -> AnyPublisher<C8yManagedObjectReferenceCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = query { queryItems.append(URLQueryItem(name: "query", value: String(parameter))) }
		if let parameter = withChildren { queryItems.append(URLQueryItem(name: "withChildren", value: String(parameter))) }
		if let parameter = withChildrenCount { queryItems.append(URLQueryItem(name: "withChildrenCount", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				let decoder = JSONDecoder()
				let error422 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error422)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yManagedObjectReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child device
	/// The possible ways to assign child objects are:
	/// 
	/// *  Assign an existing managed object (by a given child ID) as child device of another managed object (by a given ID).
	/// *  Assign multiple existing managed objects (by given child IDs) as child devices of another managed object (by a given ID).
	/// *  Create a managed object in the inventory and assign it as a child device to another managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ((owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source) <b>AND</b> (owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the child))
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was assigned as child device.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func assignAsChildDevice(body: C8yChildOperationsAddOne, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child device
	/// The possible ways to assign child objects are:
	/// 
	/// *  Assign an existing managed object (by a given child ID) as child device of another managed object (by a given ID).
	/// *  Assign multiple existing managed objects (by given child IDs) as child devices of another managed object (by a given ID).
	/// *  Create a managed object in the inventory and assign it as a child device to another managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ((owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source) <b>AND</b> (owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the child))
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was assigned as child device.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func assignAsChildDevice(body: C8yChildOperationsAddMultiple, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child device
	/// The possible ways to assign child objects are:
	/// 
	/// *  Assign an existing managed object (by a given child ID) as child device of another managed object (by a given ID).
	/// *  Assign multiple existing managed objects (by given child IDs) as child devices of another managed object (by a given ID).
	/// *  Create a managed object in the inventory and assign it as a child device to another managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> ((owner of the source <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source) <b>AND</b> (owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the child))
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A managed object was assigned as child device.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func assignAsChildDevice(body: C8yManagedObject, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.additionParents = nil
		requestBody.lastUpdated = nil
		requestBody.childDevices = nil
		requestBody.childAssets = nil
		requestBody.creationTime = nil
		requestBody.childAdditions = nil
		requestBody.`self` = nil
		requestBody.assetParents = nil
		requestBody.deviceParents = nil
		requestBody.id = nil
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Remove specific child devices from its parent
	/// Remove specific child devices (by given child IDs) from its parent (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the source (parent) <b>OR</b> owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source (parent)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  Child devices were removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Unprocessable Entity ??? invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- id 
	///		  Unique identifier of the managed object.
	public func unassignChildDevices(body: C8yChildOperationsAddMultiple, id: String) throws -> AnyPublisher<Data, Swift.Error> {
		let requestBody = body
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "delete")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: "Unprocessable Entity ??? invalid payload.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific child device of a specific managed object
	/// Retrieve a specific child device (by a given child ID) of a specific managed object (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_READ <b>OR</b> MANAGE_OBJECT_READ permission on the source (parent)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the child device is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- childId 
	///		  Unique identifier of the child object.
	public func getChildDevice(id: String, childId: String) throws -> AnyPublisher<C8yManagedObjectReference, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices/\(childId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json, application/vnd.com.nsn.cumulocity.error+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				let decoder = JSONDecoder()
				let error422 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error422)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yManagedObjectReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific child device from its parent
	/// Remove a specific child device (by a given child ID) from its parent (by a given ID).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_INVENTORY_ADMIN <b>OR</b> owner of the source (parent) <b>OR</b> owner of the child <b>OR</b> MANAGE_OBJECT_ADMIN permission on the source (parent)
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A child device was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Managed object not found.
	/// 	- 422
	///		  Invalid data was sent.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the managed object.
	/// 	- childId 
	///		  Unique identifier of the child object.
	public func unassignChildDevice(id: String, childId: String) throws -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices/\(childId)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error404)
			}
			guard httpResponse.statusCode != 422 else {
				let decoder = JSONDecoder()
				let error422 = try decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(statusCode: httpResponse.statusCode, reason: error422)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(statusCode: httpResponse.statusCode, response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
}
