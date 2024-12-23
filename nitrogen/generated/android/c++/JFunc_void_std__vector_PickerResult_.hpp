///
/// JFunc_void_std__vector_PickerResult_.hpp
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2024 Marc Rousavy @ Margelo
///

#pragma once

#include <fbjni/fbjni.h>
#include <functional>

#include <functional>
#include <vector>
#include "PickerResult.hpp"
#include "JPickerResult.hpp"
#include <string>
#include <optional>
#include "ResultType.hpp"
#include "JResultType.hpp"

namespace margelo::nitro::multipleimagepicker {

  using namespace facebook;

  /**
   * C++ representation of the callback Func_void_std__vector_PickerResult_.
   * This is a Kotlin `(result: Array<PickerResult>) -> Unit`, backed by a `std::function<...>`.
   */
  struct JFunc_void_std__vector_PickerResult_ final: public jni::HybridClass<JFunc_void_std__vector_PickerResult_> {
  public:
    static jni::local_ref<JFunc_void_std__vector_PickerResult_::javaobject> fromCpp(const std::function<void(const std::vector<PickerResult>& /* result */)>& func) {
      return JFunc_void_std__vector_PickerResult_::newObjectCxxArgs(func);
    }

  public:
    void call(jni::alias_ref<jni::JArrayClass<JPickerResult>> result) {
      _func([&]() {
              size_t __size = result->size();
              std::vector<PickerResult> __vector;
              __vector.reserve(__size);
              for (size_t __i = 0; __i < __size; __i++) {
                auto __element = result->getElement(__i);
                __vector.push_back(__element->toCpp());
              }
              return __vector;
            }());
    }

  public:
    static auto constexpr kJavaDescriptor = "Lcom/margelo/nitro/multipleimagepicker/Func_void_std__vector_PickerResult_;";
    static void registerNatives() {
      registerHybrid({makeNativeMethod("call", JFunc_void_std__vector_PickerResult_::call)});
    }

  private:
    explicit JFunc_void_std__vector_PickerResult_(const std::function<void(const std::vector<PickerResult>& /* result */)>& func): _func(func) { }

  private:
    friend HybridBase;
    std::function<void(const std::vector<PickerResult>& /* result */)> _func;
  };

} // namespace margelo::nitro::multipleimagepicker