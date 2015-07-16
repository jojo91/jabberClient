//
//  RosterViewController.m
//  clientJabber
//
//  Created by Yonael Tordjman on 09/06/2015.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import "RosterViewController.h"
#import "XMPPFramework.h"
#import "ChatViewController.h"
#import "ProfilViewController.h"

@interface RosterViewController ()

@end

@implementation RosterViewController

@synthesize myTableView;
@synthesize fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"Contacts";
    // Bouton changer info profil
    UIBarButtonItem *monBouton1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeInfoProfil)];
    [self.navigationItem setLeftBarButtonItem:monBouton1];
    // Bouton ajout contact
    UIBarButtonItem *monBouton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    [self.navigationItem setRightBarButtonItem:monBouton];
    [self.navigationItem hidesBackButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeInfoProfil
{
    ProfilViewController *Controller = [[ProfilViewController alloc]initWithNibName:@"ProfilViewController" bundle:nil];
    Controller.chat = self.chat;
    [self.navigationController pushViewController:Controller animated:YES];
}

- (void)addContact
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ajouter un nouveau contact "
                                                    message:[NSString stringWithFormat:@"Entrez l'adresse email SVP:"]
                                                   delegate:self cancelButtonTitle:@"Fermer"
                                          otherButtonTitles:@"Valider", nil];
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self.chat addContactInRoster:[alertView textFieldAtIndex:0].text];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil)
    {
        NSManagedObjectContext *moc = [self.chat managedObjectContext_roster];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        
        NSArray *sortDescriptors = @[sd1, sd2];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:@"sectionNum"
                                                                                  cacheName:nil];
        [fetchedResultsController setDelegate:self];
        
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
            NSLog(@"ERROR ROSTER");
        }
        
    }
    
    return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self myTableView] reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewCell helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
    // Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
    // We only need to ask the avatar module for a photo, if the roster doesn't have it.
    if (user.photo != nil)
    {
        cell.imageView.image = user.photo;
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsController] sections] count];
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
{
    NSArray *sections = [[self fetchedResultsController] sections];
    
    if (sectionIndex < [sections count])
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = sections[sectionIndex];

        int section = [sectionInfo.name intValue];
        switch (section)
        {
            case 0  : return @"Available";
            case 1  : return @"Away";
            default : return @"Offline";
        }
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSArray *sections = [[self fetchedResultsController] sections];
    
    if (sectionIndex < [sections count])
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = sections[sectionIndex];
        return sectionInfo.numberOfObjects;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    //    NSLog(@"%@", user);

    NSMutableDictionary *emptyMessage = [NSMutableDictionary
                                         dictionaryWithDictionary:@{
                                            @"user"    : @"Moi",
                                            @"message" : @""
    }];

    NSMutableArray *messages = [[NSMutableArray alloc] initWithObjects:emptyMessage, nil];
    self.chat.conversations[user.displayName] = messages;
    cell.textLabel.text = user.displayName;
//    NSLog(@"%@, %@", user.jidStr, user.unreadMessages);
    [self configurePhotoForCell:cell user:user];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];

    ChatViewController *chatController = [[ChatViewController alloc] initWithUser:user.displayName];

    chatController.chat = self.chat;

    [self.navigationController pushViewController:chatController animated:YES];
}

@end
