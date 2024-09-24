//
// RealtimeNotificationApi.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation
import Combine

/// > Tip: Real-time operations
/// Real-time notification services of Cumulocity IoT have their own subscription channel name format and URL. The real-time notifications are available for [Alarms](#tag/Alarm-notification-API), [Device control](#tag/Device-control-notification-API), [Events](#tag/Event-notification-API), [Inventory](#tag/Inventory-notification-API) and [Measurements](#tag/Measurement-notification-API).
/// 
/// Note that when using long-polling, all POST requests must contain the Accept header, otherwise an empty response body will be returned.All requests are sent to the <kbd>/notification/realtime</kbd> endpoint.
/// 
/// > **ⓘ Note** The long-polling interface is designed as a mechanism for custom applications to poll infrequent events from Cumulocity IoT. The long-polling interface is not designed as a mechanism to stream large data volumes (>100kB/sec) or frequent data (>50 events/sec) out of Cumulocity IoT. The usage of long-polling is not supported for such use cases.
/// > Tip: Handshake
/// A real-time notifications client initiates the connection negotiation by sending a message to the `/meta/handshake` channel. In response, the client receives a `clientId` which identifies a conversation and must be passed in every non-handshake request.
/// 
/// > **ⓘ Note** The number of parallel connections that can be opened at the same time by a single user is limited. After exceeding this limit when a new connection is created, the oldest one will be closed and the newly created one will be added in its place. This limit is configurable and managed per installation. Its default value is 10 connections per user, subscription channel and server node.
/// When using WebSockets, a property `ext` containing an authentication object must be sent. In case of basic authentication, the token is used with Base64 encoded credentials. In case of OAuth authentication, the request must have the cookie with the authorization name, holding the access token. Moreover, the XSRF token must be forwarded as part of the handshake message.
/// 
/// > Tip: Request example
/// ```http
/// POST /notification/realtime
/// Authorization: <AUTHORIZATION>
/// Content-Type: application/json
/// 
/// [
///   {
///     "channel": "/meta/handshake",
///     "version": "1.0"
///   }
/// ]
/// ```
/// > Tip: Response example
/// A successful response looks like:
/// 
/// ```json
/// [
///   {
///     "channel": "/meta/handshake",
///     "clientId": "69wzith4teyensmz6zyk516um4yum0mvp",
///     "minimumVersion": "1.0",
///     "successful": true,
///     "supportedConnectionTypes": [
///       "long-polling",
///       "smartrest-long-polling",
///       "websocket"
///     ],
///     "version": "1.0"
///   }
/// ]
/// ```
/// When an error occurs, the response looks like:
/// 
/// ```json
/// [
///   {
///     "channel": "/meta/handshake",
///     "error": "403::Handshake denied",
///     "successful": false
///   }
/// ]
/// ```
/// > Tip: Subscribe
/// A notification client can send subscribe messages and specify the desired channel to receive output messages from the Cumulocity IoT server. The client will receive the messages in succeeding connect requests.
/// 
/// Each REST API that uses the real-time notification service has its own format for channel names. See [Device control](#tag/Device-control-notification-API) for more details.
/// 
/// > Tip: Request example
/// ```http
/// POST /notification/realtime
/// Authorization: <AUTHORIZATION>
/// Content-Type: application/json
/// 
/// [
///   {
///     "channel": "/meta/subscribe",
///     "clientId": "69wzith4teyensmz6zyk516um4yum0mvp",
///     "subscription": "/alarms/<DEVICE_ID>"
///   }
/// ]
/// ```
/// > Tip: Response example
/// ```json
/// [
///   {
///     "channel": "/meta/subscribe",
///     "clientId": "69wzith4teyensmz6zyk516um4yum0mvp",
///     "subscription": "/alarms/<DEVICE_ID>",
///     "successful": true
///   }
/// ]
/// ```
/// > Tip: Unsubscribe
/// To stop receiving notifications from a channel, send a message to the channel `/meta/unsubscribe` in the same format as used during subscription.
/// 
/// > Tip: Request example
/// Example Request:
/// 
/// ```http
/// POST /notification/realtime
/// Authorization: <AUTHORIZATION>
/// Content-Type: application/json
/// 
/// [
///   {
///     "channel": "/meta/unsubscribe",
///     "clientId": "69wzith4teyensmz6zyk516um4yum0mvp",
///     "subscription": "/alarms/<DEVICE_ID>"
///   }
/// ]
/// ```
/// > Tip: Response example
/// ```json
/// [
///   {
///     "channel": "/meta/unsubscribe",
///     "subscription": "/alarms/<DEVICE_ID>",
///     "successful": true
///   }
/// ]
/// ```
/// > Tip: Connect
/// After a Bayeux client has discovered the server's capabilities with a handshake exchange and subscribed to the desired channels, a connection is established by sending a message to the `/meta/connect` channel. This message may be transported over any of the transports returned by the server in the handshake response. Requests to the connect channel must be immediately repeated after every response to receive the next batch of notifications.
/// 
/// > Tip: Request example
/// ```http
/// POST /notification/realtime
/// Authorization: <AUTHORIZATION>
/// Content-Type: application/json
/// 
/// [
///   {
///     "channel": "/meta/connect",
///     "clientId": "69wzith4teyensmz6zyk516um4yum0mvp",
///     "connectionType": "long-polling",
///     "advice": {
///       "timeout": 5400000,
///       "interval": 3000
///     }
///   }
/// ]
/// ```
/// > Tip: Response example
/// ```json
/// [
///   {
///     "channel": "/meta/connect",
///     "data": null,
///     "advice": {
///       "interval": 3000,
///       "timeout": 5400000
///     },
///     "successful": true
///   }
/// ]
/// ```
/// > Tip: Disconnect
/// To stop receiving notifications from all channels and close the conversation, send a message to the `/meta/disconnect` channel.
/// 
/// > Tip: Request example
/// ```http
/// POST /notification/realtime
/// Authorization: <AUTHORIZATION>
/// Content-Type: application/json
/// 
/// [
///   {
///     "channel": "/meta/disconnect",
///     "clientId": "69wzith4teyensmz6zyk516um4yum0mvp"
///   }
/// ]
/// ```
/// > Tip: Response example
/// ```json
/// [
///   {
///     "channel": "/meta/disconnect",
///     "successful": true
///   }
/// ]
/// ```
/// > Tip: Long-running connections
/// To keep a long-running connection alive when there are no new notifications to deliver, the server will periodically send an empty `/meta/connect` response to the client.The client should send a new `/meta/connect` request immediately after receiving such a response, to ensure that the connection remains active and future notifications are delivered.
public class RealtimeNotificationApi: AdaptableApi {

