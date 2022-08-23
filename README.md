# CumulocityCoreLibrary

## Working with Xcode

The Swift Package can be opened directly in Xcode. As an alternative, the Package can be also converted into a Xcode project. Open the CumulocityCoreLibrary root directory in your terminal and run the following command:

```groovy
swift package generate-xcodeproj
```

or run the shell script located in the root directory:

```console
sh xcodeproj.sh
```
## Usage

Use the public factory to access `API` classes. The factory is available as a singleton and groups `API` classes by category.

```swift
let factory = Cumulocity.Core.shared
let api = factory.applications.applicationsApi
```

In addition, each `API` class provides a public initializer.

```swift
let api = ApplicationsApi()
```

### Configure request information

Additional request information need to be configured for each `API` class, such as HTTP scheme, host name or additional headers (i.e. Authorization header). Those information are stored in `URLRequestBuilder`.

```swift
let builder = URLRequestBuilder()
builder.set(scheme: "http")
builder.set(host: "host")
```

The factory allows to configure a default `URLRequestBuilder`. The instance hold on the factory will be used when accessing `API` classes through the factory.

```swift
let factory = Cumulocity.Core.shared
factory.requestBuilder.set(scheme: "http")
```

In addition, each `API` class provides a public initializer to pass an individual `URLRequestBuilder`.
 
```swift
let builder = URLRequestBuilder()
let api = ApplicationsApi(requestBuilder: builder)
```

### Configure URL session

The factory holds an instance of `URLSession.shared` to allow to add a `URLSessionDelegate`.

Each API class contains initializers to configure the `URLSession` used for each request. The session object can be used to register a `URLSessionDelegate`.

```swift
let factory = Cumulocity.Core.shared
factory.session.delegate = /// ...
```

The `URLSession` may also be passed to individual `API` classes through it's initializer.

```swift
let api = ApplicationsApi(session: session)
```

### Working with errors

Use `sink(receiveCompletion:receiveValue:)` to observe values received by the publisher and process them using a closure you specify. HTTP error codes will be forwarded and can be accessed using a completion handler. The client describes two error types:

```swift
enum Errors: Error {
	case undescribedError(statusCode: Int, response: HTTPURLResponse)
	case badResponseError(statusCode: Int, reason: Codable)
}
```

The type `badResponseError` is used when there is dedicated error message sent by the server. The `reason` may be a `string` or any other `Codable` instance. When there is no dedicated error message, `undescribedError` will be used.

```swift
sink(receiveCompletion: { completion in
	switch completion {
	case .finished:
		// handle completion
	case .failure(let error):
    	switch(error) {
    	case Errors.undescribedError(let statusCode, let response):
    		print(statusCode)
        case Errors.badResponseError(let statusCode, let reason):
     		print(statusCode)
       	default:
        	/// handleError(error)
      	}
	}
}, receiveValue: { data in
})
```

Error handling can be simplified by calling one of the following extension methods:

```swift
sink(receiveCompletion: { completion in
	/// access the error message
	let error = completion.error()
	/// error?.response(): HTTPURLResponse for advanced error processing
	/// error?.statusCode(): HTTP status code
	/// error?.reason(): Codable reason sent by the server
})
```

### Basic Authentication

The client sends HTTP requests with the `Authorization` header that contains the word `Basic` followed by a space and a base64-encoded string `username:password`. To include your credentials in API calls, use the `init(requestBuilder: URLRequestBuilder)` initializer and pass credentials using `URLRequestBuilder` as described below:

```swift
let builder = URLRequestBuilder()
// configure credentials using the Authorization header
builder.add(header: "Authorization", value: "")
// or pass userName and password explicitly
builder.set(authorization: "userName", password: "password")
```
