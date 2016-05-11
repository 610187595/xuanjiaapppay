//
//  ViewController.m
//  xuanjiaallpay
//
//  Created by 薛泽军 on 16/4/29.
//  Copyright © 2016年 炫嘉科技. All rights reserved.
//

#import "ViewController.h"
#import "AllPayViewController.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *peicrText;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)payClick:(id)sender
{
    AllPayViewController *avc=[AllPayViewController sharedManager];
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
