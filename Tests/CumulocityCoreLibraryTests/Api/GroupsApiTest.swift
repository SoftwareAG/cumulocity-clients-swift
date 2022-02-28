//
// GroupsApiTest.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Combine
import XCTest

@testable import CumulocityCoreLibrary

public class GroupsApiTest: XCTestCase {
	
	class TestableGroupsApi: GroupsApi {

		override func adapt(builder: URLRequestBuilder) -> URLRequestBuilder {
			return builder.set(scheme: "https")
				.set(host: "iotaccstage2.eu-latest.cumulocity.com")
				.add(header: "Authorization", value: "Basic bW9iaWxlOm1vYmlsZTAxJA==")
		}
	}

}
