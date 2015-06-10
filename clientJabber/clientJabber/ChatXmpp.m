//
//  ChatXmpp.m
//  clientJabber
//
//  Created by Jonathan Lequeux on 6/8/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import "ChatXmpp.h"
#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"

@implementation ChatXmpp

@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;


- (void)initChat:(NSString *)jid :(NSString *)pass
{
    NSLog(@"Initialisation du chat");
    [self connectWith:jid :pass];

}

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (void)setupStream
{
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream setHostName:@"localhost"];
    [xmppStream setHostPort:5222];
    
    // ROSTER //
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    xmppRoster        = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    [xmppRoster            activate:xmppStream];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    ////////////
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
}

- (BOOL)connectWith:(NSString *)jid :(NSString *)pass
{
    [self setupStream];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (jid == nil || pass == nil) {
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    self.password = pass;
    
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        NSLog(@"fail");
        return NO;
    }
    NSLog(@"success");
    return YES;
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    self.isOpen = YES;
    
    NSError *error = nil;
    
    if (![[self xmppStream] authenticateWithPassword:self.password error:&error])
    {
        NSLog(@"NO");
    }
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
    }
    else
    {
        body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
    }
    
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:nil
                                                  cancelButtonTitle:@"Not implemented"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Not implemented";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
    
}



@end
