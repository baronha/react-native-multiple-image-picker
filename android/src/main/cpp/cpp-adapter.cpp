#include <jni.h>
#include "MultipleImagePickerOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {
  return margelo::nitro::multipleimagepicker::initialize(vm);
}
