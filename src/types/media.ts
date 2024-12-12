import { ResultType } from './result'

export interface MediaPreview {
  type: ResultType
  path?: string
  thumbnail?: string
  localIdentifier?: string
}
