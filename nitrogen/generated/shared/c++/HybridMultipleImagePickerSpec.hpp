///
/// HybridMultipleImagePickerSpec.hpp
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2024 Marc Rousavy @ Margelo
///

#pragma once

#if __has_include(<NitroModules/HybridObject.hpp>)
#include <NitroModules/HybridObject.hpp>
#else
#error NitroModules cannot be found! Are you sure you installed NitroModules properly?
#endif

// Forward declaration of `NitroConfig` to properly resolve imports.
namespace margelo::nitro::multipleimagepicker { struct NitroConfig; }
// Forward declaration of `Result` to properly resolve imports.
namespace margelo::nitro::multipleimagepicker { struct Result; }

#include "NitroConfig.hpp"
#include <functional>
#include <vector>
#include "Result.hpp"

namespace margelo::nitro::multipleimagepicker {

  using namespace margelo::nitro;

  /**
   * An abstract base class for `MultipleImagePicker`
   * Inherit this class to create instances of `HybridMultipleImagePickerSpec` in C++.
   * You must explicitly call `HybridObject`'s constructor yourself, because it is virtual.
   * @example
   * ```cpp
   * class HybridMultipleImagePicker: public HybridMultipleImagePickerSpec {
   * public:
   *   HybridMultipleImagePicker(...): HybridObject(TAG) { ... }
   *   // ...
   * };
   * ```
   */
  class HybridMultipleImagePickerSpec: public virtual HybridObject {
    public:
      // Constructor
      explicit HybridMultipleImagePickerSpec(): HybridObject(TAG) { }

      // Destructor
      virtual ~HybridMultipleImagePickerSpec() { }

    public:
      // Properties
      

    public:
      // Methods
      virtual void openPicker(const NitroConfig& config, const std::function<void(const std::vector<Result>& /* result */)>& resolved, const std::function<void(double /* reject */)>& rejected) = 0;

    protected:
      // Hybrid Setup
      void loadHybridMethods() override;

    protected:
      // Tag for logging
      static constexpr auto TAG = "MultipleImagePicker";
  };

} // namespace margelo::nitro::multipleimagepicker
