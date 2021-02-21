# React Native Multiple Image Picker (RNMIP)

React Native Multiple Image Picker enables application to pick images and videos from multiple smart album in iOS/Android, similar to the current Facebook App. React Native Multiple Image Picker is based on two libraries available, [TLPhotoPicker](https://github.com/tilltue/TLPhotoPicker) and [PictureSelector](https://github.com/LuckSiege/PictureSelector)

## Demo 👉👈

## Installation

```sh
npm install react-native-multiple-image-picker
```

## Usage

```js
import MultipleImagePicker from "react-native-multiple-image-picker";

// ...
const response = await MultipleImagePicker.openPicker(options);
```
## Features

- support smart album collection. 
  - camera roll, selfies, panoramas, favorites, videos, custom users album
- selected order index.
- playback video and live photos.
  - just one. playback first video or live Photo in bounds of visible cell.
- display video duration.
- async phasset request and displayed cell.
  - scrolling performance is better than facebook in displaying video assets collection.
- custom cell
- custom display and selection rules
- reload of changes that occur in the Photos library.
- support iCloud Photo Library
- preview photo.
- crop photo (next version)
...etc

## Response

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
