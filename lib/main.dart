name: Build APK
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          flutter-version: '3.19.0'

      - name: Build App
        run: |
          flutter pub get
          flutter build apk --release --no-tree-shake-icons
      
      - name: Upload Finished APK
        uses: actions/upload-artifact@v4
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/app-release.apk
