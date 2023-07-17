#import "UIImage+Size.h"

@implementation UIImage (Size)

- (UIImage *)imageScaledWithLargestSide:(CGFloat)wantedSize {
	CGSize actualSize = self.size;
	CGSize newSize = CGSizeZero;
	if (actualSize.width == actualSize.height) {
		newSize.width = (wantedSize / actualSize.width) * actualSize.width;
		newSize.height = (wantedSize / actualSize.height) * actualSize.height;
	} else if (actualSize.width > actualSize.height) {
		newSize.width = (wantedSize / actualSize.width) * actualSize.width;
		newSize.height = (wantedSize / actualSize.width) * actualSize.height;
	} else {
		newSize.width = (wantedSize / actualSize.height) * actualSize.width;
		newSize.height = (wantedSize / actualSize.height) * actualSize.height;
	}

	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
	[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end
