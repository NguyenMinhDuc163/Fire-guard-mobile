# Android Fastlane

Run from `android/`:

```sh
bundle install
bundle exec fastlane android doctor
bundle exec fastlane android build
bundle exec fastlane android validate
bundle exec fastlane android deploy_internal
bundle exec fastlane android deploy_closed
bundle exec fastlane android deploy
```

Package name:

```text
com.nguyenduc.fire_guard
```

Local-only files:

```text
android/key.properties
android/fastlane/play-store-credentials.json
```

Common deploy parameters:

```sh
bundle exec fastlane android deploy track:internal release_status:completed
bundle exec fastlane android deploy track:alpha release_status:draft
```

Google Play release names are derived from `pubspec.yaml` as `buildNumber (buildName)`.
