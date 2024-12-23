/**
 * Represents the type of media content
 * @example
 * const type: ResultType = 'image'
 * const type: ResultType = 'video'
 */
export type ResultType = 'image' | 'video'

/**
 * Base interface containing common properties for media results.
 * Used as a foundation for more specific result types.
 *
 * @example
 * const baseResult: BaseResult = {
 *   path: '/path/to/media/file.jpg',
 *   type: 'image',
 *   width: 1920,
 *   height: 1080,
 *   fileName: 'file.jpg'
 * }
 */
export interface BaseResult {
  /**
   * File path of the media asset
   * Can be relative or absolute depending on context
   */
  path: string

  /**
   * Type of media content
   * Used to determine how the asset should be handled
   */
  type: ResultType

  /**
   * Width of the media in pixels
   * Optional in base result as it may not be immediately available
   */
  width?: number

  /**
   * Height of the media in pixels
   * Optional in base result as it may not be immediately available
   */
  height?: number

  /**
   * Duration of the media in seconds
   * Only applicable for video content
   * @example 120.5 // 2 minutes and 30 seconds
   */
  duration?: number

  /**
   * Path to a thumbnail image representation
   * Useful for previews and grid displays
   * Can be a local path or URL depending on implementation
   */
  thumbnail?: string

  /**
   * Original filename of the media asset
   * Includes the file extension
   * @example "IMG_20240301_123456.jpg"
   */
  fileName?: string
}

/**
 * Extended result interface with complete metadata and file information.
 * Used for fully processed media assets where all properties are known.
 *
 * @extends BaseResult
 *
 * @example
 * const result: Result = {
 *   path: '/path/to/media/file.jpg',
 *   type: 'image',
 *   width: 1920,
 *   height: 1080,
 *   fileName: 'file.jpg',
 *   localIdentifier: 'unique-id-123',
 *   mime: 'image/jpeg',
 *   size: 1024000,
 *   creationDate: 1709312436000
 * }
 */
export interface PickerResult extends BaseResult {
  /**
   * Unique identifier for the media asset
   * Used for local database tracking and reference
   * Format may vary depending on platform/implementation
   */
  localIdentifier: string

  /**
   * Width of the media in pixels
   * Required in Result interface as it should be known after processing
   */
  width: number

  /**
   * Height of the media in pixels
   * Required in Result interface as it should be known after processing
   */
  height: number

  /**
   * MIME type of the media file
   * @example "image/jpeg", "video/mp4"
   */
  mime: string

  /**
   * File size in bytes
   * @example 1024000 // 1MB
   */
  size: number

  /**
   * Optional identifier for storage bucket
   * Used when assets are stored in cloud storage systems
   * @platform android
   */
  bucketId?: number

  /**
   * Actual file path on the system
   * May differ from the `path` property in cases where
   * the file is stored in a different location than referenced
   * @platform android
   */
  realPath?: string

  /**
   * Name of the containing folder
   * Useful for organization and grouping
   * @platform android
   */
  parentFolderName?: string

  /**
   * Unix timestamp in milliseconds of when the media was created
   * @example 1709312436000 // March 1, 2024 12:34:56 PM
   */
  creationDate?: number

  /**
   * Indicates if the media has been cropped from its original dimensions
   * Used to track image modifications
   */
  crop?: boolean
}
