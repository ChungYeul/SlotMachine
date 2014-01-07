//
//  ViewController.m
//  SlotMachine
//
//  Created by In Chung Yeul on 2014. 1. 7..
//  Copyright (c) 2014년 In Chung Yeul. All rights reserved.
//

#import "ViewController.h"
#define MAX_NUM 100
#define COMPONENT_COUNT 3

@interface ViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UIButton *btnBetting;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UITextField *txtBetting;

@end

@implementation ViewController {
    int _money;
    int _bettingMoney;
}

// 모든 서브뷰를 찾아서 최초 응답 객체를 반환
- (UITextField *)firstResponderTextField {
    for (id child in self.view.subviews) {
        if ([child isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)child;
            if (textField.isFirstResponder) {
                return textField;
            }
        }
    }
    return nil;
}

// 금액 갱신
- (void) refreshMoney {
    self.lblMoney.text = [NSString stringWithFormat:@"%d", _money];
}

// 게임 시작
- (void) gameStart {
    int randomNum[COMPONENT_COUNT];
    int resultNum[COMPONENT_COUNT];
    NSString *msg;
    for (int i = 0; i < COMPONENT_COUNT; i++) {
        randomNum[i] = arc4random() % MAX_NUM;
        [self.picker selectRow:randomNum[i] inComponent:i animated:YES];
        resultNum[i] = randomNum[i] % 10;
    }
    
    if (resultNum[0] == resultNum[1] &&
        resultNum[0] == resultNum[2]) {
        _bettingMoney *= 100;
        msg = @"축! 3개 당첨!!";
    }
    else if (resultNum[0] == resultNum[1] ||
             resultNum[1] == resultNum[2] ||
             resultNum[2] == resultNum[0]) {
        _bettingMoney *= 10;
        msg = @"2개 당첨!";
    }
    else {
        _bettingMoney = 0;
        msg = @"꽝! 다음 기회에..";
    }
    _money += _bettingMoney;
    
    //
    self.lblResult.text = msg;
    [self refreshMoney];
    self.btnBetting.enabled = YES;
    self.btnStart.enabled = NO;
    self.txtBetting.text = @"";
}
- (IBAction)startBtnClick:(id)sender {
    [self gameStart];
}
- (IBAction)bettingBtnClick:(id)sender {
    _bettingMoney = [self.txtBetting.text intValue];
    _money = _money - _bettingMoney;
    
    [[self firstResponderTextField] resignFirstResponder];
    [self refreshMoney];
    self.btnStart.enabled = YES;
    self.btnBetting.enabled = NO;
    
}
- (IBAction)dissmissKeyboard:(id)sender {
    [[self firstResponderTextField] resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _money = 10000;
    [self refreshMoney];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Picker관련 Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return COMPONENT_COUNT;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return MAX_NUM;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *imagePath = [NSString stringWithFormat:@"image%d.png", (int)row % 10];
    UIImage *image = [UIImage imageNamed:imagePath];
    UIImageView *imageView;
    if (nil == view) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 50, 50);
    }
    else {
        imageView = (UIImageView *)view;
        imageView.image = image;
    }
    return imageView;
}

// TextField관련 Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
