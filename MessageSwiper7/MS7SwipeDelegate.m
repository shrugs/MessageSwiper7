#import "MS7SwipeDelegate.h"

@implementation MS7SwipeDelegate

@synthesize backPlacard = _backPlacard;
@synthesize leftPreview = _leftPreview;
@synthesize rightPreview = _rightPreview;
@synthesize isInConvo = _isInConvo;


-(void)MS7_handlepan:(UIPanGestureRecognizer *)recognizer
{
    // CGPoint originalLocation;
    // if (recognizer.state == UIGestureRecognizerStateBegan) {
    //     //if new touch
    //     originalLocation = [recognizer locationInView:recognizer.view];
    //     NSLog(@"%@", NSStringFromCGPoint(originalLocation));
    // }

    // now move both of the views max(translation, 120)
    int translation = [recognizer translationInView:recognizer.view].x;

    // Move both previews
    // NOTE: make sure to update preview contents when the conversation changes, not on the handle pan
    int newX = self.leftPreview.center.x+translation;
    [self.leftPreview setCenter:CGPointMake(MIN(60, newX), self.leftPreview.center.y)];
    newX = self.rightPreview.center.x+translation;
    [self.rightPreview setCenter:CGPointMake(MAX(self.backPlacard.frame.size.width-60, newX), self.rightPreview.center.y)];


    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self resetPreviews];
    }


}

-(id)init {
    self = [super init];
    if (self) {
        self.isInConvo = NO;
        self.leftPreview = [[MS7ConvoPreview alloc] initWithFrame:CGRectMake(0,70,120,160)];
        self.rightPreview = [[MS7ConvoPreview alloc] initWithFrame:CGRectMake(320,70,120,160)];
        // [self.leftPreview setBackgroundColor: [UIColor blueColor]];
    }
    return self;
}

-(void)addPreviews {
    [self resetPreviews];

    [self.backPlacard addSubview: self.leftPreview];
    [self.backPlacard addSubview: self.rightPreview];

}

-(void)resetPreviews {
    [self.leftPreview setCenter:CGPointMake(-60,70+80)];
    [self.rightPreview setCenter:CGPointMake(self.backPlacard.frame.size.width+60,70+80)];
}

//delegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // If we're on the converstion list page, don't worry about touches
    if (!self.isInConvo) {
        NSLog(@"Not in convo, ignoring...");
        return NO;
    }

    BOOL detectCenter = NO;
    int edgePercent = 20; //%

    // Get the touch's location in the backPlacard view
    // if between the bounds we care about, return yes, else, no
    CGPoint coord = [touch locationInView: self.backPlacard];
    float w = self.backPlacard.frame.size.width;
    float edgeSize = (edgePercent/100.0)*w;

    if (detectCenter && (coord.x > edgeSize) && (coord.x < w-edgeSize)) {
        NSLog(@"CENTER");
        return YES;
    }
    if (!detectCenter && ((coord.x < edgeSize) || (coord.x > w-edgeSize))) {
        NSLog(@"NOT CENTER");
        return YES;
    }
    NSLog(@"NONE");
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