
// ChatKit imports
#import <iOS7/PrivateFrameworks/ChatKit/CKTranscriptController.h>
#import <iOS7/PrivateFrameworks/ChatKit/CKConversationList.h>
#import <iOS7/PrivateFrameworks/ChatKit/CKConversation.h>
#import <iOS7/PrivateFrameworks/ChatKit/CKGradientReferenceView.h>
#import <iOS7/PrivateFrameworks/ChatKit/CKTranscriptCollectionView.h>

// Messages Imports
#import "MobileSMS/CKMessagesController.h"

// UIKit imports
#import <iOS7/Frameworks/UIKit/UIGestureRecognizer.h>
#import <iOS7/Frameworks/UIKit/UIView.h>

// #import <substrate.h>

// PREFERENCES
#define PrefPath [[@"~" stringByExpandingTildeInPath] stringByAppendingPathComponent:@"Library/Preferences/com.mattcmultimedia.messageswiper7.plist"]

static BOOL globalEnable = YES;
static BOOL didRun = NO;
static BOOL wrapAroundEnabled = YES;
static CKMessagesController *ckMessagesController = nil;
static UIView *backPlacard = nil;
static NSMutableArray *convos = [[NSMutableArray alloc] init];
static int currentConvoIndex = 0;


/*


MS7ConvoPreview
*/
@interface MS7ConvoPreview : UIView

@property (assign) NSString *contactName;
@property (assign) NSString *mostRecentMessage;
@property (assign) UILabel *nameLabel;
@property (assign) UILabel *messageLabel;

- (void)setConversation:(CKConversation *)convo;

@end

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
    self.alpha = 0;

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

/*
END MS7ConvoPreview


*/
static MS7ConvoPreview *leftPreview;
static MS7ConvoPreview *rightPreview;

/*


MS7SwipeDelegate
*/
@interface MS7SwipeDelegate : NSObject <UIGestureRecognizerDelegate>

-(void)MS7_handlepan:(UIPanGestureRecognizer *)recognizer;
-(void)addPreviews;

@end

@implementation MS7SwipeDelegate


-(void)MS7_handlepan:(UIPanGestureRecognizer *)recognizer
{

    static BOOL leftTriggered;
    static BOOL rightTriggered;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // reset the previews just in case they're still animating
        [backPlacard.layer removeAllAnimations];
        [self resetPreviewsAnimated:NO];
        leftPreview.alpha = 1.0f;
        leftPreview.alpha = 1.0f;
        NSLog(@"BEGAN SHIT");
        leftTriggered = NO;
        rightTriggered = NO;
    }


    // now move both of the views
    int translation = [recognizer translationInView:recognizer.view].x;
    NSLog(@"%i", translation);

    // Move both previews
    // NOTE: make sure to update preview contents when the conversation changes, not on the handle pan
    int newX = (int) -60+translation;
    [leftPreview setCenter:CGPointMake(MIN(60, newX), leftPreview.center.y)];
    leftTriggered = leftPreview.center.x == 60;


    newX = (int) backPlacard.frame.size.width+60+translation;
    [rightPreview setCenter:CGPointMake(MAX(backPlacard.frame.size.width-60, newX), rightPreview.center.y)];
    rightTriggered = rightPreview.center.x == backPlacard.frame.size.width-60;


    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ENDED SHIT");
        int nextConvoIndex = 0;
        if (leftTriggered) {
            // swiped to left, so -1
            nextConvoIndex = currentConvoIndex - 1;
            if (currentConvoIndex == 0) {
                if (wrapAroundEnabled) {
                    nextConvoIndex = [convos count] - 1 ;
                } else {
                    nextConvoIndex = 0;
                    //maybe show bounce animation here
                }
            }
        }
        if (rightTriggered) {
            nextConvoIndex = currentConvoIndex + 1;
            if (nextConvoIndex >= [convos count]) {
                if (wrapAroundEnabled) {
                    nextConvoIndex = 0;
                } else {
                    nextConvoIndex = currentConvoIndex;
                    //maybe show bounce animation here
                }
            }
        }

        // now present the user with the next conversation, possibly with a nice sliding animation?
        [ckMessagesController showConversation:[convos objectAtIndex:nextConvoIndex] animate:YES];

        [self resetPreviewsAnimated:YES];
    }


}

-(id)init {
    self = [super init];
    if (self) {
        leftPreview = [[MS7ConvoPreview alloc] initWithFrame:CGRectMake(0,70,120,160)];
        rightPreview = [[MS7ConvoPreview alloc] initWithFrame:CGRectMake(320,70,120,160)];
    }
    return self;
}

-(void)addPreviews {
    [backPlacard addSubview: leftPreview];
    [backPlacard addSubview: rightPreview];
    [self resetPreviewsAnimated: NO];

}

-(void)resetPreviewsAnimated:(BOOL)shouldAnimate {
    if (!shouldAnimate) {
        [leftPreview setCenter:CGPointMake(-60,70+80)];
        [rightPreview setCenter:CGPointMake(backPlacard.frame.size.width+60,70+80)];
        leftPreview.alpha = 1.0;
        rightPreview.alpha = 1.0;
    } else {
        // animate to default positions.
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                            leftPreview.center = CGPointMake(-60, 70+80);
                            rightPreview.center = CGPointMake(backPlacard.frame.size.width+60, 70+80);
                            leftPreview.alpha = 0;
                            rightPreview.alpha = 0;
                         }
                         completion:nil];
    }
}

//delegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{

    BOOL detectCenter = NO;
    int edgePercent = 20; //%

    // Get the touch's location in the backPlacard view
    // if between the bounds we care about, return yes, else, no
    CGPoint coord = [touch locationInView: backPlacard];
    float w = backPlacard.frame.size.width;
    float edgeSize = (edgePercent/100.0)*w;

    if (detectCenter && (coord.x > edgeSize) && (coord.x < w-edgeSize)) {
        NSLog(@"ACCEPTED");
        return YES;
    }
    if (!detectCenter && ((coord.x < edgeSize) || (coord.x > w-edgeSize))) {
        NSLog(@"ACCEPTED");
        return YES;
    }
    NSLog(@"NOT ACCEPTED");
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
@end
/*
END MS7SwipeDelegate


*/

static MS7SwipeDelegate *swipeDelegate;







%group Messages

// There's only one CKTranscriptController instantiated.
// It controls which CkTranscriptCollectionView is shown.
// Those CKTranscriptCollectionView s have a subview of class CKTranscriptScrollView (orsomething like that)
%hook CKTranscriptController

- (void)viewDidAppear:(BOOL)arg1 {
    %orig;
    backPlacard = self.view.superview;



    if (backPlacard) {
        if (!didRun) {
            didRun = YES;
            swipeDelegate = [[MS7SwipeDelegate alloc] init];

            backPlacard.layer.borderColor = [[UIColor redColor] CGColor];
            backPlacard.layer.borderWidth = 3.0f;


            backPlacard.userInteractionEnabled = YES;
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:swipeDelegate action:@selector(MS7_handlepan:)];
            panRecognizer.maximumNumberOfTouches = 1;
            [panRecognizer setDelegate:swipeDelegate];
            // [panRecognizer _setHysteresis: 50.0];
            [backPlacard addGestureRecognizer: panRecognizer];
            // [panRecognizer release]; //CAUSES SAFE MODE WTF
            // now add the previews to the backPlacard
            [swipeDelegate addPreviews];

        }
        [swipeDelegate addPreviews];
    }
}



%end










%hook CKMessagesController
- (void)_conversationLeft:(id)fp8 {

    // left a conversation? update the list
    %orig;
    convos = [[%c(CKConversationList) sharedConversationList] conversations];
}


// PROBLEM

- (BOOL)resumeToConversation:(id)fp8 {

    currentConvoIndex = [convos indexOfObject: fp8];

    return %orig;
}



- (void)showConversation:(id)fp8 animate:(BOOL)fp12 {
    %log;
    %orig;
    convos = [[%c(CKConversationList) sharedConversationList] conversations];

    currentConvoIndex = [convos indexOfObject: fp8];
}
- (void)showConversation:(id)fp8 animate:(BOOL)fp12 forceToTranscript:(BOOL)fp16 {
    %log;
    %orig;
    convos = [[%c(CKConversationList) sharedConversationList] conversations];
    currentConvoIndex = [convos indexOfObject: fp8];
}

// END PROBLEM

- (void)setCurrentConversation:(id)convo {
    %log;
    %orig;
}

%end

// %hook CKConversation

// - (void)sendMessage:(id)arg1 newComposition:(BOOL)arg2
// {
//     convos = [[%c(CKConversationList) sharedConversationList] conversations];
//     currentConvoIndex = [convos indexOfObject:self];
//     %orig;
// }
// - (void)sendMessage:(id)arg1 onService:(id)arg2 newComposition:(BOOL)arg3
// {
//     convos = [[%c(CKConversationList) sharedConversationList] conversations];
//     currentConvoIndex = [convos indexOfObject:self];
//     %orig;

// }

// %end

%end

static void MS7UpdatePreferences() {
    NSDictionary *preferences = [[NSDictionary alloc] initWithContentsOfFile:PrefPath];
    globalEnable = YES;
    if (preferences) {
        //if the option exists make it that, else default
        if ([preferences valueForKey:@"globalEnable"] != nil) {
            globalEnable = [[preferences valueForKey:@"globalEnable"] boolValue];
        } else {
            globalEnable = YES;
        }
        if ([preferences valueForKey:@"wrapAroundEnabled"] != nil) {
            wrapAroundEnabled = [[preferences valueForKey:@"wrapAroundEnabled"] boolValue];
        } else {
            wrapAroundEnabled = NO;
        }
    }
    [preferences release];
}

static void reloadPrefsNotification(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo) {
    MS7UpdatePreferences();
}

%ctor {

   //init prefs again
    MS7UpdatePreferences();
    CFNotificationCenterRef reload = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(reload, NULL, &reloadPrefsNotification,
                    CFSTR("com.mattcmultimedia.stacks/reload"), NULL, 0);

    if (globalEnable) {
        %init(Messages);
        // %init(WhatsAppStuff);
    }
}