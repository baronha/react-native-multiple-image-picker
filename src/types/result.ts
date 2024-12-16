export type ResultType = 'image' | 'video'

export interface BaseResult {
  path: string

  type: ResultType

  width?: number

  height?: number

  duration?: number

  thumbnail?: string

  fileName?: string
}

export interface Result extends BaseResult {
  localIdentifier: string
  width: number
  height: number
  mime: string
  size: number
  bucketId?: number
  realPath?: string
  parentFolderName?: string
  creationDate?: number
  crop?: boolean
}
