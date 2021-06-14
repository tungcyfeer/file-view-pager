#import "FileViewPagerPlugin.h"
#if __has_include(<file_view_pager/file_view_pager-Swift.h>)
#import <file_view_pager/file_view_pager-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "file_view_pager-Swift.h"
#endif

@implementation FileViewPagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFileViewPagerPlugin registerWithRegistrar:registrar];
}
@end
