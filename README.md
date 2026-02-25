# PinGuardExample

Production-style sample app demonstrating `PinGuard` iOS SDK usage with SPKI pinning.

## Run

1. Open `PinGuardExample.xcodeproj` in Xcode.
2. Update SPKI pins in `PinGuardExample/App/Resources/Secrets.swift` if needed.
3. Select scheme `PinGuardExample` and run on an iOS Simulator.

## Test

- From Xcode: Product -> Test
- Or CLI:
  - `xcodebuild -project "PinGuardExample.xcodeproj" -scheme "PinGuardExample" -destination "platform=iOS Simulator,name=iPhone 17" -only-testing:"PinGuardExampleTests" test`
