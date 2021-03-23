import { NativeModules, Dimensions } from 'react-native';
const { width, height } = Dimensions.get('window');
const { MultipleImagePicker } = NativeModules;

let exportObject = {};

let defaultOptions = {
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
  selectedColor: '#30475e',
  maximumMessageTitle: 'Notification',
  maximumMessage: 'You have selected the maximum number of media allowed',
  maximumVideoMessage: 'You have selected the maximum number of video allowed',
  messageTitleButton: 'OK',
  cancelTitle: 'Cancel',
  tapHereToChange: 'Tap here to change',

  //****//

  //**Android**//

  //****//

  //**Both**//
  usedCameraButton: true,
  allowedVideo: true,
  allowedPhotograph: true, // for camera : allow this option when you want to take a photos
  allowedVideoRecording: true, //for camera : allow this option when you want to recording video.
  maxVideoDuration: 60, //for camera : max video recording duration
  numberOfColumn: 3,
  maxSelectedAssets: 20,
  singleSelectedMode: false,
  doneTitle: 'Done',
  isPreview: true,
  mediaType: 'all',
  isExportThumbnail: false,
  maxVideo: 20,
  //****//

  // fetchOption: Object,
  // fetchCollectionOption: Object,

  // emptyImage: Image,
};

exportObject = {
  openPicker: (optionsPicker) => {
    const options = {
      ...defaultOptions,
      ...optionsPicker,
    };
    return new Promise(async (resolve, reject) => {
      try {
        const response = await MultipleImagePicker.openPicker(options);
        if (response?.length) {
          resolve(response);
          return;
        }
        resolve([]);
      } catch (e) {
        reject(e);
      }
    });
  },
};

export default exportObject;
