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
        .library( name: "swift-mimalloc", targets: ["swift-mimalloc"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "swift-mimalloc",
            path: "Sources/mimalloc-cbits",
            sources: ["mimalloc-cbits.c"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("mimalloc/include"),
                .define("NDEBUG", .when(configuration: .release)),
                .define("MI_BUILD_RELEASE", .when(configuration: .release)),
                .define("MI_MALLOC_OVERRIDE"),
                .define("MI_OSX_ZONE", to: "1", .when(platforms: [.macOS])),
                .define("MI_OSX_INTERPOSE", to: "1", .when(platforms: [.macOS])),
                .define("MI_WIN_NOREDIRECT", to: "1", .when(platforms: [.windows])),
                .define("MI_OPT_SIMD", to: "1", .when(configuration: .release)),
                .unsafeFlags(["-fno-builtin-malloc"]),
                .unsafeFlags(archFlags, .when(configuration: .release)),
            ],
        )
    ],
    cLanguageStandard: .c11,
)

