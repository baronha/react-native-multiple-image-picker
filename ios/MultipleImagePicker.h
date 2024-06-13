#ifdef RCT_NEW_ARCH_ENABLED
#import "RNMultipleImagePickerSpec.h"

@interface MultipleImagePicker : NSObject <NativeMultipleImagePickerSpec>
#else
#import <React/RCTBridgeModule.h>

@interface MultipleImagePicker : NSObject <RCTBridgeModule>
#endif

@end
