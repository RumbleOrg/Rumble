#import "RMRootViewController.h"
#import <NetworkExtension/NetworkExtension.h>
#import <NotificationCenter/NotificationCenter.h>

@interface RMRootViewController ()
{
	UIButton *_connectButton;
}
@end

@implementation RMRootViewController

- (NSAttributedString *)getConnectButtonString:(NSString *)title {
	return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40.0f]}];
}

- (void)loadView {
	[super loadView];

	self->_connectButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self->_connectButton setAttributedTitle:[self getConnectButtonString:@"Connect"] forState:UIControlStateNormal];
	// [self->_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
	// [self->_connectButton sizeToFit];
	[self->_connectButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:self->_connectButton];

	[NSLayoutConstraint activateConstraints:@[
		[self->_connectButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
		[self->_connectButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
		// [self->_connectButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
	]];
	
	[self->_connectButton addTarget:self action:@selector(connectButtonTapped:) forControlEvents:UIControlEventPrimaryActionTriggered];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		   selector:@selector(vpnStatusDidChange:)
		       name:NEVPNStatusDidChangeNotification
		     object:nil];
}

- (void)loadManager:(void (^)(NETunnelProviderManager *))withManager {
	[NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:
		^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
		if (error)
		{
			NSLog(@"loadAllFromPreferences error: %@", error);
		}
		else 
		{
			NETunnelProviderManager *mgr = managers.lastObject;
			if (mgr)
			{
				[mgr loadFromPreferencesWithCompletionHandler:
					^(NSError * _Nullable error) {
						if (error)
						{
							NSLog(@"loadFromPreferences error: %@", error);
						}

						withManager(mgr);
					}];
			}
			else
			{
				mgr = [[NETunnelProviderManager alloc] init];
				NETunnelProviderProtocol *prot = [[NETunnelProviderProtocol alloc] init];

				mgr.localizedDescription = @"Rumble";
				prot.providerBundleIdentifier = @"com.rpcsx.rumble.ext";
				prot.serverAddress = @"localhost";
				prot.providerConfiguration = @{
					@"args": @"",
					@"IPv6": [NSNumber numberWithBool:YES]
				};
				mgr.protocolConfiguration = prot;
				mgr.enabled = YES;

				[mgr saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {

					if (error)
					{
						NSLog(@"saveToPreferences error: %@", error);
					}

					[mgr loadFromPreferencesWithCompletionHandler:
						^(NSError * _Nullable error) {
							if (error)
							{
								NSLog(@"loadFromPreferences error: %@", error);
							}

							withManager(mgr);
						}];
				}];

			}
		}
	}];
}

- (void)connectButtonTapped:(id)sender {
      [self loadManager: ^(NETunnelProviderManager *mgr)
      {
	      NEVPNStatus status = mgr.connection.status;
	      NSLog(@"connectButton: VPN status is: %ld", (long)status);
	      if (status != NEVPNStatusConnected)
	      {
		      NSLog(@"Starting VPN tunnel...");
		      NSError *startError;
		      [mgr.connection startVPNTunnelAndReturnError:&startError];
		      if (startError) {
			      NSLog(@"startVPNTunnel error: %@", startError.localizedDescription);
		      }
		      /* Prevent connections from leaking */
		      [[NSNotificationCenter defaultCenter]
			      removeObserver:self];
		      [[NSNotificationCenter defaultCenter]
			      addObserver:self
				 selector:@selector(vpnStatusDidChange:)
				     name:NEVPNStatusDidChangeNotification
				   object:mgr.connection];
	      }
	      else
	      {
		      NSLog(@"Stopping VPN tunnel...");
		      [mgr.connection stopVPNTunnel];
	      }
      }];
}

- (void)vpnStatusDidChange:(NSNotification *)notification {
	NETunnelProviderSession *session = (NETunnelProviderSession *)[notification object];
	if (!session)
	{
		return;
	}

	NEVPNStatus status = session.status;

	NSLog(@"vpnStatusDidChange: %ld, object: %@", (long)status, [notification object]);
	switch (status)
	{
	    case NEVPNStatusInvalid:
	    case NEVPNStatusDisconnected:
		[self->_connectButton setAttributedTitle:[self getConnectButtonString:@"Connect"] forState:UIControlStateNormal];
		[self->_connectButton setEnabled:YES];
		[self->_connectButton invalidateIntrinsicContentSize];
		break;
	    case NEVPNStatusConnecting:
		[self->_connectButton setAttributedTitle:[self getConnectButtonString:@"Connecting..."] forState:UIControlStateDisabled];
		[self->_connectButton setEnabled:NO];
		[self->_connectButton invalidateIntrinsicContentSize];
		break;
	    case NEVPNStatusConnected:
		[self->_connectButton setAttributedTitle:[self getConnectButtonString:@"Disconnect"] forState:UIControlStateNormal];
		[self->_connectButton setEnabled:YES];
		[self->_connectButton invalidateIntrinsicContentSize];
		break;
	    case NEVPNStatusReasserting:
		[self->_connectButton setAttributedTitle:[self getConnectButtonString:@"Reconnecting"] forState:UIControlStateDisabled];
		[self->_connectButton setEnabled:NO];
		[self->_connectButton invalidateIntrinsicContentSize];
		break;
	    case NEVPNStatusDisconnecting:
		[self->_connectButton setAttributedTitle:[self getConnectButtonString:@"Disconnecting..."] forState:UIControlStateDisabled];
		[self->_connectButton setEnabled:NO];
		[self->_connectButton invalidateIntrinsicContentSize];
		break;
	    default:
		    break;
	}
}

@end
