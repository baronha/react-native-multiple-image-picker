import { NativeModules, Image } from 'react-native';

export type Results = {
  path: string;
  filename: string;
  localIdentifier: string;
  width: number;
  height: number;
  mime: string;
  type: string;
  thumbnail?: string;
  creationDate?: string;
};

export type Options = {
  isPreview?: boolean;
  selectedColor?: string;
  selectedAssets?: Results[];
  tapHereToChange?: string;
  cancelTitle?: string;
  doneTitle?: string;
  emptyMessage?: string;
  emptyImage?: Image;
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
  mediaType?: string;
  numberOfColumn?: number;
  maxSelectedAssets?: number;
  fetchOption?: Object;
  fetchCollectionOption?: Object;
  singleSelectedMode?: boolean;
  maximumMessageTitle?: string;
  maximumMessage?: string;
  messageTitleButton?: string;
  //resize thumbnail
  thumbnailWidth?: number;
  thumbnailHeight?: number;
  haveThumbnail?: boolean;
};

type MultipleImagePickerType = {
  openPicker(options: Options): Promise<Results[]>;
};

const { MultipleImagePicker } = NativeModules;

export default MultipleImagePicker as MultipleImagePickerType;
