export * from './specs/MultipleImagePicker.nitro'
export * from './types'

import { NitroModules } from 'react-native-nitro-modules'

import { type MultipleImagePicker } from './specs/MultipleImagePicker.nitro'

import { Dimensions, processColor } from 'react-native'

import { Result, Config, NitroConfig } from './types'

const { width, height } = Dimensions.get('window')

const Picker = NitroModules.createHybridObject<MultipleImagePicker>(
  'MultipleImagePicker'
)

export async function openPicker(conf: Config): Promise<object[]> {
  return new Promise((resolved, rejected) => {
    const config = { ...defaultOptions, ...conf } as NitroConfig
    config.primaryColor = processColor(config.primaryColor) as any

    return Picker.openPicker(
      config,
      (result: Result[]) => {
        console.log('result: ', result)

        resolved([])
      },
      (reject: number) => {
        rejected(reject)
      }
    )
  })
}

const defaultOptions: Config = {
  //**iOS**//

  //resize thumbnail
  haveThumbnail: true,

  thumbnailWidth: Math.round(width / 2),
  thumbnailHeight: Math.round(height / 2),
  allowedLivePhotos: true,
  emptyMessage: 'No albums',
  primaryColor: '#FB9300',

  //****//

  //**Android**//

  //****//

  //**Both**//
  allowedCamera: true,
  allowedVideo: true,
  allowedLimit: true,
  allowedPhotograph: true, // for camera : allow this option when you want to take a photos
  allowedVideoRecording: false, //for camera : allow this option when you want to recording video.
  numberOfColumn: 3,
  isPreview: true,
  mediaType: 'all',
  isExportThumbnail: false,
  selectedAssets: [],
  singleSelectedMode: false,
  isCrop: false,
  isCropCircle: false,
  selectBoxStyle: 'number',
  selectMode: 'multiple',
  isShowAssetNumber: false,
  maxPhoto: 20,
  maxFileSize: 0,
  presentation: 'fullScreenModal',
  language: 'system',
}
