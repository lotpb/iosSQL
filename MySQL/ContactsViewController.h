//
//  MasterAddressViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/8/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
//#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContactsDetailController.h"

@interface ContactsViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate>

@end