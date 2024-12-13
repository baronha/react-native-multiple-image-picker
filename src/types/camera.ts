import { MediaType } from './config'

export type CameraDevice = 'front' | 'back'

export type PickerCameraConfig = {
  cameraDevice: CameraDevice
  videoMaximumDuration?: number
}

export interface NitroCameraConfig extends PickerCameraConfig {
  mediaType: MediaType
}

export interface CameraConfig
  extends Omit<NitroCameraConfig, 'cameraDevice' | 'mediaType'> {
  /**
   * Type of camera
   * @typedef {'front' | 'back'} CameraDevice
   */
  cameraDevice: CameraDevice

  /**
   * Type of media to be displayed
   * @typedef {'video' | 'image' | 'all'} MediaType
   */
  mediaType: MediaType

  /**
   * Maximum duration of video
   * @type {number}
   */
}
