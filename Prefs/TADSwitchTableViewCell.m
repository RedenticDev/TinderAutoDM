#import "TADSwitchTableViewCell.h"

@implementation TADSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
		self.accessoryView = self.switchView;
	}
	return self;
}

- (void)configureCellWithLabel:(NSString *)label defaultValue:(BOOL)value key:(NSString *)key {
	self.textLabel.text = label;
	NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"TinderAutoDM"];
	if ([defaults objectForKey:key]) {
		self.switchView.on = [defaults boolForKey:key];
	} else {
		self.switchView.on = value;
		[defaults setBool:value forKey:key];
	}
	[self.switchView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	self.key = key;
}

- (void)valueChanged:(UISwitch *)sender {
	[[[NSUserDefaults alloc] initWithSuiteName:@"TinderAutoDM"] setBool:sender.isOn forKey:self.key];
}

@end
