export * from './specs/MultipleImagePicker.nitro'
export * from './types'

import { NitroModules } from 'react-native-nitro-modules'

import { type MultipleImagePicker } from './specs/MultipleImagePicker.nitro'

import { processColor, Appearance } from 'react-native'

import {
  Result,
  Config,
  NitroConfig,
  CropResult,
  CropConfig,
  NitroCropConfig,
  PreviewConfig,
  NitroPreviewConfig,
  MediaPreview,
  CameraConfig,
  NitroCameraConfig,
  CameraResult,
  Language,
} from './types'
import { CropError } from './types/error'

const Picker = NitroModules.createHybridObject<MultipleImagePicker>(
  'MultipleImagePicker'
)

type IPromisePicker<T extends Config> = T['selectMode'] extends 'single'
  ? Result
  : Result[]

export async function openPicker<T extends Config>(
  conf: T
): Promise<IPromisePicker<T>> {
  return new Promise((resolved, rejected) => {
    const config = { ...defaultOptions, ...conf } as NitroConfig
    config.primaryColor = processColor(config.primaryColor) as any
    config.backgroundDark = processColor(config.backgroundDark) as any

    if ((config as Config)?.theme === 'system') {
      const theme = Appearance.getColorScheme() ?? 'light'
      config.theme = theme
    }

    config.language = validateLanguage(config.language)

    if (typeof config.crop === 'boolean') {
      config.crop = config.crop ? { ratio: [] } : undefined
    }

    if (config.crop) config.crop.ratio = config.crop?.ratio ?? []

    return Picker.openPicker(
      config,
      (result: Result[]) => {
        resolved(result as IPromisePicker<T>)
      },
      (reject: number) => {
        rejected(reject)
      }
    )
  })
}

export async function openCropper(
  image: string,
  config?: CropConfig
): Promise<CropResult> {
  return new Promise((resolved, rejected) => {
    const cropConfig = {
      presentation: 'fullScreenModal',
      language: 'system',
      ratio: [],
      ...config,
    } as NitroCropConfig

    cropConfig.language = validateLanguage(cropConfig.language)

    return Picker.openCrop(
      image,
      cropConfig,
      (result: CropResult) => {
        resolved(result)
      },
      (error: CropError) => {
        rejected(error)
      }
    )
  })
}

export function openPreview(
  media: MediaPreview[] | Result[],
  index: number = 0,
  conf: PreviewConfig
): void {
  const config: PreviewConfig = {
    language: conf.language ?? 'system',
    ...conf,
  }

  if (config?.language && !LANGUAGES.includes(config.language)) {
    config.language = 'system'
  }

  if (media.length === 0) {
    throw new Error('Media is required')
  }

  return Picker.openPreview(
    media as MediaPreview[],
    index,
    config as NitroPreviewConfig
  )
}

export async function openCamera(config?: CameraConfig): Promise<CameraResult> {
  return new Promise((resolved, rejected) => {
    const cameraConfig = {
      cameraDevice: 'back',
      presentation: 'fullScreenModal',
      language: 'system',
      mediaType: 'all',
      allowLocation: true,
      isSaveSystemAlbum: false,
      color: processColor(config?.color ?? primaryColor) as any,
      ...config,
    } as NitroCameraConfig

    cameraConfig.language = validateLanguage(cameraConfig.language)

    if (typeof cameraConfig.crop === 'boolean') {
      cameraConfig.crop = cameraConfig.crop ? { ratio: [] } : undefined
    }

    if (cameraConfig.crop && !cameraConfig.crop?.ratio)
      cameraConfig.crop.ratio = []

    return Picker.openCamera(
      cameraConfig,
      (result: CameraResult) => {
        resolved(result)
      },
      (error: number) => {
        rejected(error)
      }
    )
  })
}

const DEFAULT_COUNT = 20

const validateLanguage = (language?: Language): Language => {
  if (!language || !LANGUAGES.includes(language)) {
    return 'system'
  }
  return language
}

const primaryColor = '#FB9300'

export const defaultOptions: Config = {
  maxSelect: DEFAULT_COUNT,
  maxVideo: DEFAULT_COUNT,
  primaryColor,
  backgroundDark: '#2f2f2f',
  allowedLimit: true,
  numberOfColumn: 3,
  isPreview: true,
  mediaType: 'all',
  selectedAssets: [],
  selectBoxStyle: 'number',
  selectMode: 'multiple',
  presentation: 'fullScreenModal',
  language: 'system',
  theme: 'system',
  isHiddenOriginalButton: false,
  allowSwipeToSelect: true,
  camera: {
    cameraDevice: 'back',
    videoMaximumDuration: 60,
  },
}

const LANGUAGES = [
  'system',
  'zh-Hans',
  'zh-Hant',
  'ja',
  'ko',
  'en',
  'th',
  'id',
  'vi',
  'ru',
  'de',
  'fr',
  'ar',
] as const
