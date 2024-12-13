import { CropRatio, Language, MediaType, Presentation } from './config'
import { PickerCropConfig } from './crop'

export type CameraDevice = 'front' | 'back'

export type PickerCameraConfig = {
  /**
   * Type of camera
   * @typedef {'front' | 'back'} CameraDevice
   */
  cameraDevice: CameraDevice

  /**
   * Maximum duration of video
   * @type {number}
   */
  videoMaximumDuration?: number
}

export interface NitroCameraConfig extends PickerCameraConfig {
  mediaType: MediaType

  presentation: Presentation

  language: Language

  crop?: PickerCropConfig

  /**
   * Save image to system album
   * @type {boolean}
   */
  isSaveSystemAlbum?: boolean

  /**
   * Allow location
   * @type {boolean}
   */
  allowLocation?: boolean
}

export interface CameraConfig
  extends Omit<
    NitroCameraConfig,
    'cameraDevice' | 'mediaType' | 'language' | 'presentation' | 'crop'
  > {
  /**
   * Type of camera
   * @typedef {'front' | 'back'} CameraDevice
   */
  cameraDevice?: CameraDevice

  /**
   * Type of media to be displayed
   * @typedef {'video' | 'image' | 'all'} MediaType
   */
  mediaType?: MediaType

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

  crop?: Omit<PickerCropConfig, 'ratio'> & {
    /**
     * Array of aspect ratios for image cropping. The ratios will be inserted after the default ratios (Original and Square).
     * Android: Maximum: 4 items
     *
     * @platform ios, Android
     *
     * @property {Array<CropRatio>} ratio - Array of custom aspect ratios
     * @property {string} [ratio[].title] - Optional display title for the ratio (e.g., "16:9"). If not provided, will use "width/height"
     * @property {number} ratio[].width - Width value for aspect ratio
     * @property {number} ratio[].height - Height value for aspect ratio
     *
     * @example
     * ```ts
     * ratio: [
     *   { title: "Instagram", width: 1, height: 1 },
     *   { title: "Twitter", width: 16, height: 9 },
     *   { width: 12, height: 11 }
     * ]
     * ```
     */
    ratio?: CropRatio[]

    /**
     * Camera configuration
     * @type {CameraConfig}
     */
  }
}

export interface CameraResult {
  path: string
}
