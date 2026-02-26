#import <Foundation/Foundation.h>
#import "RMSettingsViewController.h"

@implementation RMSettingsViewController
- (void)loadView {
	[super loadView];

	self.navigationItem.title = @"Settings";

	self->settings = @[
		@{@"name": @"IPv6", @"display": @"Use IPv6", @"type": @"BOOL"},

		@{@"name": @"DNSServer", @"display": @"DNS Server",
		  @"type": NSStringFromClass([NSString class]), @"default": @"1.1.1.1"},

		@{@"name": @"Args", @"display": @"Arguments",
		  @"type": NSStringFromClass([NSString class]), @"default":
			//@"--pf 443 --proto tls --hosts ':discord.media' --oob 1+s --auto=none "
			//"--pf 443 --proto tls --disorder 1 --split -5+se --auto=none "

			@"--pf 443 --proto tls --disorder 1 --split -5+se --auto=none "
			"--pf 443 --proto udp --ttl 64 --udp-fake 20 --fake-data "
			"':@\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
			"\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0' --auto=none"
			"--pf 80 --proto http --auto=none"
			"--pf 50000-50099 --proto udp --ttl 64 --udp-fake 6 --round 1-4"
		},
	];
}

- (void) viewDidLoad {
	for (NSDictionary *setting in self->settings) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		id defaultValue = setting[@"default"];
		if (defaultValue != nil
				&& [defaults objectForKey:setting[@"name"]] == nil)
		{
			[defaults setObject:defaultValue forKey:setting[@"name"]];
		}
	}

	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

#pragma mark - Table View Data Source
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	if (self.tableView != tableView)
	{
		return 0;
	}

	return settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.tableView != tableView)
	{
		return nil;
	}

	NSDictionary *setting = self->settings[indexPath.row];
	if (setting == nil)
	{
		return nil;
	}

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	NSString *typeName = setting[@"type"];
	if ([@"BOOL" isEqualToString:typeName])
	{
		cell.textLabel.text = setting[@"display"];

		BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:setting[@"name"]];
		UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
		[switchView setOn:value animated:NO];
		[switchView setTag:indexPath.row];
		[switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
		cell.accessoryView = switchView;
		[[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		return cell;
	}
	else if ([NSStringFromClass([NSString class]) isEqualToString:typeName])
	{
		cell.textLabel.text = nil;
		NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:setting[@"name"]];

		UITextView *textView = [[UITextView alloc] init];
		textView.text = value;
		textView.tag = indexPath.row;
		textView.delegate = self;
		textView.font = [UIFont fontWithName:@"Courier New" size:[UIFont systemFontSize]];
		textView.textAlignment = NSTextAlignmentLeft;
		textView.autocorrectionType = UITextAutocorrectionTypeNo;
		textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textView.spellCheckingType = UITextSpellCheckingTypeNo;
		textView.keyboardType = UIKeyboardTypeWebSearch;
		textView.returnKeyType = UIReturnKeyDone;
		textView.editable = YES;
		textView.selectable = YES;
		textView.scrollEnabled = NO;                   // Critical for auto-sizing - height follows content
		textView.translatesAutoresizingMaskIntoConstraints = NO;
		[textView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
		[textView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

		UILabel *configLabel = [[UILabel alloc] init];
		configLabel.text = setting[@"display"];

		UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[configLabel, textView]];
		[cell.contentView addSubview:stackView];
		stackView.axis = UILayoutConstraintAxisVertical;
		stackView.distribution = UIStackViewDistributionFill;
		stackView.alignment = UIStackViewAlignmentLeading;
		stackView.spacing = 8;
		[stackView layoutSubviews];

		stackView.translatesAutoresizingMaskIntoConstraints = NO;
		[NSLayoutConstraint activateConstraints:@[
			[stackView.leftAnchor constraintEqualToAnchor:cell.contentView.layoutMarginsGuide.leftAnchor],
			[stackView.rightAnchor constraintEqualToAnchor:cell.contentView.layoutMarginsGuide.rightAnchor],
			[stackView.topAnchor constraintEqualToAnchor:cell.contentView.layoutMarginsGuide.topAnchor],
			[stackView.bottomAnchor constraintEqualToAnchor:cell.contentView.layoutMarginsGuide.bottomAnchor],
		]];
		return cell;
	}
	return cell;
}


- (void)switchChanged:(UISwitch*)sender {
	[[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:settings[sender.tag][@"name"]];
}

- (void)textFieldEditingDidEnd:(UITextField*)sender {
	[[NSUserDefaults standardUserDefaults] setObject:sender.text forKey:settings[sender.tag][@"name"]];
	[sender resignFirstResponder];
}

#pragma mark - Table View Delegate
- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	if (self.tableView != tableView)
	{
		return;
	}
}

#pragma mark - Text View Delegate
- (void)textViewDidChange:(UITextView *)textView {
    // Invalidate the intrinsic content size so the text view reports its new height
    [textView invalidateIntrinsicContentSize];

    // Tell the table view to recalculate cell heights
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[[NSUserDefaults standardUserDefaults] setObject:textView.text forKey:settings[textView.tag][@"name"]];
}


@end
