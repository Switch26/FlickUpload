//
//  UploadNowViewController.m
//  FlickUpload
//
//  Created by Serguei Vinnitskii on 4/16/15.
//  Copyright (c) 2015 Kartoshka. All rights reserved.
//

#import "UploadNowViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PhotoHistoryData.h"


@interface UploadNowViewController () <DBRestClientDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) UIImage *imageToUploadToDropbox;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *ChoosePhoto;
@property (weak, nonatomic) IBOutlet UIButton *UploadPhoto;

@end

@implementation UploadNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    //Check if Dropbox app is already linked
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    //Hide Upload button unitl the image is picked
    if (!self.imageToUploadToDropbox) {
        self.UploadPhoto.hidden = YES;
    }
}

// Take new photo
- (IBAction)takeNewPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

// Choose from Library
- (IBAction)uploadPhoto:(UIButton *)sender {
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.delegate = self;
    mediaUI.allowsEditing = NO;
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    [self presentViewController:mediaUI animated:YES completion:nil];

}

// Delegate method that handles the image from Camera or Media Browser
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageToUse = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    // Assignments of the Image
    self.imageToUploadToDropbox = imageToUse;
    self.imageView.image = imageToUse;
    
    //Bring up Upload button
    if (self.imageToUploadToDropbox) {
        self.UploadPhoto.hidden = NO;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadMediaFile:(UIButton *)sender {
    
    // Generate alert to allow the user to name the file
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"How do you want to name it?"
                                message:@"This name will be used to save file in your Dropbox folder"
                                preferredStyle:UIAlertControllerStyleAlert];
    // Add text field to alert
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    }];
    UITextField *textField = alert.textFields[0];
    
    UIAlertAction *JPG = [UIAlertAction actionWithTitle:@"Save in .jpg" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Convert UIImage object into JPG
        NSData *imageData = UIImageJPEGRepresentation(self.imageToUploadToDropbox, 0.85f); // quality level 85%
        
        // Write a file to the local documents directory & upload to DropBox
        NSString *filename = [NSString stringWithFormat:@"%@.jpg", textField.text];
        [self saveFileAndUploadDropboxUnderName:filename withData:imageData];   
    }];
    
    UIAlertAction *PNG = [UIAlertAction actionWithTitle:@"Save in .png" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Convert UIImage object into PNG
        NSData *imageData = UIImagePNGRepresentation(self.imageToUploadToDropbox);
        
        // Write a file to the local documents directory & upload to DropBox
        NSString *filename = [NSString stringWithFormat:@"%@.png", textField.text];
        [self saveFileAndUploadDropboxUnderName:filename withData:imageData];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Do nothing
    }];
    
    [alert addAction:JPG];
    [alert addAction:PNG];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)saveFileAndUploadDropboxUnderName:(NSString *)name withData:(NSData *)data {

    // Write a file to the local documents directory
    NSString *filename = name;
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [data writeToFile:localPath atomically:YES];
    
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];

}

#pragma mark - Dropbox CORE API Delegates

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    
    // Add successfully uploaded file name to our database
    [[PhotoHistoryData sharedData] addPhoto:metadata.filename];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}


@end
