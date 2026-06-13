---
name: flutter-ios-fastlane-testflight
description: Configure, review, or debug this project's Flutter iOS Fastlane/TestFlight workflow. Use when working on ios/fastlane/Appfile, ios/fastlane/Fastfile, ios/Gemfile, pubspec.yaml-driven iOS versioning, App Store Connect API key upload, TestFlight upload errors, CocoaPods/FVM setup, bundle identifier collisions, or iOS signing/export issues in this repository.
---

# Flutter iOS Fastlane TestFlight

## Operating Rules

- Do not run `fastlane ios build`, `fastlane ios beta`, `flutter build ipa`, or any upload/build command unless the user explicitly asks to run it.
- Do not create or modify tester lists, TestFlight groups, notification settings, or encryption compliance keys unless the user explicitly asks for that exact change.
- Never print secret values from `.env`, `.p8`, API keys, certificates, or provisioning profiles. Redact or only report presence, length, path existence, and readability.
- Prefer small config edits plus validation (`ruby -c`, `plutil -lint`, `fastlane lanes`) before any real build/upload.

## Files To Inspect

- `pubspec.yaml`: source of Flutter app version, e.g. `version: 1.0.0+38`.
- `ios/fastlane/Appfile`: bundle id, Apple ID, team id.
- `ios/fastlane/Fastfile`: build/upload lanes.
- `ios/Gemfile` and `ios/Gemfile.lock`: Fastlane/CocoaPods versions.
- `ios/Podfile` and `ios/Podfile.lock`: iOS platform and CocoaPods state.
- `ios/Runner/Info.plist`: bundle version references and optional compliance keys.
- `ios/Runner.xcodeproj/project.pbxproj`: signing, bundle id, and version build settings.
- `ios/fastlane/.env`: local secrets; inspect carefully without exposing values.

## Known Good Patterns

Use Ruby syntax in `Appfile`; do not use template brackets or JavaScript-style comments:

```ruby
app_identifier("com.example.app")
apple_id("developer@example.com")
team_id("ABCDE12345")
```

Pin Fastlane dependencies in `ios/Gemfile` so local and CI use the same toolchain:

```ruby
source "https://rubygems.org"

gem "fastlane"
gem "cocoapods", "1.16.2"
gem "ostruct"
```

Use `pubspec.yaml` as the version source. For iOS Runner build settings, prefer:

```text
MARKETING_VERSION = "$(FLUTTER_BUILD_NAME)";
CURRENT_PROJECT_VERSION = "$(FLUTTER_BUILD_NUMBER)";
```

For App Store Connect `.p8` API keys, use a variable name that Fastlane will not confuse with JSON API key paths:

```env
APP_STORE_CONNECT_KEY_ID=ABCDE12345
APP_STORE_CONNECT_ISSUER_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
APP_STORE_CONNECT_API_KEY_KEY_FILEPATH=/absolute/path/AuthKey_ABCDE12345.p8
```

Then call:

```ruby
api_key = app_store_connect_api_key(
  key_id: ENV.fetch("APP_STORE_CONNECT_KEY_ID"),
  issuer_id: ENV.fetch("APP_STORE_CONNECT_ISSUER_ID"),
  key_filepath: ENV.fetch("APP_STORE_CONNECT_API_KEY_KEY_FILEPATH")
)

upload_to_testflight(
  api_key: api_key,
  app_identifier: APP_IDENTIFIER,
  skip_waiting_for_build_processing: true
)
```

Do not use `APP_STORE_CONNECT_API_KEY_PATH` for a raw `.p8` file. Fastlane/Pilot treats that name as a JSON API key info file path in some contexts; pointing it to a `.p8` can produce `invalid number: '-----BEGIN'`.

## Fastfile Guardrails

- Do not pass `PRODUCT_BUNDLE_IDENTIFIER=...` through global `xcargs` in `build_app`. Xcode applies global `xcargs` to Pods/framework targets too, causing `CFBundleIdentifier Collision` during upload.
- Let the Runner target own `PRODUCT_BUNDLE_IDENTIFIER` through the Xcode project.
- If `flutter` is not in PATH, support FVM or `FLUTTER_ROOT/bin/flutter`, but do not hardcode one user's Flutter path unless the repo already does.
- For local build output, naming the IPA from `pubspec.yaml` is safe, e.g. `EdTech-1.0.0-38.ipa`; do not rely on output filename as the actual app version.

## GitHub Actions Cache Guidance

Hosted macOS runners are clean, so avoid deleting caches that were just restored. In this repo, do not add a generic pre-build step that runs:

```bash
flutter clean
rm -rf build ios/build ios/Pods ios/.symlinks
```

That removes `ios/Pods` and makes CocoaPods cache ineffective. Prefer caching CocoaPods before the Fastlane build:

