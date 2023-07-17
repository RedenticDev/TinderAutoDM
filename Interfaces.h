#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIKit.h>

#pragma mark - Interfaces
@interface TNDRHTTPRequestClient : NSObject
- (void)sendMessage:(NSString *)message withParams:(id)params toMatch:(NSString *)matchID completion:(id)completion;
@end

// @interface TNDRMatchesViewController : UITableViewController
// @property (nonatomic, strong, readwrite) UIView *headerViewContainer;
// @end

@interface TNDRNewMatchesViewController : UICollectionViewController
@property (nonatomic, strong, readwrite) UIView *matchesHeaderView;
@end


#pragma mark - Variables
static TNDRHTTPRequestClient *client;

#pragma mark - Preferences
static NSString *message;
static BOOL showAlert;
