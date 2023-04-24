#import "MultiPayPlugin.h"
#if __has_include(<multipay/multipay-Swift.h>)
#import <multipay/multipay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "multipay-Swift.h"
#endif

@implementation MultiPayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMultiPayPlugin registerWithRegistrar:registrar];
}
@end