#import <iOS7/PrivateFrameworks/Preferences/PSListController.h>
#import <iOS7/PrivateFrameworks/Preferences/PSSpecifier.h>

static CFNotificationCenterRef darwinNotifyCenter = CFNotificationCenterGetDarwinNotifyCenter();

@interface MessageSwiper7SettingsListController: PSListController {
}

- (void)twitter:(id)arg;
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

- (void)twitter:(id)arg {
    NSArray *urls = [[NSArray alloc] initWithObjects: @"twitter://user?id=606342610", @"tweetbot://Matt/follow/MattCMultimedia", @"https://twitter.com/MattCMultimedia", nil];
    for (int i = 0; i < [urls count]; ++i)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[urls objectAtIndex:i]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urls objectAtIndex:i]]];
            break;
        }
    }

}

@end
