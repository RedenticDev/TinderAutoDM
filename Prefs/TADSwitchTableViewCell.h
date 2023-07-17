#import <UIKit/UIKit.h>

@interface TADSwitchTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) UISwitch *switchView;
-(void)configureCellWithLabel:(NSString *)label defaultValue:(BOOL)value key:(NSString *)key;
-(void)valueChanged:(UISwitch *)sender;
@end
