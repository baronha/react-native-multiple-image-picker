///
/// CameraResult.swift
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2024 Marc Rousavy @ Margelo
///

import NitroModules

/**
 * Represents an instance of `CameraResult`, backed by a C++ struct.
 */
public typealias CameraResult = margelo.nitro.multipleimagepicker.CameraResult

public extension CameraResult {
  private typealias bridge = margelo.nitro.multipleimagepicker.bridge.swift

  /**
   * Create a new instance of `CameraResult`.
   */
  init(path: String, type: ResultType, width: Double?, height: Double?, duration: Double?, thumbnail: String?, fileName: String?) {
    self.init(std.string(path), type, { () -> bridge.std__optional_double_ in
      if let __unwrappedValue = width {
        return bridge.create_std__optional_double_(__unwrappedValue)
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_double_ in
      if let __unwrappedValue = height {
        return bridge.create_std__optional_double_(__unwrappedValue)
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_double_ in
      if let __unwrappedValue = duration {
        return bridge.create_std__optional_double_(__unwrappedValue)
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = thumbnail {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = fileName {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }())
  }

  var path: String {
    @inline(__always)
    get {
      return String(self.__path)
    }
    @inline(__always)
    set {
      self.__path = std.string(newValue)
    }
  }
  
  var type: ResultType {
    @inline(__always)
    get {
      return self.__type
    }
    @inline(__always)
    set {
      self.__type = newValue
    }
  }
  
  var width: Double? {
    @inline(__always)
    get {
      return self.__width.value
    }
    @inline(__always)
    set {
      self.__width = { () -> bridge.std__optional_double_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_double_(__unwrappedValue)
        } else {
          return .init()
        }
      }()
    }
  }
  
  var height: Double? {
    @inline(__always)
    get {
      return self.__height.value
    }
    @inline(__always)
    set {
      self.__height = { () -> bridge.std__optional_double_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_double_(__unwrappedValue)
        } else {
          return .init()
        }
      }()
    }
  }
  
  var duration: Double? {
    @inline(__always)
    get {
      return self.__duration.value
    }
    @inline(__always)
    set {
      self.__duration = { () -> bridge.std__optional_double_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_double_(__unwrappedValue)
        } else {
          return .init()
        }
      }()
    }
  }
  
  var thumbnail: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__thumbnail.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__thumbnail = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var fileName: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__fileName.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__fileName = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
}