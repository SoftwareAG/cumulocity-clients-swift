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

### Configure request information

Additional information can be passed to each API class using the `URLRequestBuilder`. It provides dedicated methods to configure URL scheme, host name or additional headers:

```swift
let builder = URLRequestBuilder()
builder.set(scheme: "http")
builder.set(host: "host")
```

After configuring use the `builder` as argument for creating service instances:

```swift
let service = SystemOptionsApi(requestBuilder: builder)
```

### Configure URL session

Each API class contains initializers to configure the `URLSession` used for each request. The session object can be used to register a `URLSessionDelegate`.

```swift
let session = URLSession.shared
let service = SystemOptionsApi(session: session)
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
