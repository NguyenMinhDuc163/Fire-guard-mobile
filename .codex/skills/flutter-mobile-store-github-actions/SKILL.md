---
name: flutter-mobile-store-github-actions
description: Configure, review, or debug this project's Flutter mobile store CI/CD with GitHub Actions. Use when setting up or changing workflows that bump pubspec.yaml once, then build/upload iOS TestFlight and Android Google Play from the bumped commit; when splitting workflows into reusable workflow_call files; when preparing Android keystore, key.properties, and Google Play service account secrets; or when diagnosing mobile GitHub Actions/Fastlane release failures.
---

# Flutter Mobile Store GitHub Actions

## Operating Rules

- Do not run live store upload commands unless the user explicitly asks. Treat `fastlane ios beta`, `fastlane android deploy*`, and any workflow dispatch that uploads to stores as production-affecting.
- Keep secret material out of terminal output. Do not print keystore bytes, `key.properties`, `.p8` keys, `.p12` certificates, provisioning profiles, or Google Play JSON contents.
- If `pubspec.yaml` includes `.env` under `flutter.assets`, recreate `.env` on CI from the GitHub secret `ENV_FILE_CONTENTS` before any Flutter build. Do not commit the real `.env` file and do not print its contents.
- Prefer non-upload validation first: YAML parse, `ruby -c`, `bundle exec fastlane lanes`, and `bundle exec fastlane android doctor` only when local secret files are present.
- Preserve the single-version-bump invariant: exactly one job should increment `pubspec.yaml`, commit with `[skip ci]`, and expose the bumped commit SHA. Store build jobs must checkout that SHA.
- Use reusable workflows when the main workflow becomes long, but keep dependency ordering in the caller workflow with `needs: bump_version`.
- Do not comment out a reusable workflow file to skip a platform. The caller still references that file and GitHub can fail the workflow before the other platform builds. Add root toggles such as `RUN_IOS` and `RUN_ANDROID`, resolve them in a small config job, then skip the caller job with `if`.
- For Android-specific Fastlane details, also use the `flutter-android-fastlane-google-play` skill. For iOS Fastlane/TestFlight signing details, also use the `flutter-ios-fastlane-testflight` skill.

## Expected Workflow Shape

Use three workflow files for this repository:

```text
.github/workflows/mobile-store-release.yml
.github/workflows/reusable-ios-testflight.yml
.github/workflows/reusable-android-google-play.yml
```

The caller workflow owns triggers, concurrency, and the version bump:

```text
bump_version
  -> build_testflight
  -> build_google_play
```

`build_testflight` and `build_google_play` should be reusable workflow jobs:

For push-to-main defaults, expose root toggles:

```yaml
env:
  RUN_IOS: "false"
  RUN_ANDROID: "true"
  ANDROID_TRACK: "internal"
  ANDROID_RELEASE_STATUS: "completed"
```

For manual testing, also expose workflow inputs:

```yaml
workflow_dispatch:
  inputs:
    run_ios:
      description: "Build and upload iOS TestFlight"
      type: boolean
      default: false
    run_android:
      description: "Build and upload Android Google Play"
      type: boolean
      default: true
```

GitHub job-level `if` cannot reliably read workflow `env` directly. Add a tiny `release_config` job that converts root `env` plus optional `workflow_dispatch` overrides into job outputs:

```yaml
release_config:
  outputs:
    run_ios: ${{ steps.config.outputs.run_ios }}
    run_android: ${{ steps.config.outputs.run_android }}
    android_track: ${{ steps.config.outputs.android_track }}
    android_release_status: ${{ steps.config.outputs.android_release_status }}
```

Make `bump_version` depend on `release_config`, and only bump if at least one platform is enabled:

```yaml
needs: release_config
if: ${{ needs.release_config.outputs.run_ios == 'true' || needs.release_config.outputs.run_android == 'true' }}
```

Then make each store job depend only on `release_config` and `bump_version`, not on the other store job:

