//
//  UserDetailController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/4/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "UserDetailController.h"

@interface UserDetailController ()
{
    UIImage *pickImage;
    NSData *pictureData;
}
@end

@implementation UserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"User Info", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.usernameField.text = self.username;
    self.emailField.text = self.email;
    self.phoneField.text = self.phone;
    self.createLabel.text = self.create;
    self.userimageView.image = self.userimage;
    self.userimageView.backgroundColor = [UIColor blackColor];
    self.userimageView.userInteractionEnabled = YES;
    self.mainView.backgroundColor = LIGHTGRAYCOLOR;
    self.view.backgroundColor = LIGHTGRAYCOLOR;
    
    UIView* separatorLineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 175, self.mainView.frame.size.width, 0.5)];
    separatorLineTop.backgroundColor = [UIColor darkGrayColor];// you can also put image here
    [self.mainView addSubview:separatorLineTop];
    
    UIView* separatorLineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 370, self.mainView.frame.size.width, 0.5)];
    separatorLineBottom.backgroundColor = [UIColor darkGrayColor];// you can also put image here
    [self.mainView addSubview:separatorLineBottom];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.usernameField setFont:CELL_LIGHTFONT(IPADFONT20)];
        [self.emailField setFont:CELL_LIGHTFONT(IPADFONT20)];
        [self.phoneField setFont:CELL_LIGHTFONT(IPADFONT20)];
        [self.createLabel setFont:CELL_LIGHTFONT(IPADFONT16)];
    } else {
        [self.usernameField setFont:CELL_LIGHTFONT(IPADFONT18)];
        [self.emailField setFont:CELL_LIGHTFONT(IPADFONT18)];
        [self.phoneField setFont:CELL_LIGHTFONT(IPADFONT18)];
        [self.createLabel setFont:CELL_LIGHTFONT(IPADFONT14)];
    }
    
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.phoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.mapView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.mapView.layer.borderWidth = 0.5;
    PFQuery *query = [PFUser query];
    PFObject *user = [query getObjectWithId:self.objectId];
    PFGeoPoint *location = [user objectForKey:@"currentLocation"];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(location.latitude, location.longitude),MKCoordinateSpanMake(0.005, 0.005))];

    [self refreshMap];
    
    [[UITextField appearance] setTintColor:CURSERCOLOR];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = DARKGRAYCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfield
-(IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark - map
- (void)refreshMap {
    
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.usernameField.text];
    [query whereKey:@"currentLocation" nearGeoPoint:geoPoint withinMiles:50.0f];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
     {
         if(error)
         {
             NSLog(@"%@",error);
         }
             MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
             annotation.title = [object objectForKey:@"username"];
             PFGeoPoint *geoPoint= [object objectForKey:@"currentLocation"];
             annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude,geoPoint.longitude);
             
             [self.mapView addAnnotation:annotation];
     }];
}

#pragma mark UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    pickImage = info[UIImagePickerControllerEditedImage];

    [self refreshSolutionView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIImagePickerVideo delegate
- (void) refreshSolutionView {

        [self.userimageView setContentMode:UIViewContentModeScaleToFill];
        self.userimageView.image = pickImage;
        self.userimageView.clipsToBounds = YES; //added
}

#pragma mark - button
-(IBAction)selectPicturePressed:(id)sender {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imgPicker.sourceType];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imgPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark upload
-(IBAction)sendPicture:(id)sender {
    
    //Place the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingSpinner.center = self.userimageView.center;
    [loadingSpinner startAnimating];
    [self.view addSubview:loadingSpinner];
    
    PFFile *file;
    if (pickImage) {
        pictureData = UIImageJPEGRepresentation(self.userimageView.image, 0.9f);
        file = [PFFile fileWithName:@"img" data:pictureData];
    }
   // NSLog(@"Size of Image(bytes):%lu",(unsigned long)[pictureData length]);
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            
            PFUser *user = [PFUser currentUser];
            [user setObject:file forKey:@"imageFile"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    GOBACK;
                } else {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    [self showErrorView:errorString];
                }
            }];
        }
        else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [self showErrorView:errorString];
        }
        
        [loadingSpinner stopAnimating];
        [loadingSpinner removeFromSuperview];
        
    } progressBlock:^(int percentDone) {
       // [self.progressView setProgress:(float)percentDone/100.0f];
    }];
}

#pragma mark update
-(IBAction)Update:(id)sender {
    /*
     *******************************************************************************************
     Parse.com
     *******************************************************************************************
     */
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:self.objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateblog, NSError *error) {
            if (!error) {
                [updateblog setObject:self.usernameField.text forKey:@"username"];
                [updateblog setObject:self.emailField.text forKey:@"email"];
                [updateblog setObject:self.phoneField.text forKey:@"phone"];
                /*
                PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [postACL setPublicReadAccess:YES];
                [postACL setPublicWriteAccess:YES];
                [updateblog setACL:postACL]; */
                
                //[updateblog saveInBackground];
                [updateblog saveEventually];
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Upload Complete" message:@"Successfully updated the data" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         GOHOME;
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Upload Failure" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    //[[self navigationController]popToRootViewControllerAnimated:YES];
}

#pragma mark - Error View
-(void)showErrorView:(NSString *)errorMsg {
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Error" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
