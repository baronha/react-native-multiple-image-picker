import { ColorValue } from 'react-native'
import { Result } from './result'

export type Theme = 'light' | 'dark'

export type Presentation = 'fullScreenModal' | 'formSheet'

export type Language =
  | 'system'
  | 'zh-Hans'
  | 'zh-Hant'
  | 'ja'
  | 'ko'
  | 'en'
  | 'th'
  | 'id'
  | 'vi'
  | 'ru'
  | 'de'
  | 'fr'
  | 'ar'

export type SelectBoxStyle = 'number' | 'tick'

export type SelectMode = 'single' | 'multiple'

export type MediaType = 'video' | 'image' | 'all'

/**
 * Configuration for image cropping
 * @interface PickerCropConfig
 */
export type PickerCropConfig = {
  /** Enable circular crop mask */
  circle?: boolean
}

/**
 * Custom text labels for buttons and headers
 * @interface Text
 */
export interface Text {
  /** Text for finish/done button */
  finish?: string
  /** Text for original button */
  original?: string
  /** Text for preview button */
  preview?: string
  /** Text for edit button */
  edit?: string
}

/**
 * Main configuration interface for the Nitro image picker
 * @interface NitroConfig
 */
export interface NitroConfig {
  /**
   * Type of media to display in picker
   * @type {MediaType}
   */
  mediaType: MediaType

  /**
   * Array of currently selected assets
   * @type {Result[]}
   */
  selectedAssets: Result[]

  /**
   * Style of the selection box
   * @type {SelectBoxStyle}
   */
  selectBoxStyle: SelectBoxStyle

  /**
   * Selection mode for picker
   * @type {SelectMode}
   */
  selectMode: SelectMode

  /**
   * Number of columns in the grid view
   * @type {number}
   */
  numberOfColumn?: number

  /**
   * Enable preview functionality
   * @type {boolean}
   */
  isPreview?: boolean

  /**
   * Primary color value in number format
   * @type {number}
   */
  primaryColor?: number

  /**
   * Enable camera functionality
   * @type {boolean}
   */
  allowedCamera?: boolean

  /**
   * Enable swipe gesture for selection
   * @type {boolean}
   */
  allowSwipeToSelect?: boolean

  /**
   * Spacing between items in the grid
   * @type {number}
   */
  spacing?: number

  /**
   * Hide the preview button and button mode
   * @type {boolean}
   */
  isHiddenPreviewButton?: boolean

  /**
   * Hide the original button
   * @type {boolean}
   */
  isHiddenOriginalButton?: boolean

  /**
   * Show preview list
   * @type {boolean}
   * @platform ios
   */
  isShowPreviewList?: boolean

  /**
   * Enable haptic feedback on preview
   * @type {boolean}
   * @platform ios
   */
  allowHapticTouchPreview?: boolean

  /**
   * Show asset numbers
   * @type {boolean}
   */
  isShowAssetNumber?: boolean

  /**
   * Enable selection limit
   * @type {boolean}
   */
  allowedLimit?: boolean

  /**
   * Maximum number of videos allowed
   * @type {number}
   */
  maxVideo?: number

  /**
   * Maximum number of items that can be selected
   * @type {number}
   */
  maxSelect?: number

  /**
   * Maximum duration for videos in seconds
   * @type {number}
   */
  maxVideoDuration?: number

  /**
   * Minimum duration for videos in seconds
   * @type {number}
   */
  minVideoDuration?: number

  /**
   * Maximum file size in bytes
   * @type {number}
   */
  maxFileSize?: number

  /**
   * Video quality setting for the picker.
   * Platform-specific quality settings:
   *
   * @type {number}
   * @platform ios, android
   *
   * @ios
   * - Range: 0 to 1
   * - 0: Maximum compression, lowest quality
   * - 1: No compression, highest quality
   *
   * @android
   * - Only two options:
   * - 0: Low quality
   * - 1: High quality
   *
   * @default 1
   *
   * @example
   * ```ts
   * // iOS: 80% quality
   * // Android: High quality (1) or Low quality (0)
   * videoQuality: 0.8  // iOS: 80% quality, Android: Low quality
   * videoQuality: 1    // Both platforms: Highest quality
   * ```
   *
   * @remarks
   * - iOS supports continuous range from 0 to 1
   * - Android only supports two discrete values: 0 (low) or 1 (high)
   * - Values between 0 and 1 on Android will be rounded
   */
  videoQuality?: number

  /**
   * Image quality setting for the picker.
   * Determines the compression level of the selected images.
   *
   * @type {number}
   * @value 0 - 1
   *
   * @default 1
   * @platform ios
   * @todo Add support for Android platform
   *
   * @example
   * ```ts
   * imageQuality: 0.8 // 80% quality
   * ```
   *
   * @remarks
   * - Adjust this value to balance between image quality and file size.
   * - Useful for optimizing performance and storage usage.
   */
  imageQuality?: number

  /**
   * Background color for dark mode in number format
   * @type {number}
   */
  backgroundDark?: number

