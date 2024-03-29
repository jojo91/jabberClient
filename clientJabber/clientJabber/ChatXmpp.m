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
#import "RosterViewController.h"

@implementation ChatXmpp

@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;


- (void)initChat:(NSString *)jid :(NSString *)pass
{
    self.conversations = [[NSMutableDictionary alloc] init];
    [self connectWith:jid :pass];
}

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (BOOL)statusOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    NSXMLElement *show = [NSXMLElement elementWithName:@"show"];
    NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
    
    [show setStringValue:@"chat"];
    [status setStringValue:@"Disponible"];

    [presence addChild:show];
    [presence addChild:status];

    [xmppStream sendElement:presence];
    return YES;
}

- (BOOL)statusBusy
{
    XMPPPresence *presence = [XMPPPresence presence];
    NSXMLElement *show = [NSXMLElement elementWithName:@"show"];
    NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
    
    [show setStringValue:@"dnd"];
    [status setStringValue:@"Occupé"];
    
    [presence addChild:show];
    [presence addChild:status];
    
    [self.xmppStream sendElement:presence];
    return YES;
}

- (BOOL)statusAway
{
    XMPPPresence *presence = [XMPPPresence presence];
    NSXMLElement *show = [NSXMLElement elementWithName:@"show"];
    NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
    
    [show setStringValue:@"away"];
    [status setStringValue:@"Non disponible"];
    
    [presence addChild:show];
    [presence addChild:status];
    
    [self.xmppStream sendElement:presence];
    return YES;
}

- (BOOL)StatusOffline
{
    XMPPPresence *presence = [XMPPPresence presence];
    NSXMLElement *show = [NSXMLElement elementWithName:@"show"];
    NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
    
    [show setStringValue:@"xa"];
    [status setStringValue:@"Off"];
    
    [presence addChild:show];
    [presence addChild:status];
    NSLog(@"%@", presence);
    [self.xmppStream sendElement:presence];
    return YES;
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
        return NO;
    }
    self.jid = (NSString*)xmppStream.myJID;
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


- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSLog(@"%@", [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    NSLog(@"error");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{

}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if ([message isChatMessageWithBody])
    {
        XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
                                                                 xmppStream:xmppStream
                                                       managedObjectContext:[self managedObjectContext_roster]];

        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [user displayName];
        
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            NSMutableDictionary *newMessage = [NSMutableDictionary
                                               dictionaryWithDictionary:@{
                                                @"user"    : @"You",
                                                @"message" : body
            }];

            [[self.conversations objectForKey:displayName] addObject:newMessage];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"messageReceived" object:nil];
        }
        else
        {
            // We are not active, so use a local notification instead
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"Ok";
            localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];

            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
    }
}


- (BOOL)sendMessage:(NSString *)message :(NSString *)userName
{
    NSString *messageStr = message;

    if([messageStr length] > 0)
    {
        NSMutableDictionary *newMessage = [NSMutableDictionary
                                           dictionaryWithDictionary:@{
                                                                      @"user"    : @"Me",
                                                                      @"message" : message
                                                                      }];

        [[self.conversations objectForKey:userName] addObject:newMessage];
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];

        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:userName];
        [message addChild:body];

        [xmppStream sendElement:message];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)addContactInRoster:(NSString *)value
{
    XMPPJID *jid = [XMPPJID jidWithString:value];
    if(![value isEqualToString:@""])
    {
        [[self xmppRoster] addUser:jid withNickname:nil];
        value = @"";
        return YES;
    }
    return NO;
    
    value = @"";
}

- (BOOL)removeContactInRoster:(NSString *)value
{
    XMPPJID *jid = [XMPPJID jidWithString:value];
    if(![value isEqualToString:@""])
    {
        [[self xmppRoster] removeUser:jid];
        value = @"";
        return YES;
    }
    return NO;
}


- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSString *asking = [NSString stringWithFormat:@"%@ souhaite vous ajouter dans sa liste de contact", [presence fromStr]];
    UIAlertView *monAlerte = [[UIAlertView alloc]initWithTitle:@"Demande de contact" message:asking delegate:self cancelButtonTitle:@"Refuser" otherButtonTitles:@"Accepter", nil];
     _askingGuy = presence;
    [monAlerte show];
}

-(void)reject
{
    [xmppRoster rejectPresenceSubscriptionRequestFrom:[_askingGuy from]];
}

-(void)accept
{
    [xmppRoster acceptPresenceSubscriptionRequestFrom:[_askingGuy from] andAddToRoster:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self accept];
    }else{
        [self reject];
    }
}


@end
