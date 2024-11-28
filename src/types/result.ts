type ResultType = 'image' | 'video'
export interface Crop {
  width: number
  height: number
  offsetX: number
  offsetY: number
  aspectRatio: number
}

export interface Result {
  path: string
  fileName: string
  localIdentifier: string
  width: number
  height: number
  mime: string
  size: number
  bucketId?: number
  realPath?: string
  originalPath: string // without crop
  parentFolderName?: string
  creationDate?: number
  type?: ResultType
  duration?: number
  thumbnail?: string
  crop?: Crop
}
