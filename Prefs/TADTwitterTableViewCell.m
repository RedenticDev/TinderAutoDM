#import "TADTwitterTableViewCell.h"

@implementation TADTwitterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		// Icon
		UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		icon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		icon.center = CGPointMake(icon.center.x + self.separatorInset.left, self.contentView.center.y);
		icon.clipsToBounds = YES;
		icon.layer.cornerRadius = icon.frame.size.width / 2;
		[self.contentView addSubview:icon];

		// Activity indicator for icon
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:icon.bounds];
		activityIndicator.hidesWhenStopped = YES;
		[icon addSubview:activityIndicator];


		[activityIndicator startAnimating];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/RedenticDev/RedenticDev/main/Me.png"]];
			UIImage *picture = [UIImage imageWithData:data];
			dispatch_async(dispatch_get_main_queue(), ^{
				[activityIndicator stopAnimating];
				[activityIndicator removeFromSuperview];
				icon.image = picture;
			});
		});
		
		// Main label
		UILabel *titleLabel = [[UILabel alloc] init];
		titleLabel.text = @"Redentic";
		titleLabel.textColor = [UIColor systemBlueColor];
		titleLabel.numberOfLines = 1;
		titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:titleLabel];
		
		// Detail label
		UILabel *detailLabel = [[UILabel alloc] init];
		detailLabel.text = @"@RedenticDev";
		detailLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 2.0];
		detailLabel.numberOfLines = 1;
		detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:detailLabel];

		self.url = [NSURL URLWithString:@"https://twitter.com/RedenticDev"];

		self.accessoryView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"twitter"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
		self.accessoryView.tintColor = [UIColor grayColor];

		NSDictionary *views = @{
			@"icon" : icon,
			@"title" : titleLabel,
			@"detail" : detailLabel
		};

		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[title]-3-[detail]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[icon]-[title]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[icon]-[detail]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

		self.contentView.frame = CGRectInset(self.contentView.frame, self.separatorInset.left, self.separatorInset.right);
	}
	return self;
}

@end
