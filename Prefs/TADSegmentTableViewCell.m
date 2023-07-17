#import "TADSegmentTableViewCell.h"

@implementation TADSegmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		// Segment
		self.segment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x + 5, self.contentView.frame.origin.y + 5, self.contentView.frame.size.width + 12, self.contentView.frame.size.height - 10)];
		[self.contentView addSubview:self.segment];
	}
	return self;
}

- (void)configureCellWithElements:(NSArray<NSString *> *)elements default:(NSInteger)index key:(NSString *)key {
	for (NSString *element in elements) {
		[self.segment insertSegmentWithTitle:element atIndex:[elements indexOfObject:element] animated:YES];
	}
	NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"TinderAutoDM"];
	if ([defaults objectForKey:key]) {
		self.segment.selectedSegmentIndex = [defaults integerForKey:key];
	} else {
		self.segment.selectedSegmentIndex = index;
		[defaults setInteger:index forKey:key];
	}
	[self.segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
	self.key = key;
}

- (void)segmentChanged:(UISegmentedControl *)sender {
	[[[NSUserDefaults alloc] initWithSuiteName:@"TinderAutoDM"] setInteger:self.segment.selectedSegmentIndex forKey:self.key];
}

@end
