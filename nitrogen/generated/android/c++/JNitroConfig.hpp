///
/// JNitroConfig.hpp
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2024 Marc Rousavy @ Margelo
///

#pragma once

#include <fbjni/fbjni.h>
#include "NitroConfig.hpp"

#include "CropRatio.hpp"
#include "JCropRatio.hpp"
#include "JLanguage.hpp"
#include "JMediaType.hpp"
#include "JPickerCropConfig.hpp"
#include "JPresentation.hpp"
#include "JResult.hpp"
#include "JResultType.hpp"
#include "JSelectBoxStyle.hpp"
#include "JSelectMode.hpp"
#include "JText.hpp"
#include "JTheme.hpp"
#include "Language.hpp"
#include "MediaType.hpp"
#include "PickerCropConfig.hpp"
#include "Presentation.hpp"
#include "Result.hpp"
#include "ResultType.hpp"
#include "SelectBoxStyle.hpp"
#include "SelectMode.hpp"
#include "Text.hpp"
#include "Theme.hpp"
#include <optional>
#include <string>
#include <vector>

namespace margelo::nitro::multipleimagepicker {

  using namespace facebook;

  /**
   * The C++ JNI bridge between the C++ struct "NitroConfig" and the the Kotlin data class "NitroConfig".
   */
  struct JNitroConfig final: public jni::JavaClass<JNitroConfig> {
  public:
    static auto constexpr kJavaDescriptor = "Lcom/margelo/nitro/multipleimagepicker/NitroConfig;";

