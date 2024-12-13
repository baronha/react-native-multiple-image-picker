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

export type MediaType = 'video' | 'image' | 'all'

export type CropRatio = { title?: string; width: number; height: number }