  /**
   * Configuration options for image cropping functionality.
   *
   * @type {PickerCropConfig}
   * @property {boolean} [circle] - Enable circular crop mask for profile pictures
   *
   * @example
   * ```ts
   * // -> Enable basic cropping with default settings
   * crop: {}
   *
   * // -> Enable cropping with circle crop mask
   * crop: {
   *   circle: true,
   * }
   * ```
   *
   * @platform ios, android
   */
  crop?: PickerCropConfig

  /**
   * Custom text labels for various UI elements in the picker.
   * Allows customization of button labels and headers to support localization and branding.
   *
   * @type {Text}
   * @property {string} [finish] - Label for the finish/done button
   * @property {string} [original] - Label for the original button
   * @property {string} [preview] - Label for the preview button
   * @property {string} [edit] - Label for the edit button
   *
   * @example
   * ```ts
   * text: {
   *   finish: 'Complete',
   *   original: 'Original',
   *   preview: 'Preview',
   *   edit: 'Edit'
   * }
   * ```
   *
   * @remarks
   * - All properties are optional and will use default values if not specified
   * - Useful for localization and customizing the user interface
   */
  text?: Text

  /**
   * Interface language
   * @type {Language}
   */
  language: Language

  /**
   * Theme mode
   * @type {Theme}
   */
  theme: Theme

  presentation: Presentation
}

export interface Config
  extends Omit<
    NitroConfig,
    | 'selectedAssets'
    | 'mediaType'
    | 'selectMode'
    | 'selectBoxStyle'
    | 'primaryColor'
    | 'presentation'
    | 'language'
    | 'theme'
    | 'backgroundDark'
  > {
  /**
   * Type of media to be displayed
   * @typedef {'video' | 'image' | 'all'} MediaType
   */
  mediaType?: MediaType

  /**
   * Array of currently selected assets
   * @type {Result[]}
   */
  selectedAssets?: Result[]

  /**
   * Style of selection box in the picker
   * @typedef {'number' | 'tick'} SelectBoxStyle
   */
  selectBoxStyle?: SelectBoxStyle

  /**
   * Mode of selection in the picker
   * @typedef {'single' | 'multiple'} SelectMode
   */
  selectMode?: SelectMode

  /**
   * Primary color for the picker UI elements.
   * Accepts various color formats:
   * - Hex strings: '#RGB', '#RGBA', '#RRGGBB', '#RRGGBBAA'
   * - RGB/RGBA strings: 'rgb(255, 0, 0)', 'rgba(255, 0, 0, 0.5)'
   * - Named colors: 'red', 'blue', etc.
   * - Numbers for RGB values
   *
   * @platform ios, android
   * @type {ColorValue}
   * @example
   * ```ts
   * primaryColor: '#FF0000'
   * primaryColor: 'rgb(255, 0, 0)'
   * primaryColor: 'red'
   * ```
   */
  primaryColor?: ColorValue

  /**
   * Modal presentation style for the picker.
   * - 'fullScreenModal': Opens picker in full screen
   * - 'formSheet': Opens picker in a form sheet style
   *
   * @platform ios
   * @default 'fullScreenModal'
   * @type {Presentation}
   * @example
   * ```ts
   * presentation: 'formSheet'
   * ```
   */
  presentation?: Presentation

  /**
   * Language options for the picker.
   * @description
   * - 'system': 🌐 System default
   * - 'zh-Hans': 🇨🇳 Simplified Chinese
   * - 'zh-Hant': 🇹🇼 Traditional Chinese
   * - 'ja': 🇯🇵 Japanese
   * - 'ko': 🇰🇷 Korean
   * - 'en': 🇬🇧 English
   * - 'th': 🇹🇭 Thai
   * - 'id': 🇮🇩 Indonesian
   * - 'vi': 🇻🇳 Vietnamese (My Country)
   * - 'ru': 🇷🇺 Russian
   * - 'de': 🇩🇪 German
   * - 'fr': 🇫🇷 French
   * - 'ar': 🇸🇦 Arabic
   */
  language?: Language

  /**
   * Theme mode for the picker.
   * - 'light': Uses light theme
   * - 'dark': Uses dark theme
   * - 'system': Uses system default theme
   *
   * @platform ios, android
   * @default 'system'
   * @type {'light' | 'dark' | 'system'}
   */
  theme?: Theme | 'system'

  /**
   * Background color for dark mode UI elements.
   * Accepts various color formats:
   * - Hex strings: '#RGB', '#RGBA', '#RRGGBB', '#RRGGBBAA'
   * - RGB/RGBA strings: 'rgb(255, 0, 0)', 'rgba(255, 0, 0, 0.5)'
   * - Named colors: 'red', 'blue', etc.
   * - Numbers for RGB values
   *
   * @platform ios, android
   * @type {ColorValue}
   * @example
   * ```ts
   * backgroundDark: '#000000'
   * backgroundDark: 'rgb(0, 0, 0)'
   * backgroundDark: 'black'
   * ```
   */
  backgroundDark?: ColorValue
}
