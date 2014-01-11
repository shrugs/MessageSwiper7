#import <iOS7/PrivateFrameworks/Preferences/PSListController.h>
#import <iOS7/PrivateFrameworks/Preferences/PSSpecifier.h>

static CFNotificationCenterRef darwinNotifyCenter = CFNotificationCenterGetDarwinNotifyCenter();
@interface MessageSwiper7SettingsListController: PSListController {
}
- (void)setPreferenceValue:(id)value specifier:(id)specifier;
@end

@implementation MessageSwiper7SettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"MessageSwiper7Settings" target:self] retain];
	}
	return _specifiers;
}

- (void)setPreferenceValue:(id)value specifier:(id)specifier {
    [super setPreferenceValue:value specifier:specifier];

    NSString *notification = [specifier propertyForKey:@"postNotification"];
    if(notification) {
        CFNotificationCenterPostNotification(darwinNotifyCenter, (CFStringRef)notification, NULL, NULL, true);
    }
}

@end

