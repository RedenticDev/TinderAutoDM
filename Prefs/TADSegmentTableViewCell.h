#import <UIKit/UIKit.h>

@interface TADSegmentTableViewCell : UITableViewCell
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSString *key;
-(void)configureCellWithElements:(NSArray<NSString *> *)elements default:(NSInteger)index key:(NSString *)key;
-(void)segmentChanged:(UISegmentedControl *)sender;
@end
