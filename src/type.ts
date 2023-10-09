import { Image } from 'react-native';

export enum MediaType {
  VIDEO = 'video',
  IMAGE = 'image',
  ALL = 'all',
}

export type Result = {
  path: string;
  fileName: string;
  localIdentifier: string;
  width: number;
  height: number;
  mime: string;
  size: number;
  bucketId?: number;
  realPath?: string;
  parentFolderName?: string;
  creationDate?: string;
};

export interface VideoResult extends Result {
  type: MediaType.VIDEO;
  thumbnail?: string;
}

export interface ImageResult extends Result {
  type: MediaType.IMAGE;
  thumbnail?: undefined;
}

export type PickerErrorCode =
  | 'PICKER_CANCELLED'
  | 'NO_LIBRARY_PERMISSION'
  | 'NO_CAMERA_PERMISSION';

export type Options<T extends MediaType = MediaType.ALL> = {
  mediaType?: T;
  isPreview?: boolean;
  isExportThumbnail?: boolean;
  selectedColor?: string;
  tapHereToChange?: string;
  cancelTitle?: string;
  doneTitle?: string;
  emptyMessage?: string;
  emptyImage?: Image;
  selectMessage?: string;
  deselectMessage?: string;
  usedCameraButton?: boolean;
  usedPrefetch?: boolean;
  previewAtForceTouch?: boolean;
  allowedLivePhotos?: boolean;
  allowedVideo?: boolean;
  allowedAlbumCloudShared?: boolean;
  allowedPhotograph?: boolean; // for camera ?: allow this option when you want to take a photos
  allowedVideoRecording?: boolean; //for camera ?: allow this option when you want to recording video.
  maxVideoDuration?: Number; //for camera ?: max video recording duration
  autoPlay?: boolean;
  muteAudio?: boolean;
  preventAutomaticLimitedAccessAlert?: boolean; // newest iOS 14
  numberOfColumn?: number;
  maxSelectedAssets?: number;
  fetchOption?: Object;
  fetchCollectionOption?: Object;
  maximumMessageTitle?: string;
  maximumMessage?: string;
  messageTitleButton?: string;
  //resize thumbnail
  thumbnailWidth?: number;
  thumbnailHeight?: number;
  haveThumbnail?: boolean;
};

export interface SinglePickerOptions {
  selectedAssets?: Result;
  singleSelectedMode: true;
}

export interface MultiPickerOptions {
  selectedAssets?: Result[];
  singleSelectedMode?: false;
}

interface MediaTypeOption {
  [MediaType.VIDEO]: { isExportThumbnail?: boolean };
  [MediaType.ALL]: MediaTypeOption[MediaType.VIDEO];
}

export interface MediaTypeResult {
  [MediaType.IMAGE]: ImageResult;
  [MediaType.VIDEO]: VideoResult;
  [MediaType.ALL]: ImageResult | VideoResult;
}

export type IOpenPicker = <T extends MediaType = MediaType.ALL>(
  options: MultiPickerOptions & MediaTypeOption & Options<T>
) => Promise<MediaTypeResult[T][]>;
