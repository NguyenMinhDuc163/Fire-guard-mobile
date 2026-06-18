---
name: flutter-android-fastlane-google-play
description: Configure, review, or debug Flutter Android Fastlane delivery to Google Play. Use when setting up android/fastlane/Appfile, android/fastlane/Fastfile, android/Gemfile, Play Store service account JSON upload credentials, Android release signing, app bundle builds, internal testing, closed testing, release_status, versionCode/build_number, or Google Play upload errors for a Flutter project.
---

# Flutter Android Fastlane Google Play

## Operating Rules

- Do not run `flutter build appbundle`, `fastlane android deploy*`, or any upload command unless the user explicitly asks to build or upload.
- Prefer minimal configuration. Do not add many environment variables. Use fixed local paths unless the user asks for a configurable setup.
- Never print secret values from `play-store-credentials.json`, keystores, passwords, or `key.properties`. Only report existence, path, readability, and missing keys.
- If `pubspec.yaml` declares `.env` as a Flutter asset, CI must create `.env` from a GitHub secret such as `ENV_FILE_CONTENTS` before running `flutter build appbundle`.
- Treat `android/key.properties` and `android/fastlane/play-store-credentials*.json` as local secrets that must be ignored by Git.
- Use `ruby -c`, `bundle install`, `bundle exec fastlane lanes`, and `bundle exec fastlane android doctor` as non-uploading validation.
- Use FVM automatically when `.fvm/flutter_sdk/bin/flutter` exists; otherwise use `flutter` from PATH.

## User Inputs Needed

Ask for or discover these before finalizing setup:

- Android package name, for example `com.example.app`.
- Desired target track:
  `internal` for internal testing, `alpha` for closed testing, `beta` for open testing, `production` for production.
- Desired release behavior:
  `draft` to leave a draft in Play Console, or `completed` to submit/roll out to the selected track.
- Whether the user permits build/upload commands during the current turn.
- Android signing setup:
  release keystore plus `android/key.properties`.
- Google Play service account JSON file:
  place it at `android/fastlane/play-store-credentials.json`.
- Versioning policy:
  update `pubspec.yaml` `version: x.y.z+N`, or pass `build_name:x.y.z build_number:N` to Fastlane.

For first-time Play Console setup, guide the user to create/link a Google Cloud project, enable Google Play Android Developer API, create a service account JSON key, then invite the service account email in Google Play Console with release/testing permissions.

## Files To Create Or Update

Create these files in the target Flutter project:

```text
android/Gemfile
android/fastlane/Appfile
android/fastlane/Fastfile
android/fastlane/README.md
```

Ensure these local-only files exist or are documented:

```text
android/key.properties
android/fastlane/play-store-credentials.json
```

Update `.gitignore`:

```gitignore
android/fastlane/play-store-credentials*.json
```

Most Flutter templates already ignore `android/key.properties`, `*.jks`, and `*.keystore` in `android/.gitignore`. Add those ignores if missing.

## GitHub Push Protection / Secret History

Do not commit `android/fastlane/play-store-credentials.json` or any real Google Cloud service account JSON. The file may be the stable Fastlane path, but it must be created only at CI runtime from the GitHub secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`.

Before committing store-release changes, check the staged diff:

```bash
git diff --cached --name-only | rg 'play-store-credentials|key\.properties|\.jks$|\.keystore$'
git diff --cached | rg 'private_key|client_email|BEGIN PRIVATE KEY'
```

If a secret has entered a commit, deleting it in a later commit is not enough. GitHub push protection scans every commit being pushed and will still reject the push if an earlier commit contains the credential. Rewrite the local history so the secret never appears in the pushed commits.

Do not use GitHub's "unblock secret" URL for real credentials. Rotate or revoke the Google Cloud service account key if it has appeared in any local commit or Git object.

## Gemfile

Use a minimal Android Gemfile:

```ruby
source "https://rubygems.org"

