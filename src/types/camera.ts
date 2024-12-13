import { Language, MediaType, PickerCropConfig, Presentation } from './config'

export type CameraResult = {
  path: string
}

export type CameraType = 'custom' | 'system'

export type NitroCameraConfig = {
  mediaType: MediaType

  language: Language

  presentation: Presentation

  allowsEditing?: boolean

  cameraType: CameraType

  crop?: PickerCropConfig
}

export interface CameraConfig
  extends Omit<
    NitroCameraConfig,
    'language' | 'mediaType' | 'presentation' | 'cameraType'
  > {
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

  cameraType?: CameraType
}
