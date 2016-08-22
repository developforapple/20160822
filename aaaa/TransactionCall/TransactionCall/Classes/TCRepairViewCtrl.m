//
//  TCRepairViewCtrl.m
//  TransactionCall
//
//  Created by wwwbbat on 16/8/11.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "TCRepairViewCtrl.h"
#import "TCRepairImagesCell.h"

@interface TCRepairViewCtrl () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSMutableArray *images;
@end

@implementation TCRepairViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.images = [NSMutableArray array];
}

- (IBAction)repair:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Demo" message:@"报修已发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)addPic:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"我的相册" otherButtonTitles:@"照相机", nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker;
    
    if (buttonIndex == 0) {
        //我的相册
        picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
    }else if(buttonIndex == 1){
        //相机
        picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
    }
    
    if (picker) {
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *originImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    [self.images addObject:originImage];
    [self.tableView reloadData];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Demo" message:@"添加了图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    switch (row) {
        case 0:{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepairTextCell"];
            return cell;
            
        }   break;
        case 1:{
        
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCVoiceAttachmentCell"];
            return cell;
            
        }   break;
        case 2:{
            
            TCRepairImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCPicturesAttachmentCell"];
            cell.images = self.images;
            return cell;
            
        }   break;
        case 3:{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCAddAttachmentCell"];
            return cell;
            
        }   break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    CGFloat height = 1.f;
    switch (row) {
        case 0: height = 150.f;break;
        case 1: height = 44.f;break;
        case 2: height = 120.f;break;
        case 3: height = 44.f;break;
        default:
            break;
    }
    return height;
}

@end
