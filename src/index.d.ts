import { NativeModules, Image } from 'react-native';

export enum MediaType {
  VIDEO = 'video',
  IMAGE = 'image',
  ALL = 'all',
}

export type Results = {
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

export interface VideoResults extends Results {
  type: MediaType.VIDEO;
  thumbnail?: string;
}

export interface ImageResults extends Results {
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
  selectedAssets?: Results;
  singleSelectedMode: true;
}

export interface MultiPickerOptions {
  selectedAssets?: Results[];
  singleSelectedMode?: false;
}

interface MediaTypeOptions {
  [MediaType.VIDEO]: { isExportThumbnail?: boolean };
  [MediaType.ALL]: MediaTypeOptions[MediaType.VIDEO];
}

interface MediaTypeResults {
  [MediaType.IMAGE]: ImageResults;
  [MediaType.VIDEO]: VideoResults;
  [MediaType.ALL]: ImageResults | VideoResults;
}

type MultipleImagePickerType = {
  openPicker<T extends MediaType = MediaType.ALL>(
    options: MultiPickerOptions & MediaTypeOptions[T] & Options<T>
  ): Promise<MediaTypeResults[T][]>;
  openPicker<T extends MediaType = MediaType.ALL>(
    options: SinglePickerOptions & MediaTypeOptions[T] & Options<T>
  ): Promise<MediaTypeResults[T]>;
};

const { MultipleImagePicker } = NativeModules;

export default MultipleImagePicker as MultipleImagePickerType;
