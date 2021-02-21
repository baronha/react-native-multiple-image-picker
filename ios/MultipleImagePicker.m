#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(MultipleImagePicker, NSObject)

RCT_EXTERN_METHOD(openPicker:(NSDictionary *)options
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

@end
