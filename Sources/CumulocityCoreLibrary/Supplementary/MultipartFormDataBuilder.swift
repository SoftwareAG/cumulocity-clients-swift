//
// MultipartFormDataBuilder.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

class MultipartFormDataBuilder {

    private let boundary: String = UUID().uuidString
    private var httpBody = NSMutableData()
    let contentType: String
    
    init() {
        contentType = "multipart/form-data; boundary=\(boundary)"
    }

    func addBodyPart(named name: String, data: Data, mimeType: String) throws {
        let lineBreak = "\r\n"
        let boundaryPrefix = "--\(boundary)\(lineBreak)"
        httpBody.append(boundaryPrefix)
        httpBody.append("Content-Disposition: form-data; name=\"\(name)\"\(lineBreak)")
        httpBody.append("Content-Type: \(mimeType)\"\(lineBreak)")
        httpBody.append(data)
        httpBody.append("\(lineBreak)")
    }

	func addBodyPart<C: Codable>(named name: String, data: C, mimeType: String) throws {
		try self.addBodyPart(named: name, data: try JSONEncoder().encode(data), mimeType: mimeType)
	}

    public func build() -> Data {
        httpBody.append("--\(boundary)--\r\n")
        return httpBody as Data
    }
}

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
