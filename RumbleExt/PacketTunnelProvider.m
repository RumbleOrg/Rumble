#import "PacketTunnelProvider.h"

@implementation PacketTunnelProvider

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler {
	// Add code here to start the process of connecting the tunnel.
	if (![self.protocolConfiguration
			isKindOfClass:[NETunnelProviderProtocol class]])
	{
		completionHandler([NSError
				errorWithDomain:NEVPNErrorDomain
					   code:NEVPNErrorConfigurationInvalid
				       userInfo:nil]);
		return;
	}

	NETunnelProviderProtocol *prot = (NETunnelProviderProtocol *)self.protocolConfiguration;
	id argsObject = prot.providerConfiguration[@"args"];
	if (![argsObject isKindOfClass:[NSString class]])
	{
		completionHandler([NSError
				errorWithDomain:NEVPNErrorDomain
					   code:NEVPNErrorConfigurationInvalid
				       userInfo:nil]);
		return;
	}

	id isIPv6Object = prot.providerConfiguration[@"IPv6"];
	if (![isIPv6Object isKindOfClass:[NSNumber class]])
	{
		completionHandler([NSError
				errorWithDomain:NEVPNErrorDomain
					   code:NEVPNErrorConfigurationInvalid
				       userInfo:nil]);
		return;
	}

	BOOL isIPv6 = [(NSNumber *)isIPv6Object boolValue];

	NSString * args = (NSString *)argsObject;
	(void)args;

	NEPacketTunnelNetworkSettings * tunConf = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:@"127.0.0.1"];
	NEIPv4Settings *v4Conf = [[NEIPv4Settings alloc] initWithAddresses:@[@"10.10.10.10"] subnetMasks:@[@"255.255.255.255"]];
	v4Conf.includedRoutes = @[[[NEIPv4Route alloc] initWithDestinationAddress:@"0.0.0.0" subnetMask:@"0.0.0.0"] ];
	tunConf.IPv4Settings = v4Conf;
	if (isIPv6)
	{
		NEIPv6Settings *v6Conf = [[NEIPv6Settings alloc] initWithAddresses:@[@"fd00::1"] networkPrefixLengths:@[@128]];
		tunConf.IPv6Settings = v6Conf;
	}
	/* TODO: DNS settings? */

	[self setTunnelNetworkSettings:tunConf completionHandler:^(NSError * _Nullable error) {
		/* XXX: start tun2socks + byedpi */
		completionHandler(nil);
	}];
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
	/* XXX: stop tun2socks + byedpi */
	// Add code here to start the process of stopping the tunnel.
	completionHandler();
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler {
	// Add code here to handle the message.
	completionHandler(nil);
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler {
	// Add code here to get ready to sleep.
	completionHandler();
}

- (void)wake {
	// Add code here to wake up.
}

@end
