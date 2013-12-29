// #import "../ILTranslucentView/ILTranslucentView.h"
#import <iOS7/PrivateFrameworks/ChatKit/CKConversation.h>
@interface MS7ConvoPreview : UIView

@property (assign) NSString *contactName;
@property (assign) NSString *mostRecentMessage;
@property (assign) UILabel *nameLabel;
@property (assign) UILabel *messageLabel;

- (void)setConversation:(CKConversation *)convo;

@end