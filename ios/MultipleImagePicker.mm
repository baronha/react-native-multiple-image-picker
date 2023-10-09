#import <React/RCTBridgeModule.h>
#import "MultipleImagePicker.h"

#import <react_native_multiple_image_picker-Swift.h>


@implementation MultipleImagePicker

RCT_EXPORT_MODULE()

RCT_EXTERN_METHOD(openPicker:(NSDictionary *)options
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)


@end
