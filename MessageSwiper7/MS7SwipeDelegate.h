
#import "MS7ConvoPreview.h"
@interface MS7SwipeDelegate : NSObject <UIGestureRecognizerDelegate>

@property (retain, nonatomic) UIView *backPlacard;
@property (retain, nonatomic) MS7ConvoPreview *leftPreview;
@property (retain, nonatomic) MS7ConvoPreview *rightPreview;
@property (retain, nonatomic) NSMutableArray *convos;
@property (assign, nonatomic) int currentConvoIndex;

-(void)MS7_handlepan:(UIPanGestureRecognizer *)recognizer;
-(void)addPreviews;

@end