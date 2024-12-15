![Logo][Logo]

<p align="center">
  <img src="./files/banner.png" width="100%">
</p>

[![iOS][iOS]][iOS-URL] [![Android][Android]][Android-URL] [![Swift][Swift]][Swift-URL] [![Kotlin][Kotlin]][Kotlin-URL] [![React-Native][React-Native]][React-Native-URL]

## Overview 🎇

https://github.com/user-attachments/assets/79580bc7-237c-46b7-b92e-1479cc6d9079

React Native Multiple Image Picker **(RNMIP)** enables application to pick images and videos from multiple smart album in iOS/Android. React Native Multiple Image Picker is based on two libraries available, [HXPhotoPicker](https://github.com/SilenceLove/HXPhotoPicker) and [PictureSelector](https://github.com/LuckSiege/PictureSelector)

## Documentation 📚

## Features 🔥

| 🤩  | ![Logo][Logo]                                                                  |
| --- | ------------------------------------------------------------------------------ |
| 🐳  | Keep the previous selection.                                                   |
| 0️⃣  | Selected order index.                                                          |
| 🎨  | UI Customization (numberOfColumn, spacing, primaryColor ... )                  |
| 🌚  | Dark Mode, Light Mode                                                          |
| 🌄  | Choose multiple images/video.                                                  |
| 📦  | Support smart album `(camera roll, selfies, panoramas, favorites, videos...)`. |
| 📺  | Display video duration.                                                        |
| 🎆  | Preview image/video.                                                           |
| ⛅️ | Support iCloud Photo Library.                                                  |
| 🔪  | Crop single/multiple image (new) ✨                                            |
| 🌪  | Scrolling performance. ☕️                                                      |

## Installation

See more [**Installation**](https://baronha.github.io/react-native-multiple-image-picker/getting-started)

## Usage

Here is a simple usage of the Multiple Image Picker. <br/>
See more [**Config**](https://baronha.github.io/react-native-multiple-image-picker/config)

```typescript
import { openPicker, Config } from '@baronha/react-native-multiple-image-picker'

const config: Config = {
  maxSelect: 10,
  maxVideo: 10,
  primaryColor: '#FB9300',
  backgroundDark: '#2f2f2f',
  numberOfColumn: 4,
  mediaType: 'all',
  selectBoxStyle: 'number',
  selectMode: 'multiple',
  language: 'vi', // 🇻🇳 Vietnamese
  theme: 'dark',
  isHiddenOriginalButton: false,
  primaryColor: '#F6B35D',
}

const onPicker = async () => {
  try {
    const response = await openPicker(config)
    setImages(response)
  } catch (e) {
    // catch error for multiple image picker
  }
}
```

## To Do

- [x] Crop Image in iOS.
- [x] Preview Controller for `iOS`.
- [x] Handle Permission when limited on `iOS`.
- [x] Migrating Library to the New Architecture.
- [x] Multiple Crop Image.
- [x] Multiple Preview Image.
- [x] Dynamic Theme.
- [x] Dynamic Language
- [x] Open Crop Controller.
- [x] Open Preview Controller.
- [ ] Open Camera Controller.

## Sponsor & Support ☕️

To keep this library maintained and up-to-date please consider [sponsoring it on GitHub](https://github.com/sponsors/baronha). Or if you are looking for a private support or help in customizing the experience, then reach out to me on Twitter [@\_baronha](https://twitter.com/_baronha).

## Built With ❤️

[![NitroModules](https://img.shields.io/badge/Nitro_Modules-0052CC?style=for-the-badge)](https://nitro.margelo.com/docs/nitro-modules)
<br/>
[![HXPhotoPicker](https://img.shields.io/badge/HXPhotoPicker-F05138?style=for-the-badge)](https://github.com/SilenceLove/HXPhotoPicker)
<br/>
[![PictureSelector](https://img.shields.io/badge/Picture_Selector-b07219?style=for-the-badge)](https://github.com/LuckSiege/PictureSelector)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=baronha/react-native-multiple-image-picker&type=Date)](https://star-history.com/#bytebase/star-history&Date)

## Performance

We're trying to improve performance. If you have a better solution, please open a [issue](https://github.com/baronha/react-native-multiple-image-picker/issues)
or [pull request](https://github.com/baronha/react-native-multiple-image-picker/pulls). Best regards!

## Contributors ✨

Thanks go to these wonderful people:

<!-- readme: collaborators,contributors -start -->
<table>
	<tbody>
		<tr>
            <td align="center">
                <a href="https://github.com/baronha">
                    <img src="https://avatars.githubusercontent.com/u/23580920?v=4" width="100;" alt="baronha"/>
                    <br />
                    <sub><b>Bảo Hà.</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/itsnyx">
                    <img src="https://avatars.githubusercontent.com/u/74738973?v=4" width="100;" alt="itsnyx"/>
                    <br />
                    <sub><b>Alireza</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/pnthach95">
                    <img src="https://avatars.githubusercontent.com/u/31266357?v=4" width="100;" alt="pnthach95"/>
                    <br />
                    <sub><b>Phạm Ngọc Thạch</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/crockalet">
                    <img src="https://avatars.githubusercontent.com/u/60240500?v=4" width="100;" alt="crockalet"/>
                    <br />
                    <sub><b>crockalet</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/denisbevilacqua">
                    <img src="https://avatars.githubusercontent.com/u/8768794?v=4" width="100;" alt="denisbevilacqua"/>
                    <br />
                    <sub><b>Denis Bevilacqua</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/cd-butterfly">
                    <img src="https://avatars.githubusercontent.com/u/6622823?v=4" width="100;" alt="cd-butterfly"/>
                    <br />
                    <sub><b>cd-butterfly</b></sub>
                </a>
            </td>
		</tr>
		<tr>
            <td align="center">
                <a href="https://github.com/ctrleffive">
                    <img src="https://avatars.githubusercontent.com/u/35224957?v=4" width="100;" alt="ctrleffive"/>
                    <br />
                    <sub><b>Chandu J S</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/jeongshin">
                    <img src="https://avatars.githubusercontent.com/u/64301935?v=4" width="100;" alt="jeongshin"/>
                    <br />
                    <sub><b>Huckleberry</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/shafiqjefri">
                    <img src="https://avatars.githubusercontent.com/u/126740667?v=4" width="100;" alt="shafiqjefri"/>
                    <br />
                    <sub><b>shafiqjefri</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/rxdsrex">
                    <img src="https://avatars.githubusercontent.com/u/21159505?v=4" width="100;" alt="rxdsrex"/>
                    <br />
                    <sub><b>Rajnarayan Dutta</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/vivianlys90">
                    <img src="https://avatars.githubusercontent.com/u/22317616?v=4" width="100;" alt="vivianlys90"/>
                    <br />
                    <sub><b>vivianLee</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/ymane">
                    <img src="https://avatars.githubusercontent.com/u/22021856?v=4" width="100;" alt="ymane"/>
                    <br />
                    <sub><b>Yogesh Mane</b></sub>
                </a>
            </td>
		</tr>
		<tr>
            <td align="center">
                <a href="https://github.com/ouabing">
                    <img src="https://avatars.githubusercontent.com/u/1430376?v=4" width="100;" alt="ouabing"/>
                    <br />
                    <sub><b>abing</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/hieuphan1030">
                    <img src="https://avatars.githubusercontent.com/u/108206954?v=4" width="100;" alt="hieuphan1030"/>
                    <br />
                    <sub><b>hieuphan1030</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/tuanngocptn">
                    <img src="https://avatars.githubusercontent.com/u/22292704?v=4" width="100;" alt="tuanngocptn"/>
                    <br />
                    <sub><b>Nick - Ngoc Pham</b></sub>
                </a>
            </td>
		</tr>
	<tbody>
</table>
<!-- readme: collaborators,contributors -end -->

## License

MIT
<br>
[TLPhotoPicker](https://github.com/tilltue/TLPhotoPicker/blob/master/LICENSE)
<br>
[PictureSelector](https://github.com/LuckSiege/PictureSelector/blob/master/LICENSE)

<!-- Badge for README -->

[iOS]: https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white
[iOS-URL]: https://www.apple.com/ios
[Android]: https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white
[Android-URL]: https://www.android.com/
[React-Native]: https://img.shields.io/badge/React_Native-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-Native-URL]: https://reactnative.dev/
[React-Native]: https://img.shields.io/badge/React_Native-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-Native-URL]: https://reactnative.dev/
[Swift]: https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white
[Swift-URL]: https://developer.apple.com/swift/
[Kotlin]: https://img.shields.io/badge/Kotlin-0095D5?&style=for-the-badge&logo=kotlin&logoColor=white
[Kotlin-URL]: https://kotlinlang.org/
[Logo]: https://img.shields.io/badge/React_Native_Multiple_Image_Picker-DF78C3?style=for-the-badge
