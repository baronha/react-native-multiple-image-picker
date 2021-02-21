import { NativeModules } from 'react-native';

type MultipleImagePickerType = {
  multiply(a: number, b: number): Promise<number>;
};

const { MultipleImagePicker } = NativeModules;

export default MultipleImagePicker as MultipleImagePickerType;
