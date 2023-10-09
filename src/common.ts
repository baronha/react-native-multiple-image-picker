import { Dimensions } from 'react-native';

export const { width, height } = Dimensions.get('window');

export const pickerOptionDefault = {
  //**iOS**//
  usedPrefetch: false,
  allowedAlbumCloudShared: false,
  muteAudio: true,
  autoPlay: true,
  //resize thumbnail
  haveThumbnail: true,

  thumbnailWidth: Math.round(width / 2),
  thumbnailHeight: Math.round(height / 2),
  allowedLivePhotos: true,
  preventAutomaticLimitedAccessAlert: true, // newest iOS 14
  emptyMessage: 'No albums',
  selectMessage: 'Select',
  deselectMessage: 'Deselect',
  selectedColor: '#FB9300',
  maximumMessageTitle: 'Notification',
  maximumMessage: 'You have selected the maximum number of media allowed',
  maximumVideoMessage: 'You have selected the maximum number of video allowed',
  messageTitleButton: 'OK',
  cancelTitle: 'Cancel',
  tapHereToChange: 'Tap here to change',

  //**Both**//
  usedCameraButton: true,
  allowedVideo: true,
  allowedPhotograph: true, // for camera : allow this option when you want to take a photos
  allowedVideoRecording: false, //for camera : allow this option when you want to recording video.
  maxVideoDuration: 60, //for camera : max video recording duration
  numberOfColumn: 3,
  maxSelectedAssets: 20,
  doneTitle: 'Done',
  isPreview: true,
  mediaType: 'all',
  isExportThumbnail: false,
  maxVideo: 20,
  selectedAssets: [],
  singleSelectedMode: false,
  isCrop: false,
  isCropCircle: false,
};
