#import "MS7SwipeDelegate.h"

@implementation MS7SwipeDelegate

@synthesize backPlacard = _backPlacard;
@synthesize leftPreview = _leftPreview;
@synthesize rightPreview = _rightPreview;
@synthesize convos = _convos;
@synthesize currentConvoIndex = _currentConvoIndex;
@synthesize wrapAroundEnabled = _wrapAroundEnabled;
@synthesize ckMessagesController= _ckMessagesController;


-(void)MS7_handlepan:(UIPanGestureRecognizer *)recognizer
{

    static BOOL leftTriggered;
    static BOOL rightTriggered;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // reset the previews just in case they're still animating
        [self.backPlacard.layer removeAllAnimations];
        [self resetPreviewsAnimated:NO];
        self.leftPreview.alpha = 1.0f;
        self.leftPreview.alpha = 1.0f;
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
    [self.leftPreview setCenter:CGPointMake(MIN(60, newX), self.leftPreview.center.y)];
    leftTriggered = self.leftPreview.center.x == 60;


    newX = (int) self.backPlacard.frame.size.width+60+translation;
    [self.rightPreview setCenter:CGPointMake(MAX(self.backPlacard.frame.size.width-60, newX), self.rightPreview.center.y)];
    rightTriggered = self.rightPreview.center.x == self.backPlacard.frame.size.width-60;


    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ENDED SHIT");
        int nextConvoIndex = 0;
        if (leftTriggered) {
            // swiped to left, so -1
            nextConvoIndex = self.currentConvoIndex - 1;
            if (self.currentConvoIndex == 0) {
                if (self.wrapAroundEnabled) {
                    nextConvoIndex = [self.convos count] - 1 ;
                } else {
                    nextConvoIndex = 0;
                    //maybe show bounce animation here
                }
            }
        }
        if (rightTriggered) {
            nextConvoIndex = self.currentConvoIndex + 1;
            if (nextConvoIndex >= [self.convos count]) {
                if (self.wrapAroundEnabled) {
                    nextConvoIndex = 0;
                } else {
                    nextConvoIndex = self.currentConvoIndex;
                    //maybe show bounce animation here
                }
            }
        }

        // now present the user with the next conversation, possibly with a nice sliding animation?
        [self.ckMessagesController showConversation:[self.convos objectAtIndex:nextConvoIndex] animate:YES];

        [self resetPreviewsAnimated:YES];
    }


}

-(id)init {
    self = [super init];
    if (self) {
        self.leftPreview = [[MS7ConvoPreview alloc] initWithFrame:CGRectMake(0,70,120,160)];
        self.rightPreview = [[MS7ConvoPreview alloc] initWithFrame:CGRectMake(320,70,120,160)];
        self.wrapAroundEnabled = YES;
        // self.convos = [[NSMutableArray alloc] init];
        NSLog(@"PAY ATTENTION TO ME PLS");
        NSLog(@"%@", self.convos);
    }
    return self;
}

-(void)addPreviews {
    [self.backPlacard addSubview: self.leftPreview];
    [self.backPlacard addSubview: self.rightPreview];
    [self resetPreviewsAnimated: NO];

}

-(void)resetPreviewsAnimated:(BOOL)shouldAnimate {
    if (!shouldAnimate) {
        [self.leftPreview setCenter:CGPointMake(-60,70+80)];
        [self.rightPreview setCenter:CGPointMake(self.backPlacard.frame.size.width+60,70+80)];
        self.leftPreview.alpha = 1.0;
        self.rightPreview.alpha = 1.0;
    } else {
        // animate to default positions.
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                            self.leftPreview.center = CGPointMake(-60, 70+80);
                            self.rightPreview.center = CGPointMake(self.backPlacard.frame.size.width+60, 70+80);
                            self.leftPreview.alpha = 0;
                            self.rightPreview.alpha = 0;
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
    CGPoint coord = [touch locationInView: self.backPlacard];
    float w = self.backPlacard.frame.size.width;
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