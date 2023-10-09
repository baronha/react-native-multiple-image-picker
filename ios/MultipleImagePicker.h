//
//  MultipleImagePicker.h
//  Pods
//
//  Created by BAO HA on 09/10/2023.
//

#ifdef RCT_NEW_ARCH_ENABLED

#import "RNMultipleImagePickerSpec.h"

@interface MultipleImagePicker : NSObject <NativeMultipleImagePickerSpec>
#else

#import <React/RCTBridgeModule.h>

@interface MultipleImagePicker : NSObject <RCTBridgeModule>
#endif

@end
