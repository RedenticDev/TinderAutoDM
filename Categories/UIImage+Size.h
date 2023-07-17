#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Size)
- (UIImage *)imageScaledWithLargestSide:(CGFloat)wantedSize;
@end

NS_ASSUME_NONNULL_END
