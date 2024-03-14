import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-multiple-image-picker' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

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

export async function openPicker(options: object): Promise<object[]> {
  return MultipleImagePicker.openPicker(options);
}
