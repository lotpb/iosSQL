//
//  MasterAddressViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/8/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "ContactsViewController.h"


@interface ContactsViewController ()

@property (nonatomic, strong) NSMutableArray *arrContactsData;
//@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (nonatomic, strong) CNContactPickerViewController *addressBookController;
@property (nonatomic, strong) CNContactStore *store;

@end

@implementation ContactsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self displayContacts];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    self.navigationItem.leftBarButtonItem = addButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showdone{
[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) displayContacts {
    NSArray *keys = @[CNContactGivenNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey];
    CNContactPickerViewController *pickerViewController = [[CNContactPickerViewController alloc]init];
    //pickerViewController.delegate = self;
    pickerViewController.displayedPropertyKeys = keys;
    [self presentViewController: pickerViewController animated:YES completion:nil];
}
/*
- (void) getOneContact {
    self.store = [[CNContactStore alloc] init];
    [self.store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
        if (granted) {
            NSError *error;
            NSArray *keys = @[CNContactGivenNameKey];
            
            NSPredicate *predicate = [CNContact predicateForContactsMatchingName:@"Peter"];
            NSArray *contacts = [self.store unifiedContactsMatchingPredicate:nil keysToFetch:keys error:&error];
            NSAssert(contacts, @"%@", error);
            NSLog(@"%ld", (long) [contacts count]);
        }
        else {
            NSLog(@"requestAccessForEntityType error: %@", error);
        }
    }];
} */


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    NSLog (@"Here");
}

#pragma mark - Private method implementation


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrContactsData) {
        return _arrContactsData.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *contactInfoDict = [_arrContactsData objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [contactInfoDict objectForKey:@"firstName"], [contactInfoDict objectForKey:@"lastName"]];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSDictionary *contactDetailsDictionary = [_arrContactsData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        [[segue destinationViewController] setDictContactDetails:contactDetailsDictionary];
    }
}

@end
