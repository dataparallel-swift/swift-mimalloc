# swift-mimalloc

A compact general-purpose allocator with excellent performance.

https://microsoft.github.io/mimalloc

## Add to your project

Add `swift-mimalloc` to your package dependencies and link the product in your target:

```swift
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/dataparallel-swift/swift-mimalloc.git", from: "1.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: [
                .product(name: "swift-mimalloc", package: "swift-mimalloc"),
            ]
        )
    ]
)
```

## Traits

This package exposes two SwiftPM traits:

- `Interpose`: enables malloc interposition so allocation calls are redirected to mimalloc. This trait is enabled by default.
- `CUDA`: uses CUDA pinned host memory for backing allocations. It can be combined with `Interpose`.

Example enabling `CUDA` while keeping the default `Interpose` trait enabled:

```swift
.package(
    url: "https://github.com/dataparallel-swift/swift-mimalloc.git",
    from: "1.1.0",
    traits: ["CUDA", "Interpose"]
)
```