  public:
    /**
     * Convert this Java/Kotlin-based struct to the C++ struct NitroConfig by copying all values to C++.
     */
    [[maybe_unused]]
    NitroConfig toCpp() const {
      static const auto clazz = javaClassStatic();
      static const auto fieldMediaType = clazz->getField<JMediaType>("mediaType");
      jni::local_ref<JMediaType> mediaType = this->getFieldValue(fieldMediaType);
      static const auto fieldSelectedAssets = clazz->getField<jni::JArrayClass<JResult>>("selectedAssets");
      jni::local_ref<jni::JArrayClass<JResult>> selectedAssets = this->getFieldValue(fieldSelectedAssets);
      static const auto fieldSelectBoxStyle = clazz->getField<JSelectBoxStyle>("selectBoxStyle");
      jni::local_ref<JSelectBoxStyle> selectBoxStyle = this->getFieldValue(fieldSelectBoxStyle);
      static const auto fieldSelectMode = clazz->getField<JSelectMode>("selectMode");
      jni::local_ref<JSelectMode> selectMode = this->getFieldValue(fieldSelectMode);
      static const auto fieldNumberOfColumn = clazz->getField<jni::JDouble>("numberOfColumn");
      jni::local_ref<jni::JDouble> numberOfColumn = this->getFieldValue(fieldNumberOfColumn);
      static const auto fieldIsPreview = clazz->getField<jni::JBoolean>("isPreview");
      jni::local_ref<jni::JBoolean> isPreview = this->getFieldValue(fieldIsPreview);
      static const auto fieldPrimaryColor = clazz->getField<jni::JDouble>("primaryColor");
      jni::local_ref<jni::JDouble> primaryColor = this->getFieldValue(fieldPrimaryColor);
      static const auto fieldAllowedCamera = clazz->getField<jni::JBoolean>("allowedCamera");
      jni::local_ref<jni::JBoolean> allowedCamera = this->getFieldValue(fieldAllowedCamera);
      static const auto fieldAllowSwipeToSelect = clazz->getField<jni::JBoolean>("allowSwipeToSelect");
      jni::local_ref<jni::JBoolean> allowSwipeToSelect = this->getFieldValue(fieldAllowSwipeToSelect);
      static const auto fieldSpacing = clazz->getField<jni::JDouble>("spacing");
      jni::local_ref<jni::JDouble> spacing = this->getFieldValue(fieldSpacing);
      static const auto fieldIsHiddenPreviewButton = clazz->getField<jni::JBoolean>("isHiddenPreviewButton");
      jni::local_ref<jni::JBoolean> isHiddenPreviewButton = this->getFieldValue(fieldIsHiddenPreviewButton);
      static const auto fieldIsHiddenOriginalButton = clazz->getField<jni::JBoolean>("isHiddenOriginalButton");
      jni::local_ref<jni::JBoolean> isHiddenOriginalButton = this->getFieldValue(fieldIsHiddenOriginalButton);
      static const auto fieldIsShowPreviewList = clazz->getField<jni::JBoolean>("isShowPreviewList");
      jni::local_ref<jni::JBoolean> isShowPreviewList = this->getFieldValue(fieldIsShowPreviewList);
      static const auto fieldAllowHapticTouchPreview = clazz->getField<jni::JBoolean>("allowHapticTouchPreview");
      jni::local_ref<jni::JBoolean> allowHapticTouchPreview = this->getFieldValue(fieldAllowHapticTouchPreview);
      static const auto fieldAllowedLimit = clazz->getField<jni::JBoolean>("allowedLimit");
      jni::local_ref<jni::JBoolean> allowedLimit = this->getFieldValue(fieldAllowedLimit);
      static const auto fieldMaxVideo = clazz->getField<jni::JDouble>("maxVideo");
      jni::local_ref<jni::JDouble> maxVideo = this->getFieldValue(fieldMaxVideo);
      static const auto fieldMaxSelect = clazz->getField<jni::JDouble>("maxSelect");
      jni::local_ref<jni::JDouble> maxSelect = this->getFieldValue(fieldMaxSelect);
      static const auto fieldMaxVideoDuration = clazz->getField<jni::JDouble>("maxVideoDuration");
      jni::local_ref<jni::JDouble> maxVideoDuration = this->getFieldValue(fieldMaxVideoDuration);
      static const auto fieldMinVideoDuration = clazz->getField<jni::JDouble>("minVideoDuration");
      jni::local_ref<jni::JDouble> minVideoDuration = this->getFieldValue(fieldMinVideoDuration);
      static const auto fieldMaxFileSize = clazz->getField<jni::JDouble>("maxFileSize");
      jni::local_ref<jni::JDouble> maxFileSize = this->getFieldValue(fieldMaxFileSize);
      static const auto fieldVideoQuality = clazz->getField<jni::JDouble>("videoQuality");
      jni::local_ref<jni::JDouble> videoQuality = this->getFieldValue(fieldVideoQuality);
      static const auto fieldImageQuality = clazz->getField<jni::JDouble>("imageQuality");
      jni::local_ref<jni::JDouble> imageQuality = this->getFieldValue(fieldImageQuality);
      static const auto fieldBackgroundDark = clazz->getField<jni::JDouble>("backgroundDark");
      jni::local_ref<jni::JDouble> backgroundDark = this->getFieldValue(fieldBackgroundDark);
      static const auto fieldCrop = clazz->getField<JPickerCropConfig>("crop");
      jni::local_ref<JPickerCropConfig> crop = this->getFieldValue(fieldCrop);
      static const auto fieldText = clazz->getField<JText>("text");
      jni::local_ref<JText> text = this->getFieldValue(fieldText);
      static const auto fieldLanguage = clazz->getField<JLanguage>("language");
      jni::local_ref<JLanguage> language = this->getFieldValue(fieldLanguage);
      static const auto fieldTheme = clazz->getField<JTheme>("theme");
      jni::local_ref<JTheme> theme = this->getFieldValue(fieldTheme);
      static const auto fieldPresentation = clazz->getField<JPresentation>("presentation");
      jni::local_ref<JPresentation> presentation = this->getFieldValue(fieldPresentation);
      return NitroConfig(
        mediaType->toCpp(),
        [&]() {
          size_t __size = selectedAssets->size();
          std::vector<Result> __vector;
          __vector.reserve(__size);
          for (size_t __i = 0; __i < __size; __i++) {
            auto __element = selectedAssets->getElement(__i);
            __vector.push_back(__element->toCpp());
          }
          return __vector;
        }(),
        selectBoxStyle->toCpp(),
        selectMode->toCpp(),
        numberOfColumn != nullptr ? std::make_optional(numberOfColumn->value()) : std::nullopt,
        isPreview != nullptr ? std::make_optional(static_cast<bool>(isPreview->value())) : std::nullopt,
        primaryColor != nullptr ? std::make_optional(primaryColor->value()) : std::nullopt,
        allowedCamera != nullptr ? std::make_optional(static_cast<bool>(allowedCamera->value())) : std::nullopt,
        allowSwipeToSelect != nullptr ? std::make_optional(static_cast<bool>(allowSwipeToSelect->value())) : std::nullopt,
        spacing != nullptr ? std::make_optional(spacing->value()) : std::nullopt,
        isHiddenPreviewButton != nullptr ? std::make_optional(static_cast<bool>(isHiddenPreviewButton->value())) : std::nullopt,
        isHiddenOriginalButton != nullptr ? std::make_optional(static_cast<bool>(isHiddenOriginalButton->value())) : std::nullopt,
        isShowPreviewList != nullptr ? std::make_optional(static_cast<bool>(isShowPreviewList->value())) : std::nullopt,
        allowHapticTouchPreview != nullptr ? std::make_optional(static_cast<bool>(allowHapticTouchPreview->value())) : std::nullopt,
        allowedLimit != nullptr ? std::make_optional(static_cast<bool>(allowedLimit->value())) : std::nullopt,
        maxVideo != nullptr ? std::make_optional(maxVideo->value()) : std::nullopt,
        maxSelect != nullptr ? std::make_optional(maxSelect->value()) : std::nullopt,
        maxVideoDuration != nullptr ? std::make_optional(maxVideoDuration->value()) : std::nullopt,
        minVideoDuration != nullptr ? std::make_optional(minVideoDuration->value()) : std::nullopt,
        maxFileSize != nullptr ? std::make_optional(maxFileSize->value()) : std::nullopt,
        videoQuality != nullptr ? std::make_optional(videoQuality->value()) : std::nullopt,
        imageQuality != nullptr ? std::make_optional(imageQuality->value()) : std::nullopt,
        backgroundDark != nullptr ? std::make_optional(backgroundDark->value()) : std::nullopt,
        crop != nullptr ? std::make_optional(crop->toCpp()) : std::nullopt,
        text != nullptr ? std::make_optional(text->toCpp()) : std::nullopt,
        language->toCpp(),
        theme->toCpp(),
        presentation->toCpp()
      );
    }

