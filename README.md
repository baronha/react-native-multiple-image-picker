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
npm i @baronha/react-native-multiple-image-picker
or
yarn add @baronha/react-native-multiple-image-picker
```

### iOS
> Don't forget the Privacy Description in `info.plist`.
<img src="./files/privacy-iOS.png">

```sh
cd ios/ && pod install
```
## issue
For sure, you will get this error when launching the application
<img src="./files/error-iOS.png">

Dont worry, You just need to go to `Pods/Pods/TLPhotoPicker/TLPhotosPickerViewController.swift` and comment all lines, like this: 

<img src="./files/resolve-error-iOS.png">
I will fix it soon in the future.

### Android
> Add Permission in `AndroidManifest.xml`
```xml
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## Usage
See [options](#Options)
```js
import MultipleImagePicker from "react-native-multiple-image-picker";
// ...
const response = await MultipleImagePicker.openPicker(options);
```
## Features

- [x] Selected order index. 
- [x] Support smart album collection. 
- [x] Camera roll, selfies, panoramas, favorites, videos, custom users album
- [x] Support Camera
- [x] Playback video and live photos.
- [x] Just one. playback first video or live Photo in bounds of visible cell.
- [x] Display video duration.
- [x] Async phasset request and displayed cell.
- [x] Scrolling performance is better than facebook in displaying video assets collection.
- [x] Reload of changes that occur in the Photos library.
- [x] Preview photo.
...etc

## Options

| Property                         |       Type   | Default value |  Platform  | Description                              |
| -------------------------------- | :----------: | :-----------: | :--------: | :--------------------------------------- |
| usedCameraButton                 | bool         | true          | Both       | Show camera button in first row                     |
| allowedVideo                     | bool         | true          | Both       | Allows to select videos. If false, only the image will be displayed |
| maxVideoDuration                 | number       | 60            | Both       | Show only video with time allowed (in seconds) |
| numberOfColumn                   | number       | 3             | Both       | Number of columns in a row |
| maxSelectedAssets                | number       | 20            | Both       | Maximum number of one selection |
| singleSelectedMode               | bool         | false         | Both       | Only one image / video can be selected |
| [selectedAssets](#selectedAssets)| Array        | undefined     | Both       | Images / Videos selected to mark |
| doneTitle                        | string       | Done          | Both       | Title in button Done |
| cancelTitle                      | string       | Cancel        | Both       | Title in button Cancel |
| selectedColor                    | string       | #30475e       | Both       | The color of the mark in the row when the user selected |
| autoPlay                         | bool         | true          | iOS        | Auto play video |
| allowedLivePhotos                | bool         | true          | iOS        | Allowed Live Photos type  |
| haveThumbnail                    | bool         | true          | iOS        | Export thumbnail object  |
| thumbnailWidth                   | number       | Dimensions.get('window').width/2  | iOS | Thumbnail width |
| thumbnailHeight                  | number       | Dimensions.get('window').height/2 | iOS | Thumbnail height |
| emptyMessage                     | string       | No albums     | iOS        | Show string when gallery empty   |
| maximumMessageTitle              | string       | Notification  | iOS        | The title of the alert when the user chooses to exceed the specified number of pictures |
| messageTitleButton               | string       | Notification  | iOS        | The title of button in the alert when the user chooses to exceed the specified number of pictures |
| maximumMessage                   | string       | You have selected the maximum number of media allowed  | iOS | The description of the alert when the user chooses to exceed the specified number of pictures|
| tapHereToChange                  | string       | Tap here to change          | iOS | The title in navigation bar |

#### selectedAssets (Important)
``` updating... ```
## Callback
``` updating... ```
#### Thumbnail (iOS only)

## To Do
- [ ] Crop photo.
- [ ] Multiple croping photo (Android only).
- [ ] Video Compression
- [ ] [Solve iOS error](##issue)

## Performance

We're trying to improve performance. If you have a better solution, please open a [issue](https://github.com/baronha/react-native-multiple-image-picker/issues)
or [pull request](https://github.com/baronha/react-native-multiple-image-picker/pulls). Best regards!

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
