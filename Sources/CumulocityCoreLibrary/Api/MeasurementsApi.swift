//
// MeasurementsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// Measurements are produced by reading sensor values. In some cases, this data is read in static intervals and sent to the platform (for example, temperature sensors or electrical meters). In other cases, the data is read on demand or at irregular intervals (for example, health devices such as weight scales). Regardless what kind of protocol the device supports, the agent is responsible for converting it into a "push" protocol by uploading data to Cumulocity IoT.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST requests, otherwise an empty response body will be returned.
/// 
public class MeasurementsApi: AdaptableApi {

	/// Retrieve all measurements
	/// Retrieve all measurements on your tenant, or a specific subset based on queries.
	/// 
	/// In case of executing [range queries](https://en.wikipedia.org/wiki/Range_query_(database)) between an upper and lower boundary, for example, querying using `dateFrom`–`dateTo`, the oldest registered measurements are returned first. It is possible to change the order using the query parameter `revert=true`.
	/// 
	/// For large measurement collections, querying older records without filters can be slow as the server needs to scan from the beginning of the input results set before beginning to return the results. For cases when older measurements should be retrieved, it is recommended to narrow the scope by using range queries based on the time stamp reported by a device. The scope of query can also be reduced significantly when a source device is provided.
	/// 
	/// Review [Measurements Specifics](#tag/Measurements-Specifics) for details about data streaming and response formats.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_MEASUREMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and all measurements are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- dateFrom 
	///		  Start date or date and time of the measurement.
	/// 	- dateTo 
	///		  End date or date and time of the measurement.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- revert 
	///		  If you are using a range query (that is, at least one of the `dateFrom` or `dateTo` parameters is included in the request), then setting `revert=true` will sort the results by the latest measurements first. By default, the results are sorted by the oldest measurements first. 
	/// 	- source 
	///		  The managed object ID to which the measurement is associated.
	/// 	- type 
	///		  The type of measurement to search for.
	/// 	- valueFragmentSeries 
	///		  The specific series to search for.
	/// 	- valueFragmentType 
	///		  A characteristic which identifies the measurement.
	/// 	- withTotalElements 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of elements. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getMeasurements(currentPage: Int? = nil, dateFrom: String? = nil, dateTo: String? = nil, pageSize: Int? = nil, revert: Bool? = nil, source: String? = nil, type: String? = nil, valueFragmentSeries: String? = nil, valueFragmentType: String? = nil, withTotalElements: Bool? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yMeasurementCollection, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter))) }
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = revert { queryItems.append(URLQueryItem(name: "revert", value: String(parameter))) }
		if let parameter = source { queryItems.append(URLQueryItem(name: "source", value: String(parameter))) }
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter))) }
		if let parameter = valueFragmentSeries { queryItems.append(URLQueryItem(name: "valueFragmentSeries", value: String(parameter))) }
		if let parameter = valueFragmentType { queryItems.append(URLQueryItem(name: "valueFragmentType", value: String(parameter))) }
		if let parameter = withTotalElements { queryItems.append(URLQueryItem(name: "withTotalElements", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/measurement/measurements")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.measurementcollection+json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yMeasurementCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a measurement
	/// A measurement must be associated with a source (managed object) identified by ID, and must specify the type of measurement and the time when it was measured by the device (for example, a thermometer).
	/// 
	/// Each measurement fragment is an object (for example, `c8y_Steam`) containing the actual measurements as properties. The property name represents the name of the measurement (for example, `Temperature`) and it contains two properties:
	/// 
	/// *   `value` - The value of the individual measurement. The maximum precision for floating point numbers is 64-bit IEEE 754. For integers it's a 64-bit two's complement integer.
	/// *   `unit` - The unit of the measurements.
	/// 
	/// Review the [System of units](#section/System-of-units) section for details about the conversions of units. Also review the [Naming conventions of fragments](https://cumulocity.com/guides/concepts/domain-model/#naming-conventions-of-fragments) in the Concepts guide.
	/// 
	/// The example below uses `c8y_Steam` in the request body to illustrate a fragment for recording temperature measurements.
	/// 
	/// > **⚠️ Important:** Property names used for fragment and series must not contain whitespaces nor the special characters `. , * [ ] ( ) @ $`. This is required to ensure a correct processing and visualization of measurement series on UI graphs.
	/// 
	/// ### Create multiple measurements
	/// 
	/// It is also possible to create multiple measurements at once by sending a `measurements` array containing all the measurements to be created. The content type must be `application/vnd.com.nsn.cumulocity.measurementcollection+json`.
	/// 
	/// > **&#9432; Info:** For more details about fragments with specific meanings, review the sections [Device management library](#section/Device-management-library) and [Sensor library](#section/Sensor-library).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_MEASUREMENT_ADMIN <b>OR</b> owner of the source <b>OR</b> MEASUREMENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A measurement was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	public func createMeasurement(body: C8yMeasurement) -> AnyPublisher<C8yMeasurement, Swift.Error> {
		var requestBody = body
		requestBody.`self` = nil
		requestBody.id = nil
		requestBody.source?.`self` = nil
		let encodedRequestBody = try? JSONEncoder().encode(requestBody)
		let builder = URLRequestBuilder()
			.set(resourcePath: "/measurement/measurements")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.measurement+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.measurement+json, application/vnd.com.nsn.cumulocity.measurementcollection+json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Not authorized to perform this operation.")
			}
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Unprocessable Entity – invalid payload.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yMeasurement.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create a measurement
	/// A measurement must be associated with a source (managed object) identified by ID, and must specify the type of measurement and the time when it was measured by the device (for example, a thermometer).
	/// 
	/// Each measurement fragment is an object (for example, `c8y_Steam`) containing the actual measurements as properties. The property name represents the name of the measurement (for example, `Temperature`) and it contains two properties:
	/// 
	/// *   `value` - The value of the individual measurement. The maximum precision for floating point numbers is 64-bit IEEE 754. For integers it's a 64-bit two's complement integer.
	/// *   `unit` - The unit of the measurements.
	/// 
	/// Review the [System of units](#section/System-of-units) section for details about the conversions of units. Also review the [Naming conventions of fragments](https://cumulocity.com/guides/concepts/domain-model/#naming-conventions-of-fragments) in the Concepts guide.
	/// 
	/// The example below uses `c8y_Steam` in the request body to illustrate a fragment for recording temperature measurements.
	/// 
	/// > **⚠️ Important:** Property names used for fragment and series must not contain whitespaces nor the special characters `. , * [ ] ( ) @ $`. This is required to ensure a correct processing and visualization of measurement series on UI graphs.
	/// 
	/// ### Create multiple measurements
	/// 
	/// It is also possible to create multiple measurements at once by sending a `measurements` array containing all the measurements to be created. The content type must be `application/vnd.com.nsn.cumulocity.measurementcollection+json`.
	/// 
	/// > **&#9432; Info:** For more details about fragments with specific meanings, review the sections [Device management library](#section/Device-management-library) and [Sensor library](#section/Sensor-library).
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_MEASUREMENT_ADMIN <b>OR</b> owner of the source <b>OR</b> MEASUREMENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 201
	///		  A measurement was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	public func createMeasurement(body: C8yMeasurementCollection) -> AnyPublisher<C8yMeasurementCollection, Swift.Error> {
		var requestBody = body
		requestBody.next = nil
		requestBody.prev = nil
		requestBody.`self` = nil
		requestBody.statistics = nil
		let encodedRequestBody = try? JSONEncoder().encode(requestBody)
		let builder = URLRequestBuilder()
			.set(resourcePath: "/measurement/measurements")
			.set(httpMethod: "post")
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.measurementcollection+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.measurement+json, application/vnd.com.nsn.cumulocity.measurementcollection+json")
			.set(httpBody: encodedRequestBody)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Not authorized to perform this operation.")
			}
			guard httpResponse.statusCode != 422 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Unprocessable Entity – invalid payload.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yMeasurementCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove measurement collections
	/// Remove measurement collections specified by query parameters.
	/// 
	/// DELETE requests are not synchronous. The response could be returned before the delete request has been completed. This may happen especially when there are a lot of measurements to be deleted.
	/// 
	/// > **⚠️ Important:** Note that it is possible to call this endpoint without providing any parameter - it may result in deleting all measurements and it is not recommended.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_MEASUREMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A collection of measurements was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// - Parameters:
	/// 	- dateFrom 
	///		  Start date or date and time of the measurement.
	/// 	- dateTo 
	///		  End date or date and time of the measurement.
	/// 	- fragmentType 
	///		  A characteristic which identifies a managed object or event, for example, geolocation, electricity sensor, relay state.
	/// 	- source 
	///		  The managed object ID to which the measurement is associated.
	/// 	- type 
	///		  The type of measurement to search for.
	public func deleteMeasurements(dateFrom: String? = nil, dateTo: String? = nil, fragmentType: String? = nil, source: String? = nil, type: String? = nil) -> AnyPublisher<Data, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = dateFrom { queryItems.append(URLQueryItem(name: "dateFrom", value: String(parameter))) }
		if let parameter = dateTo { queryItems.append(URLQueryItem(name: "dateTo", value: String(parameter))) }
		if let parameter = fragmentType { queryItems.append(URLQueryItem(name: "fragmentType", value: String(parameter))) }
		if let parameter = source { queryItems.append(URLQueryItem(name: "source", value: String(parameter))) }
		if let parameter = type { queryItems.append(URLQueryItem(name: "type", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/measurement/measurements")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Not authorized to perform this operation.")
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific measurement
	/// Retrieve a specific measurement by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_MEASUREMENT_READ <b>OR</b> owner of the source <b>OR</b> MEASUREMENT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the measurement is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Measurement not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the measurement.
	public func getMeasurement(id: String) -> AnyPublisher<C8yMeasurement, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/measurement/measurements/\(id)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.measurement+json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yMeasurement.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific measurement
	/// Remove a specific measurement by a given ID.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_MEASUREMENT_ADMIN <b>OR</b> owner of the source <b>OR</b> MEASUREMENT_ADMIN permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  A measurement was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 403
	///		  Not authorized to perform this operation.
	/// 	- 404
	///		  Measurement not found.
	/// - Parameters:
	/// 	- id 
	///		  Unique identifier of the measurement.
	public func deleteMeasurement(id: String) -> AnyPublisher<Data, Swift.Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/measurement/measurements/\(id)")
			.set(httpMethod: "delete")
			.add(header: "Accept", value: "application/json")
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			guard httpResponse.statusCode != 403 else {
				throw Errors.badResponseError(response: httpResponse, reason: "Not authorized to perform this operation.")
			}
			guard httpResponse.statusCode != 404 else {
				let decoder = JSONDecoder()
				let error404 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error404)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).eraseToAnyPublisher()
	}
	
	/// Retrieve a list of series and their values
	/// Retrieve a list of series (all or only those matching the specified names) and their values within a given period of a specific managed object (source).<br>
	/// A series is any fragment in measurement that contains a `value` property.
	/// 
	/// It is possible to fetch aggregated results using the `aggregationType` parameter. If the aggregation is not specified, the result will contain no more than 5000 values.
	/// 
	/// > **⚠️ Important:** For the aggregation to be done correctly, a device shall always use the same time zone when it sends dates.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_MEASUREMENT_READ <b>OR</b> owner of the source <b>OR</b> MEASUREMENT_READ permission on the source
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the series are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- aggregationType 
	///		  Fetch aggregated results as specified.
	/// 	- dateFrom 
	///		  Start date or date and time of the measurement.
	/// 	- dateTo 
	///		  End date or date and time of the measurement.
	/// 	- revert 
	///		  If you are using a range query (that is, at least one of the `dateFrom` or `dateTo` parameters is included in the request), then setting `revert=true` will sort the results by the latest measurements first. By default, the results are sorted by the oldest measurements first. 
	/// 	- series 
	///		  The specific series to search for.
	/// 	- source 
	///		  The managed object ID to which the measurement is associated.
	public func getMeasurementSeries(aggregationType: String? = nil, dateFrom: String, dateTo: String, revert: Bool? = nil, series: [String]? = nil, source: String) -> AnyPublisher<C8yMeasurementSeries, Swift.Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = aggregationType { queryItems.append(URLQueryItem(name: "aggregationType", value: String(parameter))) }
		queryItems.append(URLQueryItem(name: "dateFrom", value: String(dateFrom)))
		queryItems.append(URLQueryItem(name: "dateTo", value: String(dateTo)))
		if let parameter = revert { queryItems.append(URLQueryItem(name: "revert", value: String(parameter))) }
		if let parameter = series { parameter.forEach{ p in queryItems.append(URLQueryItem(name: "series", value: p)) } }
		queryItems.append(URLQueryItem(name: "source", value: String(source)))
		let builder = URLRequestBuilder()
			.set(resourcePath: "/measurement/measurements/series")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
			.set(queryItems: queryItems)
		return self.session.dataTaskPublisher(for: adapt(builder: builder).build()).tryMap({ element -> Data in
			guard let httpResponse = element.response as? HTTPURLResponse else {
				throw URLError(.badServerResponse)
			}
			guard httpResponse.statusCode != 401 else {
				let decoder = JSONDecoder()
				let error401 = try! decoder.decode(C8yError.self, from: element.data)
				throw Errors.badResponseError(response: httpResponse, reason: error401)
			}
			// generic error fallback
			guard (200..<300) ~= httpResponse.statusCode else {
				throw Errors.undescribedError(response: httpResponse)
			}
			
			return element.data
		}).decode(type: C8yMeasurementSeries.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
