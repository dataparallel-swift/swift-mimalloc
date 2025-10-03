// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if arch(arm64)
let archFlags = [ "-march=armv8.1-a" ]          // fast atomics (since 2016)
#elseif arch(x86_64)
let archFlags = [ "-march=haswell;-mavx2" ]     // fast bitscan (since 2013)
#else
let archFlags = [ ]
#endif

let package = Package(
    name: "swift-mimalloc",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "swift-mimalloc", targets: ["swift-mimalloc"]),
    ],
    traits: [
        // Abusing the traits system, since these are (currently) mutually
        // exclusive. Add a default trait because we can't make build conditions
        // that are negations (i.e. when the CUDA trait is not enabled), or for
        // when no traits are enabled.
        "CUDA",
        "Interpose",
        .default(enabledTraits: ["Interpose"]),
    ],
    dependencies: [
        .package(url: "git@gitlab.com:PassiveLogic/compiler/swift-cuda.git", from: "0.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "swift-mimalloc",
            dependencies: [
                .product(name: "CUDA", package: "swift-cuda", condition: .when(traits: ["CUDA"])),
            ],
            path: "Sources/mimalloc-cbits",
            sources: ["mimalloc-cbits.c"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("mimalloc/include"),
                .define("NDEBUG", .when(configuration: .release)),
                .define("MI_BUILD_RELEASE", .when(configuration: .release)),
                .define("MI_OPT_SIMD", to: "1", .when(configuration: .release)),
                .unsafeFlags(archFlags, .when(configuration: .release)),

                // Use CUDA as the backing allocator
                .define("MI_USE_CUDA", .when(traits: ["CUDA"])),

                // Enable malloc interposition (currently not compatible with CUDA backend)
                .define("MI_MALLOC_OVERRIDE", .when(traits: ["Interpose"])),
                .define("MI_OSX_ZONE", to: "1", .when(platforms: [.macOS], traits: ["Interpose"])),
                .define("MI_OSX_INTERPOSE", to: "1", .when(platforms: [.macOS], traits: ["Interpose"])),
                .define("MI_WIN_NOREDIRECT", to: "1", .when(platforms: [.windows], traits: ["Interpose"])),
                .unsafeFlags(["-fno-builtin-malloc"], .when(traits: ["Interpose"])),
            ],
        ),
    ],
    cLanguageStandard: .c11,
)