```yaml
- name: Cache CocoaPods
  uses: actions/cache@v4
  with:
    path: |
      ~/Library/Caches/CocoaPods
      ~/.cocoapods/repos
      ios/Pods
    key: ${{ runner.os }}-cocoapods-${{ hashFiles('ios/Podfile.lock', 'pubspec.lock') }}-v1
    restore-keys: |
      ${{ runner.os }}-cocoapods-
```

In CI, prefer:

```bash
bundle exec pod install --deployment
```

over `pod install --clean-install` when `ios/Podfile.lock` is committed. `--deployment` respects the lockfile and fails if pods are out of sync, which is useful for reproducible CI. Keep `build_app(clean: true)` if a clean archive is desired; it is separate from CocoaPods dependency caching.

Do not cache Xcode `DerivedData` for signed App Store/TestFlight builds unless logs prove compilation dominates and the user accepts larger, more fragile caches.

## Debugging Upload Errors

For `invalid number: '-----BEGIN'` at `upload_to_testflight`:

1. Check `.env` for `APP_STORE_CONNECT_API_KEY_PATH=/path/AuthKey_*.p8`.
2. Replace it with `APP_STORE_CONNECT_API_KEY_KEY_FILEPATH=/path/AuthKey_*.p8`.
3. Store the `app_store_connect_api_key` return value and pass it as `api_key:` to `upload_to_testflight`.

For `CFBundleIdentifier Collision`:

1. Inspect the IPA's embedded `Info.plist` files:

```bash
tmp=$(mktemp -d /tmp/flutter-ios-ipa.XXXXXX)
unzip -q path/to/app.ipa -d "$tmp"
find "$tmp/Payload" -name Info.plist -print0 |
  while IFS= read -r -d "" plist; do
    id=$(plutil -extract CFBundleIdentifier raw -o - "$plist" 2>/dev/null || true)
    name=$(plutil -extract CFBundleName raw -o - "$plist" 2>/dev/null || true)
    echo "$id | $name | $plist"
  done | sort
```

2. If embedded frameworks/bundles share the app bundle id, remove global `PRODUCT_BUNDLE_IDENTIFIER=...` from `build_app(xcargs:)`.
3. Rebuild a new IPA with a new build number before uploading again.

For `ARCHIVE SUCCEEDED` followed by `Error packaging up the application` and `Looks like no provisioning profile mapping was provided` on GitHub Actions:

- Treat this as an export/signing problem, not a Flutter compile problem.
- Do not assume the 3 App Store Connect API key values are enough for a clean hosted macOS runner.
- Install an Apple Distribution `.p12` certificate and an App Store `.mobileprovision` profile into the runner keychain/profile directory, then pass the extracted profile name through `IOS_PROVISIONING_PROFILE_NAME`.
- Use `export_options` with `signingStyle: "manual"` and `provisioningProfiles: { APP_IDENTIFIER => profile_name }` when `IOS_PROVISIONING_PROFILE_NAME` is present.
- Upload `~/Library/Logs/gym/*.log` as a failure artifact so the real `xcodebuild -exportArchive` error is available.
- Required GitHub Actions secrets for this workflow:
  `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, `APP_STORE_CONNECT_API_KEY_P8`, `IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64`, `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD`, `IOS_APPSTORE_PROVISIONING_PROFILE_BASE64`.

For `xcodebuild -exportArchive` exit status `64` after `ARCHIVE SUCCEEDED`:

- Treat it as invalid export command arguments.
- Remember Fastlane/gym appends `xcargs` to the `-exportArchive` command too, not only archive/build.
- Do not pass App Store Connect authentication flags through `build_app(xcargs:)` or `export_xcargs` when a certificate/profile is already installed.
- With Fastlane 2.236.x, keep the export method value as `app-store`; Fastlane does not accept Xcode 26's newer `app-store-connect` method name yet.

For TestFlight duplicate build errors:

- Increase the build number after `+` in `pubspec.yaml`, e.g. `version: 1.0.0+39`.
- Keep the marketing version before `+` unchanged unless releasing a new user-visible version.

## Validation

Use non-uploading checks first:

```bash
ruby -c ios/fastlane/Fastfile
ruby -c ios/fastlane/Appfile
plutil -lint ios/Runner/Info.plist
cd ios && bundle exec fastlane lanes
```

When checking `.env`, only verify keys/path shape:

```bash
ruby -e 'p=ENV["APP_STORE_CONNECT_API_KEY_KEY_FILEPATH"]; puts File.exist?(p.to_s)'
```

## Optional Features

- Add `ITSAppUsesNonExemptEncryption=false` only if the user explicitly requests encryption compliance handling and the app truly qualifies.
- Configure external testers/groups only when the user explicitly asks. External distribution generally requires waiting for build processing and may require `distribute_external`, `groups`, and a changelog.
