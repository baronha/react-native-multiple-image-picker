import { NativeModules, Dimensions, Platform } from 'react-native';
const { width, height } = Dimensions.get('window');
const { MultipleImagePicker, ImageResizer } = NativeModules;

let exportObject = {};

let defaultOptions = {
  //**iOS**//
  usedPrefetch: false,
  allowedAlbumCloudShared: false,
  muteAudio: true,
  autoPlay: true,
  //resize thumbnail
  thumbnailWidth: Math.round(width / 2),
  thumbnailHeight: Math.round(height / 2),
  haveThumbnail: true,
  allowedLivePhotos: true,
  preventAutomaticLimitedAccessAlert: true, // newest iOS 14
  emptyMessage: 'No albums',
  selectedColor: '#30475e',
  maximumMessageTitle: 'Notification',
  maximumMessage: 'You have selected the maximum number of media allowed',
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
  allowedVideoRecording: false, //for camera : allow this option when you want to recording video.
  maxVideoDuration: 60, //for camera : max video recording duration
  numberOfColumn: 3,
  maxSelectedAssets: 20,
  singleSelectedMode: false,
  doneTitle: 'Done',
  //****//

  // fetchOption: Object,
  // fetchCollectionOption: Object,
  // mediaType: string,
  // emptyImage: Image,
};

const getImageResize = (item, options) => {
  return new Promise((resolve, reject) => {
    ImageResizer.createResizedImage(
      item?.path,
      options?.thumbnailWidth,
      options?.thumbnailHeight,
      'JPEG',
      90,
      0,
      null,
      false,
      {},
      (err, result) => {
        if (err) {
          resolve(item);
        }
        const thumbnail = {
          path: result?.uri,
          width: result?.width,
          height: result?.height,
          name: result?.name,
        };
        resolve(thumbnail);
      }
    );
  });
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
          const medias = [...response];
          for (let i = 0; i < response.length; i++) {
            const item = response[i];
            if (
              item.type === 'image' &&
              options.haveThumbnail &&
              Platform.OS === 'ios'
            ) {
              const thumbnail = await getImageResize(item, options);
              medias[i] = { ...item, thumbnail };
            }
          }
          console.log(medias);
          resolve(medias);
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
