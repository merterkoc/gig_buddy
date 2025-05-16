# gig_buddy

The platform that brings concert lovers together.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Any Problem? So Use This Command

```bash
flutter clean
rm -Rf ios/Pods
rm -Rf ios/.symlinks
rm -Rf ios/Flutter/Flutter.framework
rm -Rf ios/Flutter/Flutter.podspec
rm -Rf ios/Podfile.lock
pod cache clean --all
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
cd ios
rm -Rf ios/Podfile.lock
cd ..
flutter build ios --release --flavor dev
```

```bash
arch -x86_64 rm -rf Podfile.lock
arch -x86_64 pod install --repo-update
```

If you are getting an error on M1 processors, try this command.

```bash
sudo arch -x86_64 gem install ffi
```

### Android fingerprint 

#### For dev
```bash
keytool -genkeypair -v \
  -keystore android/secrets/gigbuddy-dev-release-key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias gigbuddy_dev_key_alias
```

```bash
keytool -list -v \
  -keystore android/secrets/gigbuddy-dev-release-key.jks \
  -alias gigbuddy_dev_key_alias
```


#### For prod
```bash
keytool -genkeypair -v \
  -keystore android/secrets/gigbuddy-prod-release-key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias gigbuddy_prod_key_alias
```

```bash
keytool -list -v \
  -keystore android/secrets/gigbuddy-prod-release-key.jks \
  -alias gigbuddy_prod_key_alias    
```