```yaml
needs:
  - release_config
  - bump_version
if: ${{ needs.release_config.outputs.run_ios == 'true' }}
uses: ./.github/workflows/reusable-ios-testflight.yml
with:
  commit_sha: ${{ needs.bump_version.outputs.commit_sha }}
secrets: inherit
```

```yaml
needs:
  - release_config
  - bump_version
if: ${{ needs.release_config.outputs.run_android == 'true' }}
uses: ./.github/workflows/reusable-android-google-play.yml
with:
  commit_sha: ${{ needs.bump_version.outputs.commit_sha }}
  android_track: ${{ needs.release_config.outputs.android_track }}
  android_release_status: ${{ needs.release_config.outputs.android_release_status }}
secrets: inherit
```

Avoid independent workflow files connected only by `workflow_run` unless the user specifically wants separate timeline entries. `workflow_run` makes it easier to accidentally build the wrong commit.

If iOS fails at runtime, Android should still run because Android only needs `bump_version`, not `build_testflight`. If Android does not start, inspect the caller workflow for invalid reusable workflow references or accidental `needs: [bump_version, build_testflight]`.

## Version Bump Job

The bump job should:

- Run before both store build jobs.
- Require `contents: write`.
- Update only `pubspec.yaml`.
- Match `version: x.y.z+n`.
- Increment only the build number.
- Commit with `[skip ci]` to prevent an infinite push loop.
- Output the bumped commit SHA.

Keep the Flutter version name unchanged unless the user explicitly requests a semantic version bump.

## Android Reusable Workflow

The Android workflow should:

- Run on `ubuntu-24.04`.
- Checkout `inputs.commit_sha`.
- Set up Java 17, Flutter from `.fvmrc`, and Ruby/Bundler in `android`.
- When using `ruby/setup-ruby@v1`, always specify `ruby-version` unless the repo has a committed `.ruby-version` or `.tool-versions` file. Without one of these, GitHub Actions fails before Bundler runs:

```yaml
- name: Set up Ruby
  uses: ruby/setup-ruby@v1
  with:
    ruby-version: "3.3"
    working-directory: android
    bundler-cache: true
```

- Cache Android SDK packages that Gradle downloads during `flutter build`, especially NDK and SDK platforms shown in the logs.
- Recreate local-only release files on the runner:
  - `android/key.properties`
  - the keystore path declared by `storeFile` in `android/key.properties`
  - `android/fastlane/play-store-credentials.json`
- Upload build diagnostics artifacts after the deploy step with `if: always()`:
  - AAB from `build/app/outputs/bundle/release/*.aab`
  - native libs from `build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib`
- Run Fastlane from `android/`:

```bash
bundle exec fastlane android deploy track:${{ inputs.android_track }} release_status:${{ inputs.android_release_status }}
```

Use repository secrets:

```text
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON
ANDROID_KEYSTORE_BASE64
ANDROID_KEY_PROPERTIES_BASE64
ENV_FILE_CONTENTS
```

`GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` should be the raw JSON content. `ANDROID_KEYSTORE_BASE64` and `ANDROID_KEY_PROPERTIES_BASE64` are single-line base64 strings. `ENV_FILE_CONTENTS` is the raw `.env` file content used by Flutter asset bundling.

If Android fails during `flutter build appbundle` with:

```text
Error detected in pubspec.yaml:
No file or variants found for asset: .env.
Target aot_android_asset_bundle failed: Exception: Failed to bundle asset files.
```

the runner is missing `.env`. Add `ENV_FILE_CONTENTS` to the reusable workflow `secrets`, validate it with the other required secrets, then write it in the repository root before Fastlane:

```yaml
- name: Write Flutter dotenv file
  shell: bash
  env:
    ENV_FILE_CONTENTS: ${{ secrets.ENV_FILE_CONTENTS }}
  run: |
    set -euo pipefail
    printf '%s' "$ENV_FILE_CONTENTS" > .env
    chmod 600 .env
```