gem "fastlane"
```

Run from `android/`:

```bash
bundle install
```

If Bundler complains about missing gems, run `bundle install`. If macOS system Ruby causes permission problems, suggest:

```bash
bundle config set path vendor/bundle
bundle install
```

When using `ruby/setup-ruby` with `bundler-cache: true`, CI runs Bundler in deployment/frozen mode. If CI fails with an empty `CHECKSUMS` entry such as:

```text
Your lockfile has an empty CHECKSUMS entry for "rake", but can't be updated because frozen mode is set
```

regenerate checksums locally and commit the lockfile:

```bash
cd android
bundle lock --add-checksums
bundle config set --local path vendor/bundle
bundle config set --local deployment true
bundle install --jobs 4
```

Add `.bundle/` and `vendor/bundle/` to `android/.gitignore`; do not commit those generated directories.

## Appfile

Use a fixed JSON key path and package name:

```ruby
json_key_file("fastlane/play-store-credentials.json")
package_name("com.example.app")
```

Replace `com.example.app` with the real Android application id from `android/app/build.gradle*`.

## Fastfile

Use this lane structure unless the project already has a better local convention:

```ruby
require "shellwords"

default_platform(:android)

PROJECT_ROOT = File.expand_path("../..", __dir__)
AAB_PATH = File.join(PROJECT_ROOT, "build", "app", "outputs", "bundle", "release", "app-release.aab")
PUBSPEC_PATH = File.join(PROJECT_ROOT, "pubspec.yaml")
DEFAULT_TRACK = "internal"

def project_root_sh(command)
  sh("cd #{PROJECT_ROOT.shellescape} && #{command}")
end

def flutter_bin
  fvm_flutter = File.join(PROJECT_ROOT, ".fvm", "flutter_sdk", "bin", "flutter")
  return fvm_flutter.shellescape if File.executable?(fvm_flutter)

  "flutter"
end

def appfile_value(key)
  CredentialsManager::AppfileConfig.try_fetch_value(key)
end

def expanded_path_from_android(path)
  return nil if path.to_s.empty?

  File.expand_path(path, File.expand_path("..", __dir__))
end

def require_existing_file(path, label)
  UI.user_error!("#{label} is not configured.") if path.to_s.empty?

  expanded_path = expanded_path_from_android(path)
  UI.user_error!("#{label} not found at #{expanded_path}") unless File.file?(expanded_path)

  expanded_path
end

def pubspec_version_parts
  version_line = File.readlines(PUBSPEC_PATH).find { |line| line.match?(/^\s*version:/) }
  UI.user_error!("Flutter version is not configured in #{PUBSPEC_PATH}") if version_line.to_s.empty?

  match = version_line.match(/^\s*version:\s*([^\s+]+)(?:\+(\d+))?/)
  UI.user_error!("Flutter version must use format x.y.z+N in #{PUBSPEC_PATH}") unless match

  [match[1], match[2]]
end

def play_release_name(options)
  pubspec_build_name, pubspec_build_number = pubspec_version_parts
  build_name = (options[:build_name] || pubspec_build_name).to_s
  build_number = (options[:build_number] || pubspec_build_number).to_s

  UI.user_error!("Android build name is not configured.") if build_name.empty?
  UI.user_error!("Android build number is not configured.") if build_number.empty?

  "#{build_number} (#{build_name})"
end

