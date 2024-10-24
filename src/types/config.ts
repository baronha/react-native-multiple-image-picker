import { ColorValue } from 'react-native'
import { Result } from './result'

export type SelectBoxStyle = 'number' | 'tick'

export type SelectMode = 'single' | 'multiple'

export type MediaType = 'video' | 'image' | 'all'

export type Presentation = 'fullScreenModal' | 'formSheet'

export type Language =
  | 'system'
  | 'simplifiedChinese'
  | 'traditionalChinese'
  | 'japanese'
  | 'korean'
  | 'english'
  | 'thai'
  | 'indonesia'
  | 'vietnamese'
  | 'russian'
  | 'german'
  | 'french'
  | 'arabic'

export type CropConfig = {
  circle?: boolean
}

export interface Text {
  finish?: string
  original?: string
  preview?: string
}

export interface NitroConfig {
  mediaType: MediaType

  selectedAssets: Result[]

  selectBoxStyle: SelectBoxStyle

  selectMode: SelectMode

  numberOfColumn?: number

  isPreview?: boolean

  primaryColor?: number

  allowedCamera?: boolean

  allowSwipeToSelect?: boolean

  spacing?: number

  isHiddenPreviewButton?: boolean

  isHiddenOriginalButton?: boolean

  isShowPreviewList?: boolean

  allowHapticTouchPreview?: boolean

  isShowAssetNumber?: boolean

  allowedLimit?: boolean

  maxPhoto?: number

  maxVideo?: number

  maxSelect?: number

  maxVideoDuration?: number

  minVideoDuration?: number

  maxFileSize?: number

  videoQuality?: number

  imageQuality?: number

  presentation: Presentation

  text?: Text

  language: Language

  crop?: CropConfig
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
  > {
  mediaType?: MediaType
  selectedAssets?: Result[]
  selectBoxStyle?: SelectBoxStyle
  selectMode?: SelectMode
  primaryColor?: ColorValue
  presentation?: Presentation
  language?: Language
}
