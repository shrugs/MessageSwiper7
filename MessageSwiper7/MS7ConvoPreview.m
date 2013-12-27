#import "MS7ConvoPreview.h"

@implementation MS7ConvoPreview

@synthesize contactName = _contactName;
@synthesize mostRecentMessage = _mostRecentMessage;
@synthesize nameLabel = _nameLabel;
@synthesize messageLabel = _messageLabel;

- (void) setConversation:(CKConversation *)convo
{
    self.contactName = [convo name];
    //would set mostRecentMessage here
    self.mostRecentMessage = [[convo latestMessage] previewText]; //returns CKIMMessage => NSString

}

- (void)baseInit {
    _contactName = NULL;
    _contactName = @"Unknown - Error";
    _mostRecentMessage = @"Error Retrieving Message.";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

@end