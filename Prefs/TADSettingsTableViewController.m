#import "TADSettingsTableViewController.h"
#import "TADTwitterTableViewCell.h"
#import "TADSwitchTableViewCell.h"
#import "TADSegmentTableViewCell.h"

@implementation TADSettingsTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
	return self = [super initWithStyle:UITableViewStyleInsetGrouped];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0;
	self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)loadView {
    [super loadView];

    self.title = @"TinderAutoDM";
	self.navigationController.navigationBar.prefersLargeTitles = YES;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeSettings:)];
}

- (void)closeSettings:(id)sender {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.redenticdev.tinderautodm/ReloadPrefs"), NULL, NULL, true);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Adaptive Presentation Delegate
- (void)presentationControllerWillDismiss:(UIPresentationController *)presentationController {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.redenticdev.tinderautodm/ReloadPrefs"), NULL, NULL, true);
}

#pragma mark - Table View Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 1:
			return @"Custom text";

		case 2:
			return @"Start DM from";

		case 3:
			return @"Auto trigger";

		default:
			return [super tableView:tableView titleForHeaderInSection:section];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == [tableView numberOfSections] - 1) {
		UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0 - self.tableView.separatorInset.left, 0, self.tableView.bounds.size.width, 100)];
		UILabel *footerLabel = [[UILabel alloc] initWithFrame:footerView.frame];
		footerLabel.text = @"Made with ❤️ by RedenticDev";
		footerLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 1.0];
		footerLabel.textColor = [UIColor grayColor];
		footerLabel.textAlignment = NSTextAlignmentCenter;
		[footerView addSubview:footerLabel];

		return footerView;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == [tableView numberOfSections] - 1) {
		return 100;
	}
	return [super tableView:tableView heightForFooterInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = [NSString stringWithFormat:@"s%li-r%li", (long)indexPath.section, (long)indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		switch (indexPath.section) {
			case 0: // twitter
				cell = [[TADTwitterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
				break;

			case 1: // custom text
				cell = [[TADTextEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]; // TODO
				[(TADTextEditTableViewCell *)cell configureCellWithLabel:@"Custom Text" placeholder:@"Enter text..." defaultValue:nil key:@"message"];
				break;

			case 2: // start dm from
				cell = [[TADSegmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
				[(TADSegmentTableViewCell *)cell configureCellWithElements:@[@"Newest", @"Oldest"] default:0 key:@"startFrom"];
				break;

			case 3: // auto trigger
				cell = [[TADSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
				[(TADSwitchTableViewCell *)cell configureCellWithLabel:@"Auto trigger" defaultValue:NO key:@"autoTrigger"];
				break;

			case 4:
				switch (indexPath.row) {
					case 0: // After delay YES/NO
						cell = [[TADSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
						[(TADSwitchTableViewCell *)cell configureCellWithLabel:@"After app launch" defaultValue:NO key:@"afterAppLaunch"];
						break;

					case 1: // TODO: Delay TEXTEDIT NUMBER
						// "Delay after launch"
						break;
					
					case 2: // Repeat YES/NO
						cell = [[TADSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
						[(TADSwitchTableViewCell *)cell configureCellWithLabel:@"Repeat" defaultValue:NO key:@"repeat"];
						break;
					
					case 3: // TODO: Repeat every X minutes
						break;

					default:
						break;
				}
				break;

			case 5:
				switch (indexPath.row) {
					case 0: // Random delay? YES/NO
						cell = [[TADSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
						[(TADSwitchTableViewCell *)cell configureCellWithLabel:@"Repeat with random delay" defaultValue:NO key:@"randomDelay"];
						break;

					case 1: // TODO: Delay range
						break;

					default:
						break;
				}
				break;

			case 6:
				switch (indexPath.row) {
					case 0: // TODO: Only if match is X days old
						break;

					case 1: // TODO: Only if match hasn't been reached for X days
						break;

					default:
						break;
				}
				break;

			default:
				break;
		}
	}

	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0: // twitter
			return 1;

		case 1: // custom text
			return 1;

		case 2: // start dm from
			return 1;

		case 3: // auto trigger
			return 1;

		case 4:
			return 4;

		case 5:
			return 2;

		case 6:
			return 2;

		default:
			return [super tableView:tableView numberOfRowsInSection:section];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	if ([cell isKindOfClass:[TADTwitterTableViewCell class]]) {
		return 60;
	}
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	if ([cell isKindOfClass:[TADTwitterTableViewCell class]]) {
		[[UIApplication sharedApplication] openURL:((TADTwitterTableViewCell *)cell).url options:@{} completionHandler:nil];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
