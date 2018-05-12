# Genesis

According to [Apple](https://swift.org/package-manager/):
> The Swift Package Manager is a tool for managing the distribution of Swift Code. It's integrated with the 
> Swift build system to automate the process of downloading, compiling and linking dependencies. 

Simply put, SPM : Swift ∷ NPM : JavaScript. The Swift Package Manager (SPM) is included in Swift 3.0 and 
above. This repository serves as my personal documentation for how to make the best use of Swift Package 
Manager. As such, it may become outdated as things in Swiftverse evolve.

# Terminology

## Module
Each module specifies a namespace and enforces access controls on parts of the code that can be used outside 
the module. Aside from the handful of system-provided modules, such as Darwin on macOS or Glibc on Linux, most 
of your source code will have third-party dependencies that will need to be downloaded and built in order to 
be used.

You can have your entire code in one module that you write, or you could import other modules as dependencies.

## Package
A package consists of Swift source files and a manifest file called `Package.swift`. `Package.swift` defines
the package's name, targets and dependencies using the `PackageDescription` module.

### Target
Every Swift package has one or more **targets**. Each target specifies a product to build and contains the
instructions for building the product from a set of files in a project. Projects can contain one or more 
targets, each of which produces one product. If a target requires the output of another target in order to 
build, the first target is said to depend upon the second.

Targets are usually used for different distrubution of the same project. For example, you could have two 
targets a `release` target, and a `beta` target that has extra testing features. You can pick and
choose which classes or resources are added to which target. You can also add tests, using a third target
and call it `Tests`. 

### Product
A product may be either an *executable* or a *library*. An executable is a Swift program that can be run by 
the operating system. A library contains a module that can be imported by other Swift modules. A target is 
available to other packages only if it is a part of some product.

# The Package Manifest

The `Package.swift` manifest file declares a Swift package using the `PackageDescription` module.

```swift
import PackageDescription

let package = Package(...)
```

The `Package` initialiser requires the following parameters:
- `name` of the package
- `products` vended by the package
- external package `dependencies`
- list of `targets` in the package
- `swiftLanguageVersions` supported by the package

For System Module Packages, two additional parameters are required:
- `pkgConfig`: Name of the pkg-config (.pc) file to get the additional flags for system modules.
- `providers`: Defines hints to display for installing system modules.

### `name`
Name of the package. This is the only requirement for a manifest to be *valid*. But one or more targets are 
required to build a package.

```swift
import PackageDescription

let package = Package(
    name: "Genesis"
)
``` 

### `targets`
Declares the targets in the package.

```swift
import PackageDescription

let package = Package(
    name: "Genesis",
    targets: [
        .target(name: "Genesis", dependencies: ["GenesisAPI"]),
        .target(name: "GenesisAPI", dependencies: []),
        .testTarget(name: "GenesisTests", dependencies: ["Genesis"])
    ]
)
``` 

### `products`
A list of all the products that are vended by the package. Two types of products are supported:
    
- `library`: A library product contains library targets. It should contain the targets which are supposed 
    to be used by other packages, i.e. the public API of a library package. The library product can be 
    declared static, dynamic or automatic. It is recommended to use automatic.

- `executable`: An executable product is used to vend an executable target. This should only be used if
    the executable needs to be made available to other packages.

```swift
import PackageDescription

let package = Package(
    name: "Genesis",
    products: [
        .executable(name: "Genesis", targets: ["Genesis"]),
        .library(name: "GenesisLib", targets: ["GenesisAPI"]),
    ],
    targets: [
        .target(name: "Genesis", dependencies: ["GenesisAPI"]),
        .target(name: "GenesisAPI", dependencies: []),
        .testTarget(name: "GenesisTests", dependencies: ["Genesis"])
    ]
)
```

### `dependencies`
List of packages that the package depends on. Package version can be defined in a variety of ways:

- `from: "1.2.3"` ≣ 1.2.3 ..< 2.0.0 
- `.upToNextMajor(from: "1.2.3")` ≣ 1.2.3 ..< 2.0.0
- `.upToNextMinor(from: "1.2.3")` ≣ 1.2.3 ..< 1.3.0
- `.exact("1.2.3")` ≣ 1.2.3
- `"1.2.3"..<"2.3.4"` ≣ 1.2.3 ..< 2.3.4
- `"1.2.3"..."2.3.4"` ≣ 1.2.3 ... 2.3.4
- `.branch("master")` pulls the latest commit to the `master` branch
- `.revision("e74b013ljslkjdfslecncslkeae")` pulls the commit identified by the given hash

```swift
import PackageDescription

let package = Package(
    name: "Genesis",
    products: [
        .executable(name: "Genesis", targets: ["Genesis"]),
        .library(name: "GenesisLib", targets: ["GenesisAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Genesis", dependencies: ["GenesisAPI"]),
        .target(name: "GenesisAPI", dependencies: ["Kitura"]),
        .testTarget(name: "GenesisTests", dependencies: ["Genesis"])
    ]
)
```

### `swiftLanguageVersions`
Specifies the set of supported Swift language versions. E.g if set to `[3]` both Swift 3 and 4 compilers will
select Swift 3, and if set to `[3, 4]`, Swift 3 compiler will select `3` and Swift 4 compiler will select `4`.
If the package doesn't specify any Swift language versions, the language version to be used will match the
major version of the package's Swift tools version.

The Swift tools version of a package is specified at the top of `Package.swift` as a comment, like so,
`// swift-tools-version: 4.0.2`.

```swift
// swift-tools-version: 4.0.2

import PackageDescription

let package = Package(
    name: "Genesis",
    products: [
        .executable(name: "Genesis", targets: ["Genesis"]),
        .library(name: "GenesisLib", targets: ["GenesisAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Genesis", dependencies: ["GenesisAPI"]),
        .target(name: "GenesisAPI", dependencies: ["Kitura"]),
        .testTarget(name: "GenesisTests", dependencies: ["Genesis"])
    ]
)
```

# Creating Packages

Create an empty project folder and run the following command create a Swift package.

```bash
# Create a library package
$ swift package init

# Create an executable package
$ swift package init --type executable
```

# Building a package
```bash
$ swift build
```
By default, running `swift build` will build in debug configuration. To build in release mode, use 
`swift build -c release`. The build artifacts are located in directory called `debug` or `release` under 
build folder.

# Publish a Package
To publish a package, you just have to initialise a git repository and create a semantic version tag.

```bash
$ git init
$ git add .
$ git remote add origin <GitHub repo URL here>
$ git commit -m "Initial commit"
$ git tag 1.0.0
$ git push origin master --tags
```