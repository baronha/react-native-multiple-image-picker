# React Native Multiple Image Picker (RNMIP)

<p align="center">
  <img src="./files/banner.png" width="100%">
</p>

React Native Multiple Image Picker enables application to pick images and videos from multiple smart album in iOS/Android, similar to the current Facebook App. React Native Multiple Image Picker is based on two libraries available, [TLPhotoPicker](https://github.com/tilltue/TLPhotoPicker) and [PictureSelector](https://github.com/LuckSiege/PictureSelector)

## Demo 👉👈

| iOS | Android  |
| ------------- | ------------- |
| <img src="./files/demo-main-ios.gif" height="720px">  |  <img src="./files/demo-main-android.gif" height="720px">  |

## Installation

```sh
npm install react-native-multiple-image-picker
```

### iOS
> Don't forget the Privacy Description in `info.plist`.
<img src="./files/privacy-iOS.png">

```sh
cd ios/ && pod install
```

### Android
> Add Permission in `AndroidManifest.xml`
```xml
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## Usage
See [Options](Options)
```js
import MultipleImagePicker from "react-native-multiple-image-picker";
// ...
const response = await MultipleImagePicker.openPicker(options);
```
## Features

- [x] support smart album collection. 
- [x] camera roll, selfies, panoramas, favorites, videos, custom users album
- [x] selected order index.
- [x] playback video and live photos.
- [x] just one. playback first video or live Photo in bounds of visible cell.
- [x] display video duration.
- [x] async phasset request and displayed cell.
- [x] scrolling performance is better than facebook in displaying video assets collection.
- [x] reload of changes that occur in the Photos library.
- [x] preview photo.
- [ ] crop photo (next version)
- [ ] multiple croping photo (only Android) (next version)
...etc

### Options (updating)

### Callback (updating)

#### selectedAssets (Important / updating)

### Callback (updating)

#### Thumbnail (updating)

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
