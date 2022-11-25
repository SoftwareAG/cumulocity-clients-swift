//
// OptionsApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// API methods to retrieve the options configured in the tenant.
/// 
/// > **&#9432; Info:** The Accept header should be provided in all POST/PUT requests, otherwise an empty response body will be returned.
/// 
public class OptionsApi: AdaptableApi {

	/// Retrieve all options
	/// Retrieve all the options available on the tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_OPTION_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the options are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- currentPage 
	///		  The current page of the paginated results.
	/// 	- pageSize 
	///		  Indicates how many entries of the collection shall be returned. The upper limit for one page is 2,000 objects.
	/// 	- withTotalPages 
	///		  When set to `true`, the returned result will contain in the statistics object the total number of pages. Only applicable on [range queries](https://en.wikipedia.org/wiki/Range_query_(database)).
	public func getOptions(currentPage: Int? = nil, pageSize: Int? = nil, withTotalPages: Bool? = nil) -> AnyPublisher<C8yOptionCollection, Error> {
		var queryItems: [URLQueryItem] = []
		if let parameter = currentPage { queryItems.append(URLQueryItem(name: "currentPage", value: String(parameter))) }
		if let parameter = pageSize { queryItems.append(URLQueryItem(name: "pageSize", value: String(parameter))) }
		if let parameter = withTotalPages { queryItems.append(URLQueryItem(name: "withTotalPages", value: String(parameter))) }
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/options")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.optioncollection+json")
			.set(queryItems: queryItems)
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
		}).decode(type: C8yOptionCollection.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Create an option
	/// Create an option on your tenant.
	/// 
	/// Options are category-key-value tuples which store tenant configurations. Some categories of options allow the creation of new ones, while others are limited to predefined set of keys.
	/// 
	/// Any option of any tenant can be defined as "non-editable" by the "management" tenant; once done, any PUT or DELETE requests made on that option by the tenant owner will result in a 403 error (Unauthorized).
	/// 
	/// ### Default option categories
	/// 
	/// **access.control**
	/// 
	/// | Key |	Default value |	Predefined | Description |
	/// |--|--|--|--|
	/// | allow.origin | * | Yes | Comma separated list of domains allowed for execution of CORS. Wildcards are allowed (for example, `*.cumuclocity.com`) |
	/// 
	/// **alarm.type.mapping**
	/// 
	/// | Key  |	Predefined | Description |
	/// |--|--|--|
	/// | &lt;ALARM_TYPE> | No | Overrides the severity and alarm text for the alarm with type &lt;ALARM_TYPE>. The severity and text are specified as `<ALARM_SEVERITY>\|<ALARM_TEXT>`. If either part is empty, the value will not be overridden. If the severity is NONE, the alarm will be suppressed. Example: `"CRITICAL\|temperature too high"`|
	/// 
	/// ### Encrypted credentials
	/// 
	/// Adding a "credentials." prefix to the `key` will make the `value` of the option encrypted. When the option is  sent to a microservice, the "credentials." prefix is removed and the `value` is decrypted. For example:
	/// 
	/// ```json
	/// {
	///   "category": "secrets",
	///   "key": "credentials.mykey",
	///   "value": "myvalue"
	/// }
	/// ```
	/// 
	/// In that particular example, the request will contain an additional header `"Mykey": "myvalue"`.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_OPTION_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  An option was created.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func createOption(body: C8yOption, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yOption, Error> {
		var requestBody = body
		requestBody.`self` = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yOption, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/options")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: String(describing: xCumulocityProcessingMode))
			.add(header: "Content-Type", value: "application/vnd.com.nsn.cumulocity.option+json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.option+json")
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
		}).decode(type: C8yOption.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve all options by category
	/// Retrieve all the options (by a specified category) on your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_OPTION_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the options are sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// - Parameters:
	/// 	- category 
	///		  The category of the options.
	public func getOptionsByCategory(category: String) -> AnyPublisher<C8yCategoryOptions, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/options/\(category)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.option+json")
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
		}).decode(type: C8yCategoryOptions.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update options by category
	/// Update one or more options (by a specified category) on your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_OPTION_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  A collection of options was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- category 
	///		  The category of the options.
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateOptionsByCategory(body: C8yCategoryOptions, category: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yCategoryOptions, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yCategoryOptions, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/options/\(category)")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: String(describing: xCumulocityProcessingMode))
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.option+json")
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
		}).decode(type: C8yCategoryOptions.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Retrieve a specific option
	/// Retrieve a specific option (by a given category and key) on your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_OPTION_MANAGEMENT_READ
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  The request has succeeded and the option is sent in the response.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Option not found.
	/// - Parameters:
	/// 	- category 
	///		  The category of the options.
	/// 	- key 
	///		  The key of an option.
	public func getOption(category: String, key: String) -> AnyPublisher<C8yOption, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/options/\(category)/\(key)")
			.set(httpMethod: "get")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.option+json")
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
		}).decode(type: C8yOption.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Update a specific option
	/// Update the value of a specific option (by a given category and key) on your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_OPTION_MANAGEMENT_ADMIN <b>AND</b> the option is editable
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 200
	///		  An option was updated.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Option not found.
	/// 	- 422
	///		  Unprocessable Entity – invalid payload.
	/// - Parameters:
	/// 	- body 
	/// 	- category 
	///		  The category of the options.
	/// 	- key 
	///		  The key of an option.
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func updateOption(body: C8yCategoryKeyOption, category: String, key: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yOption, Error> {
		let requestBody = body
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yOption, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/options/\(category)/\(key)")
			.set(httpMethod: "put")
			.add(header: "X-Cumulocity-Processing-Mode", value: String(describing: xCumulocityProcessingMode))
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/vnd.com.nsn.cumulocity.option+json")
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
		}).decode(type: C8yOption.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
	
	/// Remove a specific option
	/// Remove a specific option (by a given category and key) on your tenant.
	/// 
	/// <section><h5>Required roles</h5>
	/// ROLE_OPTION_MANAGEMENT_ADMIN
	/// </section>
	/// 
	/// The following table gives an overview of the possible response codes and their meanings.
	/// - Returns:
	/// 	- 204
	///		  An option was removed.
	/// 	- 401
	///		  Authentication information is missing or invalid.
	/// 	- 404
	///		  Option not found.
	/// - Parameters:
	/// 	- category 
	///		  The category of the options.
	/// 	- key 
	///		  The key of an option.
	/// 	- xCumulocityProcessingMode 
	///		  Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func deleteOption(category: String, key: String, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<Data, Error> {
		let builder = URLRequestBuilder()
			.set(resourcePath: "/tenant/options/\(category)/\(key)")
			.set(httpMethod: "delete")
			.add(header: "X-Cumulocity-Processing-Mode", value: String(describing: xCumulocityProcessingMode))
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
