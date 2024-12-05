type ResultType = 'image' | 'video'

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
  parentFolderName?: string
  creationDate?: number
  type: ResultType
  duration?: number
  thumbnail?: string
  crop?: boolean
}