platform :android do
  desc "Check local Android release setup"
  lane :doctor do
    package_name = appfile_value(:package_name)
    json_key = appfile_value(:json_key_file)

    UI.user_error!("Android package name is not configured.") if package_name.to_s.empty?
    require_existing_file("key.properties", "Android signing file")
    require_existing_file(json_key, "Google Play service account JSON")

    UI.success("Android package: #{package_name}")
    UI.success("Signing file: #{File.join(File.expand_path('..', __dir__), 'key.properties')}")
    UI.success("Google Play JSON: #{expanded_path_from_android(json_key)}")
  end

  desc "Run Flutter tests"
  lane :test do
    project_root_sh("#{flutter_bin} test")
  end

  desc "Build signed Android App Bundle"
  lane :build do |options|
    build_args = []
    build_args << "--build-name #{options[:build_name].shellescape}" if options[:build_name]
    build_args << "--build-number #{options[:build_number].to_s.shellescape}" if options[:build_number]

    project_root_sh("#{flutter_bin} pub get")
    project_root_sh("#{flutter_bin} build appbundle --release #{build_args.join(' ')}".strip)

    UI.success("AAB generated at #{AAB_PATH}")
  end

  desc "Validate Google Play upload without publishing"
  lane :validate do |options|
    track = options[:track] || DEFAULT_TRACK

    doctor
    build(options)

    upload_to_play_store(
      track: track,
      aab: AAB_PATH,
      version_name: play_release_name(options),
      validate_only: true,
      skip_upload_metadata: true,
      skip_upload_changelogs: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end

  desc "Upload a new build to Google Play internal testing"
  lane :deploy_internal do |options|
    deploy(options.merge(track: "internal"))
  end

  desc "Upload a new build to Google Play closed testing"
  lane :deploy_closed do |options|
    deploy(options.merge(track: "alpha", release_status: "completed"))
  end

  desc "Upload a new build to Google Play"
  lane :deploy do |options|
    track = options[:track] || DEFAULT_TRACK
    release_status = options[:release_status] || "draft"

    doctor
    build(options)

    upload_to_play_store(
      track: track,
      aab: AAB_PATH,
      version_name: play_release_name(options),
      release_status: release_status,
      changes_not_sent_for_review: false,
      skip_upload_metadata: true,
      skip_upload_changelogs: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end
end
```

## Google Play Release Name Pitfall

Google Play Console shows a release name separately from the AAB `versionCode` and Android `versionName`. Manual uploads may appear as `36 (1.0.0)`, while Fastlane uploads can appear as only `1.0.0` if `upload_to_play_store` does not receive `version_name`.

When the project expects Play Console release rows to keep the manual-upload style, set Fastlane's `version_name` upload option explicitly. For Flutter projects, derive it from `pubspec.yaml` `version: x.y.z+N` and format it as:

```ruby
version_name: "#{build_number} (#{build_name})"
```

In the template above, `play_release_name(options)` reads `pubspec.yaml` by default and still honors explicit lane parameters:

```bash
bundle exec fastlane android deploy_internal build_name:1.0.1 build_number:48
```

This produces the Google Play release name:

```text
48 (1.0.1)
```

Do not confuse this with Android's binary version fields:

```text
version: 1.0.1+48
versionName = 1.0.1
versionCode = 48
Google Play release name = 48 (1.0.1)
```

## GitHub Actions Android SDK/NDK Cache Pitfall

If Fastlane reports only that `flutter build appbundle --release --no-pub` exited 1, inspect the Gradle/Flutter output above the Fastlane summary. For this project, this message means the runner did not create `.env`:

```text
Error detected in pubspec.yaml:
No file or variants found for asset: .env.
Target aot_android_asset_bundle failed: Exception: Failed to bundle asset files.
```

Fix the workflow by writing `.env` from `ENV_FILE_CONTENTS` before the Fastlane deploy step, and keep the real `.env` out of Git.

If Android CI logs repeatedly show package installation during `flutter build appbundle`, the slow part may be Android SDK package downloads rather than Dart/Gradle compile. Cache the SDK directories that match the project; do not assume fixed versions.

Discover the cache targets first:

- Read `android/app/build.gradle*` for `ndkVersion`, for example `ndkVersion = "27.0.12077973"`.
- Read the CI log for `Install Android SDK Platform XX`; use that `android-XX` platform. This is more reliable than guessing when `compileSdk` is `flutter.compileSdkVersion`.

Example log:

```text
Install NDK (Side by side) 27.0.12077973
Install Android SDK Platform 33
```

Add an `actions/cache@v4` step in the Android workflow before Fastlane/build, substituting the discovered values:

```yaml
- name: Cache Android SDK packages
  uses: actions/cache@v4
  with:
    path: |
      /usr/local/lib/android/sdk/ndk/<ndk-version>
      /usr/local/lib/android/sdk/platforms/android-<platform-api>
    key: ${{ runner.os }}-android-sdk-ndk-<ndk-version>-platform-<platform-api>-v1
```

For the example log above:

```yaml
path: |
  /usr/local/lib/android/sdk/ndk/27.0.12077973
  /usr/local/lib/android/sdk/platforms/android-33
key: ${{ runner.os }}-android-sdk-ndk-27.0.12077973-platform-33-v1
```

This cache is safe because it stores SDK/NDK toolchain packages, not app source or release build output. Change the key/path when `ndkVersion` or the required Android SDK platform changes.

## Android Native Libs Artifact

Upload release native libraries after the Google Play deploy step with `if: always()` so crash/native logs can be traced later:

```yaml
- name: Upload Android symbol artifact
  if: always()
  uses: actions/upload-artifact@v4
  with:
    name: symbol
    path: build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib
    if-no-files-found: warn
```

Keep the existing AAB artifact upload as well. This artifact should contain the built ABI folders and native `.so` files from the release build.

## Lane Commands

Run from `android/`:

```bash
bundle exec fastlane android doctor
bundle exec fastlane android build
bundle exec fastlane android validate
bundle exec fastlane android deploy_internal
bundle exec fastlane android deploy_closed
bundle exec fastlane android deploy
```

Common parameters:

```bash
bundle exec fastlane android build build_number:46
bundle exec fastlane android build build_name:1.0.1 build_number:46
bundle exec fastlane android deploy track:alpha release_status:draft
bundle exec fastlane android deploy track:alpha release_status:completed
bundle exec fastlane android deploy_closed build_name:1.0.1 build_number:46
```

Track map:

```text
internal   Internal testing
alpha      Closed testing
beta       Open testing / beta track
production Production
```

Release status:

```text
draft       Create a draft release in Play Console
completed   Submit/roll out to the selected track
```

## Google Play Setup Guidance

Use this track when the user does not know how to get `android/fastlane/play-store-credentials.json`, or asks what `play-store-credentials*.json` is.

Guide the user step by step. If they send a screenshot, identify the current screen and give only the next action or small set of actions. Avoid jumping ahead.

### Credential Track

1. Start in Google Play Console:

```text
https://play.google.com/console
```

2. Go to:

```text
Setup -> API access
```

If the user is instead on `Users and permissions`, explain that this screen is for granting access later; they still need to create the Google Cloud service account JSON first.

3. Create or link a Google Cloud project from `API access`. If the user has no Google Cloud project, tell them to create a new one from the Play Console API access flow. Use a simple project name such as:

```text
ed-tech-play-release
```

4. In Google Cloud, ensure the correct project is selected in the top project selector. Then enable:

```text
Google Play Android Developer API
androidpublisher.googleapis.com
```

If the API page shows `Status: Enabled` or a `Disable API` button, the API is already enabled.

5. On the Google Play Android Developer API page, open the `Credentials` tab and click:

```text
Create credentials
```

6. On the `Credential Type` screen:

```text
Which API are you using?
Google Play Android Developer API

What data will you be accessing?
Application data
```

Tell the user not to choose `User data`; Fastlane needs a service account, not OAuth user login.

7. On `Create service account`, use:

```text
Service account name: fastlane-google-play
Service account ID: fastlane-google-play
Service account description: Upload Android app bundle to Google Play using Fastlane
```

Then click:

```text
Create and continue
```

8. On `Permissions (optional)`, leave `Select a role` empty and click `Continue`.

9. On `Principals with access (optional)`, leave `Service account users role` and `Service account admins role` empty, then click `Done`.

10. After the service account is created, copy its email. It looks like:

```text
fastlane-google-play@PROJECT_ID.iam.gserviceaccount.com
```

11. Create the JSON key:

```text
Service account -> Keys -> Add key -> Create new key -> JSON -> Create
```

The browser downloads a `.json` file. Tell the user to rename it to:

```text
play-store-credentials.json
```

and place it at:

```text
android/fastlane/play-store-credentials.json
```

12. Return to Google Play Console:

```text
Users and permissions -> Invite new users
```

Use the service account email as the invited email.

13. Grant app-level access for the target app. For internal or closed testing, choose only:

```text
View app information (read-only)
View app quality information (read-only)
Release apps to testing tracks
Manage testing tracks and edit tester lists
```

Do not select `Admin (all permissions)` unless the user explicitly wants broad account administration. Do not select `Release to production` when the user only wants internal or closed testing.

14. Save or invite the user. Service accounts do not need to accept an email invitation like a human user.

15. Verify locally:

```bash
cd android
bundle exec fastlane android doctor
bundle exec fastlane run validate_play_store_json_key json_key:fastlane/play-store-credentials.json
```

Do not ask the user to paste JSON contents. Ask them to place the file at the expected path.

## Android Signing

Confirm `android/app/build.gradle*` has release signing wired to `android/key.properties`.

Typical `key.properties` shape:

```properties
storePassword=...
keyPassword=...
keyAlias=...
storeFile=...
```

Do not create a release keystore unless the user explicitly asks. If creating one, explain that the keystore must be backed up; losing it can block app updates unless Play App Signing recovery is available.

## Versioning

Flutter Android uses `pubspec.yaml`:

```yaml
version: 1.0.0+45
```

The value after `+` is Android `versionCode`. Google Play requires every uploaded build to use a new, higher `versionCode`.

If the user deploys build `47` and then build `48` to the same track while `47` is in review, `48` becomes the newer release candidate for that track. Build `47` is not deleted, but it can become superseded. Do not reuse old build numbers.

## README For Target Project

Keep `android/fastlane/README.md` short. Include commands and parameters only; avoid long setup prose unless the user asks.

Recommended contents:

````markdown
# Android Fastlane

Run from `android/`:

```bash
bundle exec fastlane android doctor
bundle exec fastlane android build
bundle exec fastlane android validate
bundle exec fastlane android deploy_internal
bundle exec fastlane android deploy_closed
bundle exec fastlane android deploy
```

Parameters:

```bash
bundle exec fastlane android build build_name:1.0.1 build_number:46
bundle exec fastlane android deploy track:alpha release_status:completed
bundle exec fastlane android deploy_closed build_number:46
```

Tracks:

```text
internal, alpha, beta, production
```
````

## Validation

Use these checks before any real build/upload:

```bash
ruby -c android/fastlane/Fastfile
ruby -c android/fastlane/Appfile
cd android && bundle exec fastlane lanes
cd android && bundle exec fastlane android doctor
```

If the user asks to verify the JSON key only:

```bash
cd android
bundle exec fastlane run validate_play_store_json_key json_key:fastlane/play-store-credentials.json
```

## Troubleshooting

- Missing gems: run `cd android && bundle install`.
- Bundler version mismatch: install the Bundler version named in `android/Gemfile.lock`, or regenerate the lock with the local Bundler if appropriate.
- Empty `CHECKSUMS` entry in CI frozen mode: run `cd android && bundle lock --add-checksums`, then verify with `bundle config set --local deployment true && bundle install --jobs 4`.
- `Google Play service account JSON not found`: place the file at `android/fastlane/play-store-credentials.json`.
- `403 permission denied`: grant the service account the required app permissions in Google Play Console.
- Package/app not found: confirm `package_name(...)` matches the Play Console app package and Android `applicationId`.
- Duplicate version code: increase `pubspec.yaml` build number after `+` or pass a higher `build_number`.
- Upload succeeds but still waits in Play Console: Google review and Managed publishing cannot be bypassed by Fastlane. Turn off Managed publishing if automatic publication after approval is desired.
