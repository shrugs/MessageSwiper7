
// ChatKit imports
#import <iOS7/PrivateFrameworks/ChatKit/CKTranscriptController.h>
#import <iOS7/PrivateFrameworks/ChatKit/CKConversationList.h>
#import <iOS7/PrivateFrameworks/ChatKit/CKConversation.h>

// Messages imports
#import "MobileSMS/CKMessagesController.h"

// UIKit imports
#import <iOS7/Frameworks/UIKit/UIGestureRecognizer.h>
#import <iOS7/Frameworks/UIKit/UIView.h>


// PREFERENCES
#define PrefPath [[@"~" stringByExpandingTildeInPath] stringByAppendingPathComponent:@"Library/Preferences/com.mattcmultimedia.messageswiper7.plist"]


#import "MessageSwiper7/MS7ConvoPreview.h"
// create the preview images
static MS7ConvoPreview *leftPreview = [[%c(MS7ConvoPreview) alloc] initWithFrame:CGRectMake(-60,10,120,160)];
static MS7ConvoPreview *rightPreview = [[%c(MS7ConvoPreview) alloc] initWithFrame:CGRectMake(320+60,10,120,160)];

static UIView *backPlacard;
























%hook CKTranscriptController

- (id)initWithNavigationController:(id)navigationController {
    backPlacard = self.view;
    // create the preview images
    leftPreview = [[%c(MS7ConvoPreview) alloc] initWithFrame:CGRectMake(-60,10,120,160)];
    rightPreview = [[%c(MS7ConvoPreview) alloc] initWithFrame:CGRectMake(backPlacard.frame.size.width+60,10,120,160)];

    return %orig;
}

%end


%hook CKMessagesController

- (id)currentConversation { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (void)setPrimaryNavigationController:(id)fp8 { %log; %orig; }
// - (id)primaryNavigationController { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)setTranscriptController:(id)fp8 { %log; %orig; }
- (void)setConversationListController:(id)fp8 { %log; %orig; }
- (id)conversationListController { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (void)mailComposeController:(id)fp8 didFinishWithResult:(int)fp12 error:(id)fp16 { %log; %orig; }
// - (void)showMailComposeSheetForAddress:(id)fp8 { %log; %orig; }
// - (void)_showMailComposeSheet { %log; %orig; }
// - (void)showNewMessageCompositionForMessageParts:(id)fp8 { %log; %orig; }
- (void)_conversationLeft:(id)fp8 { %log; %orig; }
// - (void)_handleConversationBecameStale:(id)fp8 { %log; %orig; }


- (BOOL)isShowingTranscriptWithUnsentText { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)showUnreadConversationsWithLastConversation:(id)fp8 ignoringMessages:(id)fp12 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)hasUnreadFilteredConversationsIgnoringMessages:(id)fp8 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (void)showConversationList:(BOOL)fp8 { %log; %orig; }
- (BOOL)resumeToConversation:(id)fp8 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// - (void)showConversationAndMessageForSearchURL:(id)fp8 { %log; %orig; }
// - (void)showConversationAndMessageForChatGUID:(id)fp8 messageGUID:(id)fp12 animate:(BOOL)fp16 { %log; %orig; }
- (void)showConversation:(id)fp8 animate:(BOOL)fp12 { %log; %orig; }
- (void)showConversation:(id)fp8 animate:(BOOL)fp12 forceToTranscript:(BOOL)fp16 { %log; %orig; }
- (id)transcriptController { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (BOOL)isShowingTranscriptController { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// - (BOOL)isShowingConversationListController { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (void)_showTranscriptController:(BOOL)fp8 { %log; %orig; }
- (void)_showTranscriptController:(BOOL)fp8 animated:(BOOL)fp12 { %log; %orig; }

- (void)transcriptController:(id)fp8 didSelectNewConversation:(id)fp12 { %log; %orig; }

- (void)transcriptController:(id)fp8 didSendMessageInConversation:(id)fp12 { %log; %orig; }
// - (void)transcriptController:(id)fp8 willSendComposition:(id)fp12 inConversation:(id)fp16 { %log; %orig; }
// - (void)didCancelComposition:(id)fp8 { %log; %orig; }

// - (void)cancelNewMessageComposition { %log; %orig; }
// - (void)hideNewMessageCompositionPanel { %log; %orig; }
// - (void)showNewMessageCompositionPanelAnimated:(BOOL)fp8 { %log; %orig; }
// - (void)showNewMessageCompositionPanelWithRecipients:(id)fp8 composition:(id)fp12 animated:(BOOL)fp16 { %log; %orig; }
- (void)_popToConversationListAndPerformBlockAnimated:(BOOL)fp8 block:(id)fp { %log; %orig; }
// - (void)_presentNewMessageCompositionPanel:(id)fp8 animated:(BOOL)fp12 { %log; %orig; }

- (void)setCurrentConversation:(id)fp8 { %log; %orig; }

- (void)navigationController:(id)fp8 didShowViewController:(id)fp12 animated:(BOOL)fp16 { %log; %orig; }
- (void)navigationController:(id)fp8 willShowViewController:(id)fp12 animated:(BOOL)fp16 { %log; %orig; }
// - (void)viewDidDisappear:(BOOL)fp8 { %log; %orig; }
// - (void)viewWillDisappear:(BOOL)fp8 { %log; %orig; }
// - (void)viewDidAppear:(BOOL)fp8 { %log; %orig; }
// - (void)viewWillAppear:(BOOL)fp8 { %log; %orig; }


// - (void)viewDidUnload { %log; %orig; }
// - (void)loadView { %log; %orig; }
// - (void)parentControllerDidBecomeActive { %log; %orig; }
// - (void)parentControllerDidResume:(BOOL)fp8 animating:(BOOL)fp12 { %log; %orig; }
- (id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
