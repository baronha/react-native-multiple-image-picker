import { NativeModules, Platform } from 'react-native';
import { pickerOptionDefault } from './common';
import { MediaType, MediaTypeResult, Options } from './type';

export * from './type';

const LINKING_ERROR =
  `The package '@baronha/react-native-multiple-image-picker' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const MultipleImagePickerModule = isTurboModuleEnabled
  ? require('./NativeMultipleImagePicker').default
  : NativeModules.MultipleImagePicker;

const MultipleImagePicker = MultipleImagePickerModule
  ? MultipleImagePickerModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export const openPicker = <T extends MediaType = MediaType.ALL>(
  optionsPicker: Options<T>
): Promise<MediaTypeResult[T][]> => {
  const options = {
    ...pickerOptionDefault,
    ...optionsPicker,
  };
  const isSingle = options?.singleSelectedMode ?? false;
  if (isSingle) options.selectedAssets = [];

  return new Promise(async (resolve, reject) => {
    try {
      const response = await MultipleImagePicker.openPicker(options);
      if (response?.length) {
        if (isSingle) {
          resolve(response[0]);
        }
        resolve(response);
        return;
      }
      resolve([]);
    } catch (e) {
      reject(e);
    }
  });
};
