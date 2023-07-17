#import "Interfaces.h"
#import "Categories/UIImage+Size.h"
#import "Prefs/TADSettingsTableViewController.h"


static void vibrate() {
    if ([[[UIDevice currentDevice] valueForKey:@"_feedbackSupportLevel"] integerValue] > 1) {
        [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    } else {
        AudioServicesPlaySystemSound(1519);
    }
}

%hook TNDRHTTPRequestClient

- (instancetype)initWithBaseURL:(id)url {
    if ((self = %orig)) {
        if (!client) client = self;
        NSLog(@"[%@] Client ok, value: %@", NSStringFromSelector(_cmd), client);
    }

    return self;
}

- (void)dealloc {
    %orig;
    client = nil;
    NSLog(@"Client removed");
}

%end

%hook TNDRNewMatchesViewController

- (void)viewDidLoad {
    %orig;

    BOOL fourteen = NO;
    if (@available(iOS 14.0, *)) fourteen = YES;
    UIImage *sendImage = [[UIImage systemImageNamed:fourteen ? @"arrow.up.message.fill" : @"paperplane.fill"] imageScaledWithLargestSide:40];
    UIImage *settingsImage = [[UIImage systemImageNamed:fourteen ? @"gearshape.fill" : @"gear"] imageScaledWithLargestSide:40];

    UIButton *autoSendButton = [UIButton systemButtonWithImage:sendImage target:self action:@selector(tinderautodm_sendDMs:)];
    [autoSendButton setImage:[sendImage imageWithTintColor:[UIColor systemGrayColor]] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    autoSendButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *settingsButton = [UIButton systemButtonWithImage:settingsImage target:self action:@selector(tinderautodm_openSettings:)];
    [settingsButton setImage:[settingsImage imageWithTintColor:[UIColor systemGrayColor]] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    settingsButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.matchesHeaderView addSubview:autoSendButton];
    [self.matchesHeaderView addSubview:settingsButton];

    [self.matchesHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[btn]-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{ @"btn" : autoSendButton }]];
    [self.matchesHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[gear]-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{ @"gear" : settingsButton }]];
    [self.matchesHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn]-[gear]-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{ @"btn" : autoSendButton, @"gear" : settingsButton }]];

    /*UIStackView *buttonsContainer = [[UIStackView alloc] initWithArrangedSubviews:@[autoSendButton, settingsButton]];
    buttonsContainer.alignment = UIStackViewAlignmentCenter;
    buttonsContainer.axis = UILayoutConstraintAxisHorizontal;
    buttonsContainer.distribution = UIStackViewDistributionFillEqually;
    buttonsContainer.spacing = 20;

    UIStackView *stackContainer = [[UIStackView alloc] initWithArrangedSubviews:@[buttonsContainer]];
    stackContainer.alignment = UIStackViewAlignmentCenter;
    stackContainer.axis = UILayoutConstraintAxisVertical;
    stackContainer.distribution = UIStackViewDistributionEqualCentering;
    // OK
    UIStackView *generalContainer = [[UIStackView alloc] initWithArrangedSubviews:@[stackContainer, self.headerViewContainer]]; // self.headerViewContainer / self.tableView.tableHeaderView
    generalContainer.alignment = UIStackViewAlignmentFill;
    generalContainer.axis = UILayoutConstraintAxisVertical;
    generalContainer.distribution = UIStackViewDistributionFill;

    self.tableView.tableHeaderView = generalContainer;*/
}

%new
- (void)tinderautodm_sendDMs:(id)sender {
    vibrate();

    if (!message || [message isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Empty text to send" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (showAlert) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"TinderAutoDM" message:@"Do you really want to send DMs with selected options?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // [client sendMessage:message withParams:nil toMatch:@"573c6247108086f30da233485acc6bab2137fa951bb3cfa4" completion:nil];
            NSLog(@"message \"%@\" sent to match \"%@\"", message, @"573c6247108086f30da233485acc6bab2137fa951bb3cfa4");
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // [client sendMessage:message withParams:nil toMatch:@"573c6247108086f30da233485acc6bab2137fa951bb3cfa4" completion:nil];
        NSLog(@"message \"%@\" sent to match \"%@\"", message, @"573c6247108086f30da233485acc6bab2137fa951bb3cfa4");
    }
}

%new
- (void)tinderautodm_openSettings:(id)sender {
    vibrate();

    UINavigationController *settings = [[UINavigationController alloc] initWithRootViewController:[[TADSettingsTableViewController alloc] init]];
    settings.presentationController.delegate = (TADSettingsTableViewController *)settings.viewControllers[0];

    [self presentViewController:settings animated:YES completion:nil];
}

%end

static void tinderautodm_reloadPrefs() {
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"TinderAutoDM"];
    message = [prefs objectForKey:@"message"];
    showAlert = [prefs boolForKey:@"showAlert"];
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)tinderautodm_reloadPrefs, CFSTR("com.redenticdev.tinderautodm/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);

    tinderautodm_reloadPrefs();

    %init;
}
