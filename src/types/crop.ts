import { Language, Presentation } from './config'

export type CropRatio = { title?: string; width: number; height: number }

/**
 * Configuration for image cropping
 * @interface PickerCropConfig
 */
export type PickerCropConfig = {
  /** Enable circular crop mask */
  circle?: boolean

  ratio: CropRatio[]

  /**
   * Default ratio to be selected when opening the crop interface.
   * If not specified, the first ratio in the list will be selected.
   *
   * @platform ios, android
   *
   * @example
   * ```ts
   * // Custom ratio without title
   * defaultRatio: { width: 4, height: 3 }
   */
  defaultRatio?: CropRatio

  /** Enable free style cropping */
  freeStyle?: boolean
}

// CROP
export interface NitroCropConfig extends PickerCropConfig {
  /**
   * Interface language
   * @type {Language}
   */
  language: Language

  presentation: Presentation
}

export interface CropConfig
  extends Omit<NitroCropConfig, 'language' | 'presentation' | 'ratio'> {
  /**
   * Language options for the picker.
   *
   * @platform ios
   *
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
   * Array of aspect ratios for image cropping. The ratios will be inserted after the default ratios (Original and Square).
   * Android: Maximum: 4 items
   *
   * @platform ios, android
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
   *   {  width: 12, height: 11 }
   * ]
   * ```
   */
  ratio?: CropRatio[]
}

export interface CropResult {
  path: string
  width: number
  height: number
}
