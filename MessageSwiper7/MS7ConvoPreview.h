#import <CKBlurView/CKBlurView.h>

@interface MS7ConvoPreview : CKBlurView

@property (assign) NSString *contactName;
@property (assign) NSString *mostRecentMessage;
@property (assign) UILabel *nameLabel;
@property (assign) UILabel *messageLabel;

- (void) setConversation:(CKConversation *)convo;

@end
