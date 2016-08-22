//
//  TCServicesViewCtrl.m
//  TransactionCall
//
//  Created by wwwbbat on 16/8/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "TCServicesViewCtrl.h"

@interface TCServicesViewCtrl () <UIAlertViewDelegate>

@end

@implementation TCServicesViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *phone;
    if (indexPath.row == 0) {
        phone = @"10010";
    }else if (indexPath.row == 1){
        phone = @"10086";
    }else if (indexPath.row == 3){
        phone = @"12580";
    }
    if (phone) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"呼叫" message:phone delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *tel = [NSString stringWithFormat:@"tel://%@",alertView.message];
        NSURL *url = [NSURL URLWithString:tel];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
