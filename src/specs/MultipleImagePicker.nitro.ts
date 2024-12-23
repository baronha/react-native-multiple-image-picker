import { type HybridObject } from 'react-native-nitro-modules'
import {
  CameraResult,
  CropResult,
  MediaPreview,
  NitroCameraConfig,
  NitroConfig,
  NitroCropConfig,
  NitroPreviewConfig,
  PickerResult,
} from '../types'

export interface MultipleImagePicker
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  openPicker(
    config: NitroConfig,
    resolved: (result: PickerResult[]) => void,
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
    resolved: (result: CameraResult) => void,
    rejected: (reject: number) => void
  ): void
}
