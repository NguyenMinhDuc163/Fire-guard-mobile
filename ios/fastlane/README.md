# iOS Fastlane/TestFlight

Run from `ios/`:

```sh
bundle install
bundle exec fastlane ios build
bundle exec fastlane ios beta
```

Bundle identifier:

```text
com.nguyenduc.fireGuard
```

Version comes from `pubspec.yaml`:

```yaml
version: 1.0.0+35
```

Use `APP_STORE_CONNECT_API_KEY_KEY_FILEPATH` for a raw `.p8` file. Do not use `APP_STORE_CONNECT_API_KEY_PATH` for `.p8`.

Local `.env` shape:

```env
APP_STORE_CONNECT_KEY_ID=
APP_STORE_CONNECT_ISSUER_ID=
APP_STORE_CONNECT_API_KEY_KEY_FILEPATH=
```

GitHub Actions secrets:

```text
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8
IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
IOS_APPSTORE_PROVISIONING_PROFILE_BASE64
```

The App Store provisioning profile must match:

```text
com.nguyenduc.fireGuard
```
