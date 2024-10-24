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

type IPromisePicker<T extends Config> = T['selectMode'] extends 'single'
  ? Result
  : Result[]

export async function openPicker<T extends Config>(
  conf: T
): Promise<IPromisePicker<T>> {
  return new Promise((resolved, rejected) => {
    const config = { ...defaultOptions, ...conf } as NitroConfig
    config.primaryColor = processColor(config.primaryColor) as any

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

const defaultOptions: Config = {
  primaryColor: '#FB9300',
  allowedCamera: true,
  allowedLimit: true,
  numberOfColumn: 3,
  isPreview: true,
  mediaType: 'all',
  selectedAssets: [],
  selectBoxStyle: 'number',
  selectMode: 'multiple',
  isShowAssetNumber: false,
  maxPhoto: 20,
  maxFileSize: 0,
  presentation: 'fullScreenModal',
  language: 'system',
}
