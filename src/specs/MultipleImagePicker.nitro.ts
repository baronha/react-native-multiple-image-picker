import { type HybridObject } from 'react-native-nitro-modules'
import { NitroConfig, Result } from '../types'

export interface MultipleImagePicker
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  openPicker(
    config: NitroConfig,
    resolved: (result: Result[]) => void,
    rejected: (reject: number) => void
  ): void
}