## Android SDK/NDK Cache Pitfall

If GitHub Actions logs show Gradle reinstalling Android SDK packages on every run, cache the SDK directories that match the current project. Do not blindly reuse old versions.

First discover the values:

- Read `android/app/build.gradle*` for `ndkVersion`, for example `ndkVersion = "27.0.12077973"`.
- Read the failed/slow CI log for lines like `Install Android SDK Platform 33`; use that `android-XX` value.
- If the log is unavailable, inspect `compileSdk`. In Flutter projects it may be `flutter.compileSdkVersion`, so prefer the CI log because it reveals the actual installed platform.

Example log:

```text
Install NDK (Side by side) 27.0.12077973
Install Android SDK Platform 33
```

Then cache those exact paths before the Flutter build:

```yaml
- name: Cache Android SDK packages
  uses: actions/cache@v4
  with:
    path: |
      /usr/local/lib/android/sdk/ndk/<ndk-version>
      /usr/local/lib/android/sdk/platforms/android-<platform-api>
    key: ${{ runner.os }}-android-sdk-ndk-<ndk-version>-platform-<platform-api>-v1
```

For the current log above, the concrete cache paths are:

```yaml
path: |
  /usr/local/lib/android/sdk/ndk/27.0.12077973
  /usr/local/lib/android/sdk/platforms/android-33
key: ${{ runner.os }}-android-sdk-ndk-27.0.12077973-platform-33-v1
```

This caches toolchain packages, not app source or build output, so it does not build old code. In this repo it reduced the second Android run dramatically because NDK/platform restore replaced repeated downloads. Update the key/path when `android/app/build.gradle*` changes `ndkVersion` or the logs show a different `android-XX` platform.

## Export Android Secrets

Run these commands locally from the repository root. Prefer clipboard or `gh secret set` so secret values are not printed.

Copy raw Google Play service account JSON to the clipboard:

```bash
pbcopy < android/fastlane/play-store-credentials.json
```

Set it with GitHub CLI instead:

```bash
gh secret set GOOGLE_PLAY_SERVICE_ACCOUNT_JSON < android/fastlane/play-store-credentials.json
```

Copy base64 `android/key.properties` to the clipboard:

```bash
base64 < android/key.properties | tr -d '\n' | pbcopy
```

Set it with GitHub CLI instead:

```bash
base64 < android/key.properties | tr -d '\n' | gh secret set ANDROID_KEY_PROPERTIES_BASE64 --body-file -
```

Copy base64 keystore to the clipboard. This resolves the keystore path from `storeFile` and treats relative paths the same way the Android Gradle file does in this repo:

```bash
store_file=$(awk -F= '/^storeFile=/{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}' android/key.properties)
case "$store_file" in
  /*) keystore_path="$store_file" ;;
  *) keystore_path="android/app/$store_file" ;;
esac
base64 < "$keystore_path" | tr -d '\n' | pbcopy
```

Set it with GitHub CLI instead:

```bash
store_file=$(awk -F= '/^storeFile=/{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}' android/key.properties)
case "$store_file" in
  /*) keystore_path="$store_file" ;;
  *) keystore_path="android/app/$store_file" ;;
esac
base64 < "$keystore_path" | tr -d '\n' | gh secret set ANDROID_KEYSTORE_BASE64 --body-file -
```

If the user only has raw values and not files, create the local files first in ignored paths, then run the commands above. Do not commit these files.

Set the Flutter dotenv secret from the local `.env` file without printing it:

```bash
gh secret set ENV_FILE_CONTENTS < .env
```

## Android Secret Validation

In workflow code, validate only presence, not values:

```bash
for name in GOOGLE_PLAY_SERVICE_ACCOUNT_JSON ANDROID_KEYSTORE_BASE64 ANDROID_KEY_PROPERTIES_BASE64 ENV_FILE_CONTENTS; do
  if [ -z "${!name:-}" ]; then
    echo "::error::$name is not set"
    missing=1
  fi
done
```

