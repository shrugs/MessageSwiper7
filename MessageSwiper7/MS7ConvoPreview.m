#import "MS7ConvoPreview.h"

@implementation MS7ConvoPreview

@synthesize contactName = _contactName;
@synthesize mostRecentMessage = _mostRecentMessage;
@synthesize nameLabel = _nameLabel;
@synthesize messageLabel = _messageLabel;

- (void)setConversation:(CKConversation *)convo
{
    self.contactName = [convo name];
    //would set mostRecentMessage here
    self.mostRecentMessage = [[convo latestMessage] previewText]; //returns CKIMMessage => NSString

}

- (void)baseInit {
    [self setUserInteractionEnabled: NO];
    [self setBackgroundColor: [UIColor blueColor]];

    self.contactName = @"Unknown - Error";
    self.mostRecentMessage = @"Error Retrieving Message.";

    // now create the labels and add them to the blurred view
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 55)];
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10+50+10,100,80)];
    [self.nameLabel setBackgroundColor: [UIColor redColor]];
    [self.messageLabel setBackgroundColor: [UIColor redColor]];
    [self addSubview: self.nameLabel];
    [self addSubview: self.messageLabel];

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