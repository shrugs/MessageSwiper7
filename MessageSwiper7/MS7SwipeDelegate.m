#import "MS7SwipeDelegate.h"

@implementation MS7SwipeDelegate

@synthesize backPlacard = _backPlacard;
@synthesize leftPreview = _leftPreview;
@synthesize rightPreview = _rightPreview;
@synthesize isInConvo = _isInConvo;


-(void)MS7_handlepan:(UIPanGestureRecognizer *)recognizer
{
    // CGPoint originalLocation;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // reset the previews just in case they're still animating
        [self.backPlacard.layer removeAllAnimations];
        [self resetPreviewsAnimated:NO];
        [self.leftPreview setHidden: NO];
        [self.rightPreview setHidden: NO];
    }

    NSLog(@"%@", NSStringFromCGPoint(self.leftPreview.center));
    NSLog(@"%@", NSStringFromCGPoint(self.rightPreview.center));

    // now move both of the views max(translation, 120)
    int translation = [recognizer translationInView:recognizer.view].x;
    NSLog(@"%i", translation);

    // Move both previews
    // NOTE: make sure to update preview contents when the conversation changes, not on the handle pan
    int newX = (int) -60+translation;
    [self.leftPreview setCenter:CGPointMake(MIN(60, newX), self.leftPreview.center.y)];
    newX = (int) self.backPlacard.frame.size.width+60+translation;
    [self.rightPreview setCenter:CGPointMake(MAX(self.backPlacard.frame.size.width-60, newX), self.rightPreview.center.y)];


    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self resetPreviewsAnimated:YES];
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
    [self resetPreviewsAnimated: NO];

    [self.backPlacard addSubview: self.leftPreview];
    [self.backPlacard addSubview: self.rightPreview];
    [self.leftPreview setHidden:YES];
    [self.rightPreview setHidden: YES];

}

-(void)resetPreviewsAnimated:(BOOL)shouldAnimate {
    if (!shouldAnimate) {
        [self.leftPreview setCenter:CGPointMake(-60,70+80)];
        [self.rightPreview setCenter:CGPointMake(self.backPlacard.frame.size.width+60,70+80)];
        [self.leftPreview setHidden:YES];
        [self.rightPreview setHidden: YES];
    } else {
        // animate to default positions.
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                            self.leftPreview.center = CGPointMake(-60, 70+80);
                            // [self.leftPreview setCenter:CGPointMake(-60,70+80)];
                            // [self.rightPreview setCenter:CGPointMake(self.backPlacard.frame.size.width+60,70+80)];
                            self.rightPreview.center = CGPointMake(self.backPlacard.frame.size.width+60, 70+80);
                         }
                         completion:^(BOOL finished){
                             [self.leftPreview setHidden:YES];
                             [self.rightPreview setHidden: YES];
                         }];
    }
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