	/// Responsive communication
	/// 
	/// The Real-time notification API enables responsive communication from Cumulocity IoT over restricted networks towards clients such as web browser and mobile devices. All clients subscribe to so-called channels to receive messages. These channels are filled by Cumulocity IoT with the output of [Operations](#tag/Operations). In addition, particular system channels are used for the initial handshake with clients, subscription to channels, removal from channels and connection. The [Bayeux protocol](https://docs.cometd.org/current/reference/#_concepts_bayeux_protocol) over HTTPS or WSS is used as communication mechanism.
	/// 
	/// > Tip: Response Codes
	/// The following table gives an overview of the possible response codes and their meanings:
	/// 
	/// * HTTP 200 The operation was completed and the result is sent in the response.
	/// * HTTP 400 Unprocessable Entity ��� invalid payload.
	/// * HTTP 401 Authentication information is missing or invalid.
	/// 
	/// - Parameters:
	///   - body:
	///     
	///   - xCumulocityProcessingMode:
	///     Used to explicitly control the processing mode of the request. See [Processing mode](#processing-mode) for more details.
	public func createRealtimeNotification(body: C8yRealtimeNotification, xCumulocityProcessingMode: String? = nil) -> AnyPublisher<C8yRealtimeNotification, Error> {
		var requestBody = body
		requestBody.clientId = nil
		requestBody.data = nil
		requestBody.error = nil
		requestBody.successful = nil
		var encodedRequestBody: Data? = nil
		do {
			encodedRequestBody = try JSONEncoder().encode(requestBody)
		} catch {
			return Fail<C8yRealtimeNotification, Error>(error: error).eraseToAnyPublisher()
		}
		let builder = URLRequestBuilder()
			.set(resourcePath: "/notification/realtime")
			.set(httpMethod: "post")
			.add(header: "X-Cumulocity-Processing-Mode", value: xCumulocityProcessingMode)
			.add(header: "Content-Type", value: "application/json")
			.add(header: "Accept", value: "application/vnd.com.nsn.cumulocity.error+json, application/json")
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
		}).decode(type: C8yRealtimeNotification.self, decoder: JSONDecoder()).eraseToAnyPublisher()
	}
}
