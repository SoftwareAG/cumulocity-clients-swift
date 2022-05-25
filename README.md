# CumulocityCoreLibrary

## Module Import

## Convert to a Xcode Project

You can also convert the generated sources into a Xcode project. Open the CumulocityCoreLibrary root directory in your terminal and run the following command:

```groovy
swift package generate-xcodeproj
```

or run the attached shell script:

```console
sh xcodeproj.sh
```

## Usage

A `URLRequestBuilder` is required to initialise any API class. It stores basic information - like the URL scheme, host name or additional headers - to be used with every API call.

```swift
let builder = URLRequestBuilder()
builder.set(scheme: "http")
builder.set(host: "host")
```

After configuring use the `builder` as argument for creating service instances:

```swift
let service = SystemOptionsApi(requestBuilder: builder)
```

## Basic Authentication

The client sends HTTP requests with the `Authorization` header that contains the word `Basic` word followed by a space and a base64-encoded string `username:password`.

To include your credentials automatically in API calls, use the `init(requestBuilder: URLRequestBuilder)` and use the passed `URLRequestBuilder` to provide credentials. Either provide the authorization header directly or use the `set(authorization:String, password: String)`method.

```swift
let builder = URLRequestBuilder()
builder.add(header: "Authorization", value: "")
builder.set(authorization: "userName", password: "password")
```

_________________

These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.
