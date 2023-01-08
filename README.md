# Swift Package Manager

According to [Apple](https://swift.org/package-manager/):
> The Swift Package Manager is a tool for managing the distribution of Swift Code. It's integrated with the 
> Swift build system to automate the process of downloading, compiling and linking dependencies. 

Simply put, SPM : Swift ∷ NPM : JavaScript. The Swift Package Manager (SPM) is included in Swift 3.0 and 
above. This repository serves as my personal documentation for how to make the best use of Swift Package 
Manager. As such, it may become outdated as things in Swiftverse evolve.

## Terminology

### Module
Libraries, frameworks and Swift packages are all types of modules and enable code separation and reusability.

Each module specifies a namespace and enforces access controls on parts of the code that can be used outside 
the module. Aside from the handful of system-provided modules, such as Darwin on macOS or Glibc on Linux, most 
of your source code will have third-party dependencies that will need to be downloaded and built in order to 
be used.

You can have your entire code in one module that you write, or you could import other modules as dependencies.

### Package
A package consists of Swift source files and a manifest file called `Package.swift`. `Package.swift` defines
the package's name, targets and dependencies using the `PackageDescription` module.

### Target
Every Swift package has one or more **targets**. A target is an actual module you are going to import into
your code. It's represented in package directory structure as a folder containing all the target files.

Targets are lower level for your package architecture, and the libraries are the top level packaged good that's
distributed. Library is what you link to a project and its targets are what you import into your files.

### Product
A product may be either an *executable* or a *library*. An executable is a Swift program that can be run by 
the operating system. A library contains a module that can be imported by other Swift modules. A target is 
available to other packages only if it is a part of some product.

In iOS there are two types of libraries – **dynamic** and **static** – defined on the basis of how they are
linked to the app. Static libraries are linked during compile time and have an `.a` extension. They become
part of your app and increase build time and package size. Dynamic libraries are linked during runtime and
have a negative influence on startup time. Their extension is `.dylib`. They can be replaced without shipping
a new build and thus they are not supported in iOS besides Apple's own system libraries. 

## The Package Manifest

The `Package.swift` manifest file declares a Swift package using the `PackageDescription` module.

```swift
// swift-tools-version:5.7
```
This line indicates the minimum Swift Tools version your package manifest will
work with.

```swift
import PackageDescription

let package = Package(...)
```
The main class in `PackageDescription` is `Package`. The `Package.swift` manifest
file is responsible for initialising a `Package` object which holds configuration
information for your Swift package.

### `name`
Name of the package. This is the only requirement for a manifest to be *valid*.
But one or more targets are required to build a package. Package name must be
globally unique. This is a pain point in Swift land as of writing, and the current
convention is to use a prefix of some kind. I use AL (Animesh Ltd) in all my
package names. 

```swift
import PackageDescription

let package = Package(
    name: "ALAarambh"
)
``` 

### `platforms`
Swift supports five platforms – iOS, macOS, tvOS, watchOS and Linux. The `platforms`
property contains the list of **minimum** supported versions for different platforms.

Do note that `platforms` does **not** describe **supported** platforms. All
platforms are supported. If a platform is not listed in `platforms` property then
the actual minimum version will be the first version that supports Swift. For
instance, if we don't add an iOS version to the list, the minimum version will
be iOS 8.

It is better to try and set minimum versions as lower as we can. Best to avoid
setting a minimum altogether. The minimum version is a constraint that can make
it difficult to integrate other packages into the project.

```swift
platforms: [
  .macOS(.v10_13),
  .iOS(.v11),
  .tvOS(.v11),
  .watchOS(.v4),
  .custom("Ubuntu", versionString: "22.04")
],
```

### `targets`
Declares the targets in the package.

```swift
targets: [
  .executableTarget(name: "App", dependencies: ["Aarambh"]),
  .target(name: "Aarambh", dependencies: []),
  .testTarget(name: "AarambhTests", dependencies: ["Aarambh"])
]
``` 

### `products`
A list of all the products that are vended by the package. Two types of products are supported:
    
- `library`: A library product contains library targets. It should contain the targets which are supposed 
    to be used by other packages, i.e. the public API of a library package. The library product can be 
    declared static, dynamic or automatic. It is recommended to use automatic.

- `executable`: An executable product is used to vend an executable target. This should only be used if
    the executable needs to be made available to other packages.

```swift
products: [
  .executable(name: "App", targets: ["App"]),
  .library(name: "Aarambh", targets: ["Aarambh"])
],
```

### `dependencies`
List of packages that the package depends on.

```swift
dependencies: [
  .package(url: "https://github.com/AnimeshLtd/Some-Package", from: "1.0.0"),
]
```

## Creating Packages from scratch

Create an empty project folder and run the following command create a Swift package.

```bash
# Create a library package
$ swift package init

# Create an executable package
$ swift package init --type executable
```

### Building a package

```bash
$ swift build
```
By default, running `swift build` will build in debug configuration. To build in release mode, use 
`swift build -c release`. The build artifacts are located in directory called `debug` or `release` under 
build folder.

### Publish a Package
To publish a package, you just have to initialise a git repository and create a semantic version tag.

```bash
$ git init
$ git add .
$ git remote add origin <GitHub repo URL here>
$ git commit -m "Initial commit"
$ git tag 1.0.0
$ git push origin master --tags
```
