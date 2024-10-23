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
  isExportThumbnail?: boolean

  primaryColor?: number
  deselectMessage?: string
  allowedCamera?: boolean

  allowedLivePhotos?: boolean
  allowedVideo?: boolean

  allowedPhotograph?: boolean // for camera ?: allow this option when you want to take a photos
  allowedVideoRecording?: boolean //for camera ?: allow this option when you want to recording video.

  messageTitleButton?: string
  //resize thumbnail
  thumbnailWidth?: number
  thumbnailHeight?: number
  haveThumbnail?: boolean

  singleSelectedMode?: boolean

  allowSwipeToSelect?: boolean

  isCrop?: boolean

  isCropCircle?: boolean

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

  compressQuality?: number

  videoQuality?: number

  imageQuality?: number

  presentation: Presentation

  text?: Text

  language: Language
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
