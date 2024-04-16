//
// ChildOperationsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Managed objects can contain collections of references to child devices, additions and assets.
/// 
/// > **ⓘ Note** The Accept header should be provided in all POST requests, otherwise an empty response body will be returned.
public class ChildOperationsApi: AdaptableApi {

	/// Retrieve all child additions of a specific managed object
	/// 
	/// Retrieve all child additions of a specific managed object by a given ID, or a subset based on queries.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* ROLE_MANAGED_OBJECT_READ *OR* owner of the source *OR* MANAGE_OBJECT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all child additions are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Invalid data was sent.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - query:
	///     Use query language to perform operations and/or filter the results. Details about the properties and supported operations can be found in [Query language](#tag/Query-language).
	///   - withChildren:
	///     Determines if children with ID and name should be returned when fetching the managed object. Set it to `false` to improve query performance.
	///   - withChildrenCount:
	///     When set to `true`, the returned result will contain the total number of children in the respective objects (`childAdditions`, `childAssets` and `childDevices`).
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getChildAdditions(id: String, currentPage: Int? = nil, pageSize: Int? = nil, query: String? = nil, withChildren: Bool? = nil, withChildrenCount: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yManagedObjectReferenceCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "query", value: query)
			.add(queryItem: "withChildren", value: withChildren)
			.add(queryItem: "withChildrenCount", value: withChildrenCount)
			.add(queryItem: "withTotalElements", value: withTotalElements)
			.add(queryItem: "withTotalPages", value: withTotalPages)
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
		}).decode(type: C8yManagedObjectReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child addition
	/// 
	/// The possible ways to assign child objects are:
	/// 
	/// * Assign an existing managed object (by a given child ID) as child addition of another managed object (by a given ID).
	/// * Assign multiple existing managed objects (by given child IDs) as child additions of another managed object (by a given ID).
	/// * Create a managed object in the inventory and assign it as a child addition to another managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* ((owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source) *AND* (owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the child)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was assigned as child addition.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func assignAsChildAddition(body: C8yChildOperationsAddOne, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child addition
	/// 
	/// The possible ways to assign child objects are:
	/// 
	/// * Assign an existing managed object (by a given child ID) as child addition of another managed object (by a given ID).
	/// * Assign multiple existing managed objects (by given child IDs) as child additions of another managed object (by a given ID).
	/// * Create a managed object in the inventory and assign it as a child addition to another managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* ((owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source) *AND* (owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the child)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was assigned as child addition.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func assignAsChildAddition(body: C8yChildOperationsAddMultiple, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child addition
	/// 
	/// The possible ways to assign child objects are:
	/// 
	/// * Assign an existing managed object (by a given child ID) as child addition of another managed object (by a given ID).
	/// * Assign multiple existing managed objects (by given child IDs) as child additions of another managed object (by a given ID).
	/// * Create a managed object in the inventory and assign it as a child addition to another managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* ((owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source) *AND* (owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the child)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was assigned as child addition.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func assignAsChildAddition(body: C8yManagedObject, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.additionParents = nil
		requestBody.lastUpdated = nil
		requestBody.childDevices = nil
		requestBody.childAssets = nil
		requestBody.creationTime = nil
		requestBody.childAdditions = nil
		requestBody.c8yLatestMeasurements = nil
		requestBody.`self` = nil
		requestBody.assetParents = nil
		requestBody.deviceParents = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Remove specific child additions from its parent
	/// 
	/// Remove specific child additions (by given child IDs) from its parent (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* owner of the source (parent) *OR* owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the source (parent) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 Child additions were removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func unassignChildAdditions(body: C8yChildOperationsAddMultiple, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific child addition of a specific managed object
	/// 
	/// Retrieve a specific child addition (by a given child ID) of a specific managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* ROLE_MANAGED_OBJECT_READ *OR* MANAGE_OBJECT_READ permission on the source (parent) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the child addition is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Invalid data was sent.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - childId:
	///     Unique identifier of the child object.
	public func getChildAddition(id: String, childId: String) -> AnyPublisher<C8yManagedObjectReference, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions/\(childId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yManagedObjectReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific child addition from its parent
	/// 
	/// Remove a specific child addition (by a given child ID) from its parent (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* owner of the source (parent) *OR* owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the source (parent) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A child addition was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Invalid data was sent.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - childId:
	///     Unique identifier of the child object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func unassignChildAddition(id: String, childId: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAdditions/\(childId)")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve all child assets of a specific managed object
	/// 
	/// Retrieve all child assets of a specific managed object by a given ID, or a subset based on queries.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* ROLE_MANAGED_OBJECT_READ *OR* owner of the source *OR* MANAGE_OBJECT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all child assets are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Invalid data was sent.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - query:
	///     Use query language to perform operations and/or filter the results. Details about the properties and supported operations can be found in [Query language](#tag/Query-language).
	///   - withChildren:
	///     Determines if children with ID and name should be returned when fetching the managed object. Set it to `false` to improve query performance.
	///   - withChildrenCount:
	///     When set to `true`, the returned result will contain the total number of children in the respective objects (`childAdditions`, `childAssets` and `childDevices`).
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getChildAssets(id: String, currentPage: Int? = nil, pageSize: Int? = nil, query: String? = nil, withChildren: Bool? = nil, withChildrenCount: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yManagedObjectReferenceCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "query", value: query)
			.add(queryItem: "withChildren", value: withChildren)
			.add(queryItem: "withChildrenCount", value: withChildrenCount)
			.add(queryItem: "withTotalElements", value: withTotalElements)
			.add(queryItem: "withTotalPages", value: withTotalPages)
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
		}).decode(type: C8yManagedObjectReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child asset
	/// 
	/// The possible ways to assign child objects are:
	/// 
	/// * Assign an existing managed object (by a given child ID) as child asset of another managed object (by a given ID).
	/// * Assign multiple existing managed objects (by given child IDs) as child assets of another managed object (by a given ID).
	/// * Create a managed object in the inventory and assign it as a child asset to another managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* ((owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source) *AND* (owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the child)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was assigned as child asset.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func assignAsChildAsset(body: C8yChildOperationsAddOne, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child asset
	/// 
	/// The possible ways to assign child objects are:
	/// 
	/// * Assign an existing managed object (by a given child ID) as child asset of another managed object (by a given ID).
	/// * Assign multiple existing managed objects (by given child IDs) as child assets of another managed object (by a given ID).
	/// * Create a managed object in the inventory and assign it as a child asset to another managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* ((owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source) *AND* (owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the child)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was assigned as child asset.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func assignAsChildAsset(body: C8yChildOperationsAddMultiple, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child asset
	/// 
	/// The possible ways to assign child objects are:
	/// 
	/// * Assign an existing managed object (by a given child ID) as child asset of another managed object (by a given ID).
	/// * Assign multiple existing managed objects (by given child IDs) as child assets of another managed object (by a given ID).
	/// * Create a managed object in the inventory and assign it as a child asset to another managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* ((owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source) *AND* (owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the child)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was assigned as child asset.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func assignAsChildAsset(body: C8yManagedObject, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.additionParents = nil
		requestBody.lastUpdated = nil
		requestBody.childDevices = nil
		requestBody.childAssets = nil
		requestBody.creationTime = nil
		requestBody.childAdditions = nil
		requestBody.c8yLatestMeasurements = nil
		requestBody.`self` = nil
		requestBody.assetParents = nil
		requestBody.deviceParents = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Remove specific child assets from its parent
	/// 
	/// Remove specific child assets (by given child IDs) from its parent (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* owner of the source (parent) *OR* owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the source (parent) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 Child assets were removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func unassignChildAssets(body: C8yChildOperationsAddMultiple, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific child asset of a specific managed object
	/// 
	/// Retrieve a specific child asset (by a given child ID) of a specific managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* ROLE_MANAGED_OBJECT_READ *OR* MANAGE_OBJECT_READ permission on the source (parent) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the child asset is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Invalid data was sent.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - childId:
	///     Unique identifier of the child object.
	public func getChildAsset(id: String, childId: String) -> AnyPublisher<C8yManagedObjectReference, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets/\(childId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yManagedObjectReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific child asset from its parent
	/// 
	/// Remove a specific child asset (by a given child ID) from its parent (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* owner of the source (parent) *OR* owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the source (parent) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A child asset was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Invalid data was sent.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - childId:
	///     Unique identifier of the child object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func unassignChildAsset(id: String, childId: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childAssets/\(childId)")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve all child devices of a specific managed object
	/// 
	/// Retrieve all child devices of a specific managed object by a given ID, or a subset based on queries.
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* ROLE_MANAGED_OBJECT_READ *OR* owner of the source *OR* MANAGE_OBJECT_READ permission on the source 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and all child devices are sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Invalid data was sent.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - currentPage:
	///     The current page of the paginated results.
	///   - pageSize:
	///     Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	///   - query:
	///     Use query language to perform operations and/or filter the results. Details about the properties and supported operations can be found in [Query language](#tag/Query-language).
	///   - withChildren:
	///     Determines if children with ID and name should be returned when fetching the managed object. Set it to `false` to improve query performance.
	///   - withChildrenCount:
	///     When set to `true`, the returned result will contain the total number of children in the respective objects (`childAdditions`, `childAssets` and `childDevices`).
	///   - withTotalElements:
	///     When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	///   - withTotalPages:
	///     When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getChildDevices(id: String, currentPage: Int? = nil, pageSize: Int? = nil, query: String? = nil, withChildren: Bool? = nil, withChildrenCount: Bool? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yManagedObjectReferenceCollection, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(queryItem: "currentPage", value: currentPage)
			.add(queryItem: "pageSize", value: pageSize)
			.add(queryItem: "query", value: query)
			.add(queryItem: "withChildren", value: withChildren)
			.add(queryItem: "withChildrenCount", value: withChildrenCount)
			.add(queryItem: "withTotalElements", value: withTotalElements)
			.add(queryItem: "withTotalPages", value: withTotalPages)
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
		}).decode(type: C8yManagedObjectReferenceCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child device
	/// 
	/// The possible ways to assign child objects are:
	/// 
	/// * Assign an existing managed object (by a given child ID) as child device of another managed object (by a given ID).
	/// * Assign multiple existing managed objects (by given child IDs) as child devices of another managed object (by a given ID).
	/// * Create a managed object in the inventory and assign it as a child device to another managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* ((owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source) *AND* (owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the child)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was assigned as child device.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func assignAsChildDevice(body: C8yChildOperationsAddOne, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child device
	/// 
	/// The possible ways to assign child objects are:
	/// 
	/// * Assign an existing managed object (by a given child ID) as child device of another managed object (by a given ID).
	/// * Assign multiple existing managed objects (by given child IDs) as child devices of another managed object (by a given ID).
	/// * Create a managed object in the inventory and assign it as a child device to another managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* ((owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source) *AND* (owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the child)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was assigned as child device.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func assignAsChildDevice(body: C8yChildOperationsAddMultiple, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Assign a managed object as child device
	/// 
	/// The possible ways to assign child objects are:
	/// 
	/// * Assign an existing managed object (by a given child ID) as child device of another managed object (by a given ID).
	/// * Assign multiple existing managed objects (by given child IDs) as child devices of another managed object (by a given ID).
	/// * Create a managed object in the inventory and assign it as a child device to another managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* ((owner of the source *OR* MANAGE_OBJECT_ADMIN permission on the source) *AND* (owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the child)) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 201 A managed object was assigned as child device.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func assignAsChildDevice(body: C8yManagedObject, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		var requestBody = body
		requestBody.owner = nil
		requestBody.additionParents = nil
		requestBody.lastUpdated = nil
		requestBody.childDevices = nil
		requestBody.childAssets = nil
		requestBody.creationTime = nil
		requestBody.childAdditions = nil
		requestBody.c8yLatestMeasurements = nil
		requestBody.`self` = nil
		requestBody.assetParents = nil
		requestBody.deviceParents = nil
		requestBody.id = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobject+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Remove specific child devices from its parent
	/// 
	/// Remove specific child devices (by given child IDs) from its parent (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* owner of the source (parent) *OR* owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the source (parent) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 Child devices were removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Unprocessable Entity – invalid payload.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - id:
	///     Unique identifier of the managed object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func unassignChildDevices(body: C8yChildOperationsAddMultiple, id: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<Data, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.managedobjectreferencecollection+json")
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific child device of a specific managed object
	/// 
	/// Retrieve a specific child device (by a given child ID) of a specific managed object (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_READ *OR* ROLE_MANAGED_OBJECT_READ *OR* MANAGE_OBJECT_READ permission on the source (parent) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The request has succeeded and the child device is sent in the response.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Invalid data was sent.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - childId:
	///     Unique identifier of the child object.
	public func getChildDevice(id: String, childId: String) -> AnyPublisher<C8yManagedObjectReference, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices/\(childId)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.managedobjectreference+json, application/vnd.com.nsn.cumulocity.error+json")
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
		}).decode(type: C8yManagedObjectReference.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific child device from its parent
	/// 
	/// Remove a specific child device (by a given child ID) from its parent (by a given ID).
	/// 
	/// 
	/// > Tip: Required roles
	///  ROLE_INVENTORY_ADMIN *OR* ROLE_MANAGED_OBJECT_ADMIN *OR* owner of the source (parent) *OR* owner of the child *OR* MANAGE_OBJECT_ADMIN permission on the source (parent) 
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 204 A child device was removed.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// * HTTP 404 Managed object not found.
	/// * HTTP 422 Invalid data was sent.
	/// 
	/// - Parameters:
	///   - id:
	///     Unique identifier of the managed object.
	///   - childId:
	///     Unique identifier of the child object.
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func unassignChildDevice(id: String, childId: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/inventory/managedObjects/\(id)/childDevices/\(childId)")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Accept", value: "application/json")
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
		}).eraseToAnyPublisher()
	}
}