  public:
    /**
     * Create a Java/Kotlin-based struct by copying all values from the given C++ struct to Java.
     */
    [[maybe_unused]]
    static jni::local_ref<JNitroConfig::javaobject> fromCpp(const NitroConfig& value) {
      return newInstance(
        JMediaType::fromCpp(value.mediaType),
        [&]() {
          size_t __size = value.selectedAssets.size();
          jni::local_ref<jni::JArrayClass<JResult>> __array = jni::JArrayClass<JResult>::newArray(__size);
          for (size_t __i = 0; __i < __size; __i++) {
            const auto& __element = value.selectedAssets[__i];
            __array->setElement(__i, *JResult::fromCpp(__element));
          }
          return __array;
        }(),
        JSelectBoxStyle::fromCpp(value.selectBoxStyle),
        JSelectMode::fromCpp(value.selectMode),
        value.numberOfColumn.has_value() ? jni::JDouble::valueOf(value.numberOfColumn.value()) : nullptr,
        value.isPreview.has_value() ? jni::JBoolean::valueOf(value.isPreview.value()) : nullptr,
        value.primaryColor.has_value() ? jni::JDouble::valueOf(value.primaryColor.value()) : nullptr,
        value.allowedCamera.has_value() ? jni::JBoolean::valueOf(value.allowedCamera.value()) : nullptr,
        value.allowSwipeToSelect.has_value() ? jni::JBoolean::valueOf(value.allowSwipeToSelect.value()) : nullptr,
        value.spacing.has_value() ? jni::JDouble::valueOf(value.spacing.value()) : nullptr,
        value.isHiddenPreviewButton.has_value() ? jni::JBoolean::valueOf(value.isHiddenPreviewButton.value()) : nullptr,
        value.isHiddenOriginalButton.has_value() ? jni::JBoolean::valueOf(value.isHiddenOriginalButton.value()) : nullptr,
        value.isShowPreviewList.has_value() ? jni::JBoolean::valueOf(value.isShowPreviewList.value()) : nullptr,
        value.allowHapticTouchPreview.has_value() ? jni::JBoolean::valueOf(value.allowHapticTouchPreview.value()) : nullptr,
        value.allowedLimit.has_value() ? jni::JBoolean::valueOf(value.allowedLimit.value()) : nullptr,
        value.maxVideo.has_value() ? jni::JDouble::valueOf(value.maxVideo.value()) : nullptr,
        value.maxSelect.has_value() ? jni::JDouble::valueOf(value.maxSelect.value()) : nullptr,
        value.maxVideoDuration.has_value() ? jni::JDouble::valueOf(value.maxVideoDuration.value()) : nullptr,
        value.minVideoDuration.has_value() ? jni::JDouble::valueOf(value.minVideoDuration.value()) : nullptr,
        value.maxFileSize.has_value() ? jni::JDouble::valueOf(value.maxFileSize.value()) : nullptr,
        value.videoQuality.has_value() ? jni::JDouble::valueOf(value.videoQuality.value()) : nullptr,
        value.imageQuality.has_value() ? jni::JDouble::valueOf(value.imageQuality.value()) : nullptr,
        value.backgroundDark.has_value() ? jni::JDouble::valueOf(value.backgroundDark.value()) : nullptr,
        value.crop.has_value() ? JPickerCropConfig::fromCpp(value.crop.value()) : nullptr,
        value.text.has_value() ? JText::fromCpp(value.text.value()) : nullptr,
        JLanguage::fromCpp(value.language),
        JTheme::fromCpp(value.theme),
        JPresentation::fromCpp(value.presentation)
      );
    }
  };

} // namespace margelo::nitro::multipleimagepicker
