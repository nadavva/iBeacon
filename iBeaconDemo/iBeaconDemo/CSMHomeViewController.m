//
//  CSMHomeViewController.m
//  iBeacons_Demo
//
//  Created by Christopher Mann on 9/5/13.
//  Copyright (c) 2013 Christopher Mann. All rights reserved.
//

#import "CSMHomeViewController.h"
#import "CSMLocationUpdateController.h"
#import "CSMAppDelegate.h"

#define kHorizontalPadding 10
#define kVerticalPadding 5

@interface CSMHomeViewController ()

@property (nonatomic, strong) UILabel            *instructionLabel;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITextField *textFieldX;
@property (nonatomic, strong) UITextField *textFieldY;
@property (nonatomic, strong) UITextField *textFieldName;

@end

@implementation CSMHomeViewController

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"iBeacons Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.instructionLabel = [UILabel new];
    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionLabel.preferredMaxLayoutWidth = self.view.frame.size.width - 2*kHorizontalPadding;
    self.instructionLabel.numberOfLines = 0;
    self.instructionLabel.text = @"Select the mode you would like to use for this device:";
    self.instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.instructionLabel];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"iBeacon",@"Region Monitoring"]];
    self.segmentedControl.momentary = YES;
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segmentedControl addTarget:self action:@selector(handleToggle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    //CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.textFieldX = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    self.textFieldX.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldX.font = [UIFont systemFontOfSize:15];
    NSString *tmp = [prefs objectForKey:@"posX"];
    if (tmp){
        tmp = [NSString stringWithFormat:@"X = %@",tmp];
    } else {
        tmp = @"Location X";
    }
    self.textFieldX.placeholder = tmp;
    self.textFieldX.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textFieldX.keyboardType = UIKeyboardTypeDefault;
    self.textFieldX.returnKeyType = UIReturnKeyDone;
    self.textFieldX.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldX.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFieldX.delegate = self;
    [self.view addSubview:self.textFieldX];
    
    self.textFieldY = [[UITextField alloc] initWithFrame:CGRectMake(10, 250, 300, 40)];
    self.textFieldY.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldY.font = [UIFont systemFontOfSize:15];
    tmp = nil;
    tmp = [prefs objectForKey:@"posY"];
    if (tmp){
        tmp = [NSString stringWithFormat:@"Y = %@",tmp];
    } else {
        tmp = @"Location Y";
    }
    self.textFieldY.placeholder = tmp;
    self.textFieldY.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textFieldY.keyboardType = UIKeyboardTypeDefault;
    self.textFieldY.returnKeyType = UIReturnKeyDone;
    self.textFieldY.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldY.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFieldY.delegate = self;
    [self.view addSubview:self.textFieldY];
    
    self.textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(10, 300, 300, 40)];
    self.textFieldName.borderStyle = UITextBorderStyleRoundedRect;
    tmp = nil;
    tmp = [prefs objectForKey:@"iName"];
    if (tmp){
        tmp = [NSString stringWithFormat:@"iName = %@",tmp];
    } else {
        tmp = @"iBeacon Name";
    }
    self.textFieldName.placeholder = tmp;
    self.textFieldName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textFieldName.keyboardType = UIKeyboardTypeDefault;
    self.textFieldName.returnKeyType = UIReturnKeyDone;
    self.textFieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textFieldName.delegate = self;
    [self.view addSubview:self.textFieldName];
    
    
    
    // define auto layout constraints
    NSDictionary *constraintMetrics = @{@"horizontalPadding" : @kHorizontalPadding,
                                       @"verticalPadding" : @(5*kVerticalPadding),
                                        @"verticalSpacing" : @(2*kVerticalPadding)};
    NSDictionary *constraintViews = @{@"label" : self.instructionLabel,
                                       @"segmentedControl" : self.segmentedControl,
                                      @"topGuide" : self.topLayoutGuide};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalPadding-[label]-horizontalPadding-|"
                                                                     options:0
                                                                     metrics:constraintMetrics
                                                                        views:constraintViews]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalPadding-[segmentedControl]-horizontalPadding-|"
                                                                      options:0
                                                                      metrics:constraintMetrics
                                                                        views:constraintViews]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-verticalPadding-[label]-verticalSpacing-[segmentedControl(==40)]-(>=verticalPadding)-|"
                                                                      options:0
                                                                      metrics:constraintMetrics
                                                                        views:constraintViews]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textFieldChanged:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                               object:self.textFieldName];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textFieldChanged:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                               object:self.textFieldX];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textFieldChanged:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                               object:self.textFieldY];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (textField == self.textFieldX) {
        [prefs setObject:textField.text forKey:@"posX"];
    } else if (textField == self.textFieldY) {
        [prefs setObject:textField.text forKey:@"posY"];
    } else if (textField == self.textFieldName) {
        [prefs setObject:textField.text forKey:@"iName"];
    }
    [prefs synchronize];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)handleToggle:(id)sender {
    
    CSMLocationUpdateController *monitoringController;
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        // initiate iBeacon broadcasting mode
        monitoringController = [[CSMLocationUpdateController alloc] initWithLocationMode:CSMApplicationModePeripheral];
        
    } else {
        
        // initate peripheral iBeacon monitoring mode
        monitoringController = [[CSMLocationUpdateController alloc] initWithLocationMode:CSMApplicationModeRegionMonitoring];
    }
    
    // present update controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:monitoringController];
    [self presentViewController:navController animated:YES completion:NULL];
}

@end
