import { type HybridObject } from 'react-native-nitro-modules'
import {
  CropResult,
  MediaPreview,
  NitroCameraConfig,
  NitroConfig,
  NitroCropConfig,
  NitroPreviewConfig,
  Result,
} from '../types'

export interface MultipleImagePicker
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  openPicker(
    config: NitroConfig,
    resolved: (result: Result[]) => void,
    rejected: (reject: number) => void
  ): void

  openCrop(
    image: string,
    config: NitroCropConfig,
    resolved: (result: CropResult) => void,
    rejected: (reject: number) => void
  ): void

  openPreview(
    media: MediaPreview[],
    index: number,
    config: NitroPreviewConfig
  ): void

  openCamera(
    config: NitroCameraConfig,
    resolved: (result: Result) => void,
    rejected: (reject: number) => void
  ): void
}
