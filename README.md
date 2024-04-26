# InAppTools

![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)
![CocoaPods compatible](https://img.shields.io/badge/Cocoapods-compatible-4BC51D.svg?style=flat)
![License: MIT](https://img.shields.io/badge/License-MIT-green)

InAppTools is a library written in swift that let's you easily add mobile users to your mailing lists.

## Prerequisites

To use InAppTools, you'll first need to generate an APIKEY. To generate one, sign into https://inapptools.com and select Profile. Then, under "API Keys", click "New API Key" and follow the instructions.

## Requirements

- Xcode 14 / Swift 5.5
- iOS >= 15.0


## Usage

### Adding a user to your mailing list

To get the id of your mailing list, sign into https://inapptools.com and copy the `List ID` of your mailing list.

First, import the library:

```
import InAppTools
```

Then, once the user has entered their email address:

```
    let member = try await MailingList(apiKey: apiKey).subscribe(listId: listId, email: email)
```

If the `subscribe` method throws an exception, the most likely causes are an incorrect apiKey, or an incorrect listId. 
Calling `subscribe` with an email that's already subscribed to your mailing list will not cause an error.

## Installation

### Swift Package Manager

To install InAppTools using [Swift Package Manager](https://swift.org/package-manager/) using Xcode:

1. In Xcode, select "File" -> "Add Package Dependencies..."
2. Enter https://github.com/dhennessy/inapptools-ios-sdk.git

or you can add the following dependency to your `Package.swift`:

```
.package(url: "https://github.com/dhennessy/inapptools-ios-sdk.git", from: "0.1.0")
```

### Cocoapods

Add the following line to your Podfile:

```
pod 'InAppTools'
```

## Release Notes

See [CHANGELOG.md](https://github.com/dhennessy/inapptools-ios-sdk/blob/main/CHANGELOG.md) for a list of changes.

## License

InAppTools is available under the MIT license. See the LICENSE file for more info.