When recreating the keystore, parse `android/key.properties`, read `storeFile`, and write the decoded keystore to:

```text
absolute storeFile: storeFile
relative storeFile: android/app/<storeFile>
```

This matches this repository's `android/app/build.gradle.kts`, where `file(it)` is evaluated from the app module.

## iOS Reusable Workflow

The iOS workflow should:

- Run on `macos-26` unless the repo intentionally pins a different runner.
- Checkout `inputs.commit_sha`.
- Recreate App Store Connect API key and Apple signing assets from secrets.
- Read Flutter version from `.fvmrc`.
- Set up Flutter and Ruby/Bundler in `ios`.
- When using `ruby/setup-ruby@v1`, always specify `ruby-version` unless the repo has a committed `.ruby-version` or `.tool-versions` file. Without one of these, GitHub Actions fails before Bundler runs:

```yaml
- name: Set up Ruby
  uses: ruby/setup-ruby@v1
  with:
    ruby-version: "3.3"
    working-directory: ios
    bundler-cache: true
```

- Run:

```bash
bundle exec fastlane ios beta
```

- Keep the Fastlane archive path stable, e.g. `archive_path: "../build/ios/archive/Runner.xcarchive"`.
- Upload build diagnostics artifacts after the TestFlight step with `if: always()`:
  - IPA from `build/ios/ipa/*.ipa`
  - dSYM files from `build/ios/archive/Runner.xcarchive/dSYMs`

Expected iOS secrets:

```text
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8
IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
IOS_APPSTORE_PROVISIONING_PROFILE_BASE64
```

Do not change iOS signing behavior unless the user asks; preserve existing working TestFlight CI.

## Android Fastlane Expectations

Before relying on GitHub Actions, verify the Android Fastlane setup has:

- `android/Gemfile` with `fastlane`.
- `android/Gemfile.lock` committed and compatible with CI Bundler.
- `android/fastlane/Appfile` with package name and `json_key_file("fastlane/play-store-credentials.json")`.
- `android/fastlane/Fastfile` lanes `doctor`, `build`, `validate`, and `deploy`.
- `upload_to_play_store` receives `version_name: play_release_name(options)` when the user wants Google Play release names like `48 (1.0.1)`.
- `.gitignore` ignores `android/fastlane/play-store-credentials*.json`.
- `android/.gitignore` ignores `key.properties`, `*.jks`, `*.keystore`, `.bundle/`, and `vendor/bundle/`.

## Android Bundler 4 Checksum Pitfall

If GitHub Actions fails inside `ruby/setup-ruby@v1` with:

```text
Your lockfile has an empty CHECKSUMS entry for "rake", but can't be updated because frozen mode is set
```

fix the committed lockfile locally from `android/`:

```bash
bundle lock --add-checksums
bundle config set --local path vendor/bundle
bundle config set --local deployment true
bundle install --jobs 4
```

Commit only `android/Gemfile.lock` and ignore/remove generated `android/.bundle/` and `android/vendor/bundle/`.

## Validation Checklist

Run non-upload checks after editing workflows or Fastlane files:

```bash
ruby -e 'require "yaml"; ARGV.each { |f| YAML.load_file(f); puts "#{f}: ok" }' \
  .github/workflows/mobile-store-release.yml \
  .github/workflows/reusable-ios-testflight.yml \
  .github/workflows/reusable-android-google-play.yml
ruby -c android/fastlane/Fastfile
ruby -c ios/fastlane/Fastfile
cd android && bundle exec fastlane lanes
cd ios && bundle exec fastlane lanes
cd android && bundle lock --add-checksums
```

If `actionlint` is installed, run it too:

```bash
actionlint .github/workflows/*.yml
```

Do not run store-uploading lanes or dispatch the workflow unless the user explicitly asks.
