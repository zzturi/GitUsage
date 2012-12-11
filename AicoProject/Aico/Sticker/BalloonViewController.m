//
//  BalloonViewController.m
//  Aico
//
//  Created by Mike on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BalloonViewController.h"
#import "ReUnManager.h"
#import "MainViewController.h"
#import "WordBalloonViewController.h"

#define kImageViewWidth             300.0
#define kImageViewHeight            360.0
#define kHeight                     54.0
#define kWidth                      10.0
//十二个按钮各自的tag
#define kBalloonButtonTag           16000

@implementation BalloonViewController
@synthesize currentImageView = currentImageView_;
@synthesize sourcePicture = sourcePicture_;
@synthesize cancelBtn = cancelBtn_;
@synthesize confirmBtn = confirmBtn_;
@synthesize scrollView = scrollView_;
@synthesize textField = textField_;
@synthesize label = label_;
@synthesize textFieldBgImageView = textFieldBgImageView_;
@synthesize balloonImageView = balloonImageView_;
@synthesize wordBalloonName = wordBalloonName_;
@synthesize balloonStyle = balloonStyle_;
@synthesize labelFrame = labelFrame_;
@synthesize isNewBalloon = isNewBalloon_;
@synthesize wordBalloonVC = wordBalloonVC_;
@synthesize isFromStickerList = isFromStickerList_;
@synthesize labelFont = labelFont_;
@synthesize fontSize = fontSize_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    self.currentImageView = nil;
    self.sourcePicture = nil;
    self.cancelBtn = nil;
    self.confirmBtn = nil;
    self.scrollView = nil;
    self.textField = nil;
    self.label = nil;
    self.textFieldBgImageView = nil;
    self.balloonImageView = nil;
    self.wordBalloonVC = nil;
    self.labelFont = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification
												  object:nil];
    self.currentImageView = nil;
    self.sourcePicture = nil;
    self.cancelBtn = nil;
    self.confirmBtn = nil;
    self.scrollView = nil;
    self.textField = nil;
    self.label = nil;
    self.textFieldBgImageView = nil;
    self.balloonImageView = nil;
    self.wordBalloonVC = nil;
    self.labelFont = nil;
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgImage.png"]];
    [self.view insertSubview:bgImageView 
                     atIndex:0];
    [bgImageView release];
    
    //添加导航栏
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = @"文字泡泡";
    self.navigationController.navigationBarHidden = NO;
    
    //添加导航栏上取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] 
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(cancelOperation)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
    
    //添加导航栏上确定按钮
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] 
                forState:UIControlStateNormal];
    [confirmBtn addTarget:self 
                   action:@selector(confirmOperation) 
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
    
    //背景图片
    self.sourcePicture = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    float originX;
    float originY;
    float imageViewWidth;
    float imageViewHeight;
    if (self.sourcePicture.size.width/self.sourcePicture.size.height >= kImageViewWidth/kImageViewHeight)
    {
        originX = kWidth;
        imageViewWidth = kImageViewWidth;
        imageViewHeight = kImageViewWidth*self.sourcePicture.size.height/self.sourcePicture.size.width;
        originY = kHeight + (kImageViewHeight - imageViewHeight)/2;
    }
    else
    {
        originY = kHeight;
        imageViewWidth = kImageViewHeight*self.sourcePicture.size.width/self.sourcePicture.size.height;
        imageViewHeight = kImageViewHeight;
        originX = kWidth + (kImageViewWidth - imageViewWidth)/2;
    }
    currentImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(originX, originY, imageViewWidth, imageViewHeight)];
    
    self.currentImageView.image = self.sourcePicture;
    [self.currentImageView setClipsToBounds:YES];
    [self.currentImageView setUserInteractionEnabled:YES];
    //背景如今改为黑色条纹背景，不需要是待处理的图片，注掉
//    [self.view addSubview:self.currentImageView];
    
    //scroll view & 上面供选择的泡泡
    scrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 240, 320, 240)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    scrollView_.contentSize = CGSizeMake(320, 240);
    
    //textfield上方泡泡（同样也是泡泡预览页面待处理的泡泡）的名字规律如下：balloon1.png ,balloon2.png...
    //scrollview上的泡泡的名字规律如下：balloon_Icon1.png ,balloon_Icon2.png....
    for (int i = 0; i < 12; i++)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake((i%4)*80 + 8, (i/4)*80 + 8, 64, 64);
		button.tag = i + kBalloonButtonTag;
		[button addTarget:self 
                   action:@selector(chooseBalloonStyle:) 
         forControlEvents:UIControlEventTouchUpInside];
        NSString *balloonName = @"balloon_Icon";
        balloonName = [balloonName stringByAppendingFormat:@"%d.png",(i+1)];
		[button setBackgroundImage:[UIImage imageNamed:balloonName]
                          forState:UIControlStateNormal];
		[self.scrollView addSubview:button];		
	}
    [self.view addSubview:self.scrollView];
    
    //输入框上面的泡泡
    balloonImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(90, 55, 140, 140)];
    self.balloonImageView.image = [UIImage imageNamed:@"balloon1.png"];
    [self.view addSubview:self.balloonImageView];
    
    //text field
    textFieldBgImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 194, 320, 46)];
    self.textFieldBgImageView.image = [UIImage imageNamed:@"WordBalloonBlackBar.png"];
    //如果不加这句话，uiimageview上的textfield会不起作用,手势等一样
    [self.textFieldBgImageView setUserInteractionEnabled:YES];
    [self.view addSubview:self.textFieldBgImageView];
    
    //设置textfield背景
    UIImageView *tmpImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WordBalloonTextfield.png"]];
    tmpImageView.frame = CGRectMake(10, 7, 300, 31);
    [self.textFieldBgImageView addSubview:tmpImageView];
    
    textField_ = [[UITextField alloc]initWithFrame:CGRectMake(25, 11 , 280, 25)];
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.placeholder = @"ABC";
    [self.textField addTarget:self
                       action:@selector(textFieldDidChanged:)
             forControlEvents:UIControlEventEditingChanged];
    [self.textFieldBgImageView addSubview:textField_];
    
    //文字label
    label_ = [[UILabel alloc]initWithFrame:CGRectMake(23, 50, 92, 53)];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:40.0f];
    self.label.text = @"ABC";
    self.label.textAlignment = UITextAlignmentCenter;
    self.label.numberOfLines = 0;   
    self.label.lineBreakMode = UILineBreakModeCharacterWrap;  
    [self.balloonImageView addSubview:self.label];
    
    
    self.wordBalloonName = @"balloon1.png";
    isNewBalloon_ = YES;
    isFromStickerList_ = YES;
    
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //这么多字体，从大到小挨个尝试
    for (int i = 0; i < 40; i++)
    {
        size[i] = 40 - i;
    }
    {
        fontHeight[0] = 53;
        fontHeight[1] = 53;
        fontHeight[2] = 53;
        fontHeight[3] = 67;
        fontHeight[4] = 53;
        fontHeight[5] = 53;
        fontHeight[6] = 53;
        fontHeight[7] = 79;
        fontHeight[8] = 53;
        fontHeight[9] = 72;
        fontHeight[10] = 91;
        fontHeight[11] = 67;
    }
    {
        fontWidth[0] = 92;
        fontWidth[1] = 92;
        fontWidth[2] = 92;
        fontWidth[3] = 112;
        fontWidth[4] = 92;
        fontWidth[5] = 92;
        fontWidth[6] = 92;
        fontWidth[7] = 118;
        fontWidth[8] = 79;
        fontWidth[9] = 103;
        fontWidth[10] = 83;
        fontWidth[11] = 104;
    }
    labelFont_ = [[UIFont alloc]init];
    stringLength_ = 0;
    fontNumber_ = 0;
    fontSize_ = 40;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 

/**
 * @brief  返回上个页面
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)cancelOperation
{  
    [ReUnManager sharedReUnManager].snapImage = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief  选择泡泡，然后跳到预览页面
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)confirmOperation
{
    if (isNewBalloon_)//如果是新创建的泡泡
    {
        if (isFromStickerList_)//来自装饰列表
        {
            //点击装饰列表后进入此页面
            wordBalloonVC_ = [[WordBalloonViewController alloc]init];
            //这句代码必须放在上面
            [self.navigationController pushViewController:wordBalloonVC_
                                                 animated:YES];
            
            if ([self.wordBalloonVC addWordBalloon])//新建一个泡泡
            {
                CustomBalloonView *customBalloonView = [self.wordBalloonVC.balloonArray lastObject];
                customBalloonView.balloonImageView.image = [UIImage imageNamed:self.wordBalloonName];
                customBalloonView.label.text = self.label.text;
                customBalloonView.label.frame = self.label.frame;
                customBalloonView.label.font = self.label.font;
                customBalloonView.label.textColor = self.label.textColor;
                customBalloonView.balloonStyle = self.balloonStyle;
            }
            isFromStickerList_ = NO;
        }
        else//再加一个泡泡
        {
            if ([self.wordBalloonVC addWordBalloon])//新建一个泡泡
            {
                CustomBalloonView *customBalloonView = [self.wordBalloonVC.balloonArray lastObject];
                customBalloonView.balloonImageView.image = [UIImage imageNamed:self.wordBalloonName];
                customBalloonView.label.text = self.label.text;
                customBalloonView.label.frame = self.label.frame;
                customBalloonView.label.font = self.label.font;
                customBalloonView.label.textColor = self.label.textColor;
                customBalloonView.balloonStyle = self.balloonStyle;
            }
            [self.navigationController pushViewController:wordBalloonVC_ 
                                                 animated:YES];
        }
        [self.wordBalloonVC savePicture];
    }
    else//如果是编辑已存在的泡泡
    {
        NSArray *viewController = self.navigationController.viewControllers;
        WordBalloonViewController *wordBalloonViewController = [viewController objectAtIndex:([viewController count] - 2)];
        CustomBalloonView *customBalloonView = (CustomBalloonView *)[wordBalloonViewController.view viewWithTag:wordBalloonViewController.selectedBalloonTag];
        customBalloonView.label.text = self.label.text;
        customBalloonView.label.frame = self.label.frame;
        customBalloonView.label.font = self.label.font;
        customBalloonView.label.textColor = self.label.textColor;
        customBalloonView.balloonStyle = self.balloonStyle;
        customBalloonView.balloonImageView.image = [UIImage imageNamed:self.wordBalloonName];
        [self.navigationController popToViewController:(WordBalloonViewController *)[viewController objectAtIndex:([viewController count] - 2)] animated:YES];
        
        [wordBalloonViewController savePicture];
    }
}

/**
 * @brief  随着输入删除字符，设置合适的label字体大小
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)setFontSize3
{
    CGSize ctraintSize = CGSizeMake(fontWidth[self.balloonStyle], 1000);
    float tmpFontSize = 40.0;
    {
        tmpFontSize = fontSize_;
        for (; tmpFontSize >= 1.0; tmpFontSize--)
        {
            self.labelFont = [UIFont systemFontOfSize:tmpFontSize];
            CGSize labelSize = [self.label.text sizeWithFont:self.labelFont 
                                           constrainedToSize:ctraintSize 
                                               lineBreakMode:UILineBreakModeCharacterWrap];
            if(labelSize.height <= fontHeight[self.balloonStyle])
            {
                fontSize_ = tmpFontSize;
                if (self.labelFont != nil)
                {
                    self.label.font = self.labelFont;
                }
                return;
            }
        }
    }
}

/**
 * @brief  选择泡泡样式
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)chooseBalloonStyle:(id)sender
{
    NSString *balloonName = @"balloon";
    balloonName = [balloonName stringByAppendingFormat:@"%d.png",([sender tag]-kBalloonButtonTag+1)];
    self.wordBalloonName = balloonName;
    self.balloonImageView.image = [UIImage imageNamed:balloonName];
    self.balloonStyle = [sender tag]-kBalloonButtonTag;
    switch ([sender tag])
    {
        case kBalloonButtonTag:
            self.labelFrame = CGRectMake(23, 50, 92, 53);
            break;
        case kBalloonButtonTag+1:
            self.labelFrame = CGRectMake(24, 59, 92, 53);
            break;
        case kBalloonButtonTag+2:
            self.labelFrame = CGRectMake(24, 54, 92, 53);
            break;
        case kBalloonButtonTag+3:
            self.labelFrame = CGRectMake(14, 43, 112, 67);
            break;
        case kBalloonButtonTag+4:
            self.labelFrame = CGRectMake(24, 23, 92, 53);
            break;
        case kBalloonButtonTag+5:
            self.labelFrame = CGRectMake(24, 18, 92, 53);
            break;
        case kBalloonButtonTag+6:
            self.labelFrame = CGRectMake(24, 43, 92, 53);
            break;
        case kBalloonButtonTag+7:
            self.labelFrame = CGRectMake(12, 26, 118, 79);
            break;
        case kBalloonButtonTag+8:
            self.labelFrame = CGRectMake(30, 48, 79, 53);
            break;
        case kBalloonButtonTag+9:
            self.labelFrame = CGRectMake(19, 34, 103, 72);
            break;
        case kBalloonButtonTag+10:
            self.labelFrame = CGRectMake(28.5, 13, 83, 91);
            break;
        case kBalloonButtonTag+11:
            self.labelFrame = CGRectMake(18, 19, 104, 67);
            break;
        default:
            break;
    }
    self.label.frame = self.labelFrame;
    [self setFontSize3];
}

/**
 * @brief  随着输入删除字符，设置合适的label字体大小
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)setFontSize
{
    CGSize ctraintSize = CGSizeMake(fontWidth[self.balloonStyle], 1000);
    float tmpFontSize = fontSize_;
    float bigFont = fontSize_+1;
    
    if (bigFont == 41.0f)
    {
        tmpFontSize = fontSize_;
        for (int i = 0; tmpFontSize > 1.0f && i < 20; tmpFontSize--,i++)
        {
            self.labelFont = [UIFont systemFontOfSize:tmpFontSize];
            CGSize labelSize = [self.label.text sizeWithFont:self.labelFont 
                                           constrainedToSize:ctraintSize 
                                               lineBreakMode:UILineBreakModeCharacterWrap];
            if(labelSize.height <= fontHeight[self.balloonStyle])
            {
                fontSize_ = tmpFontSize;
                if (self.labelFont != nil)
                {
                    self.label.font = self.labelFont;
                }
                return;
            }
        }
    }
    
    
    self.labelFont = [UIFont systemFontOfSize:bigFont];
    CGSize labelSize = [self.label.text sizeWithFont:self.labelFont 
                                   constrainedToSize:ctraintSize 
                                       lineBreakMode:UILineBreakModeCharacterWrap];
    if (labelSize.height < fontHeight[self.balloonStyle]) //字符串变短
    {
        tmpFontSize = fontSize_;
        for (int i = 0; tmpFontSize <= 40.0f && i < 20; tmpFontSize++,i++)
        {
            self.labelFont = [UIFont systemFontOfSize:tmpFontSize];
            CGSize labelSize = [self.label.text sizeWithFont:self.labelFont 
                                           constrainedToSize:ctraintSize 
                                               lineBreakMode:UILineBreakModeCharacterWrap];
            if(labelSize.height > fontHeight[self.balloonStyle] || tmpFontSize == 40.0f)
            {
                if (tmpFontSize != 40.0f) 
                {
                    tmpFontSize--;
                }
                fontSize_ = tmpFontSize;
                self.labelFont = [UIFont systemFontOfSize:tmpFontSize];
                if (self.labelFont != nil)
                {
                    self.label.font = self.labelFont;
                }
                return;
            }
        }
    }
    else if(labelSize.height > fontHeight[self.balloonStyle])//变长
    {
        tmpFontSize = fontSize_;
        for (int i = 0; tmpFontSize > 1.0f && i < 20; tmpFontSize--,i++)
        {
            self.labelFont = [UIFont systemFontOfSize:tmpFontSize];
            CGSize labelSize = [self.label.text sizeWithFont:self.labelFont 
                                           constrainedToSize:ctraintSize 
                                               lineBreakMode:UILineBreakModeCharacterWrap];
            if(labelSize.height <= fontHeight[self.balloonStyle])
            {
                fontSize_ = tmpFontSize;
                if (self.labelFont != nil)
                {
                    self.label.font = self.labelFont;
                }
                return;
            }
        }
    }
    else
    {
        fontSize_ = bigFont;
        self.labelFont = [UIFont systemFontOfSize:bigFont];
        self.label.font = self.labelFont;
    }
}

/**
 * @brief  随着输入删除字符，设置合适的label字体大小
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)setFontSize2
{
    float tmpFontSize = fontSize_;
    
    CGSize ctraintSize = CGSizeMake(fontWidth[self.balloonStyle], 1000);
    
    for (; tmpFontSize > 1; tmpFontSize--)
    {
        self.labelFont = [UIFont systemFontOfSize:tmpFontSize];
        CGSize labelSize = [self.label.text sizeWithFont:self.labelFont 
                                       constrainedToSize:ctraintSize 
                                           lineBreakMode:UILineBreakModeCharacterWrap];
        if(labelSize.height <= fontHeight[self.balloonStyle])
        {
            fontSize_ = tmpFontSize;
            if (self.labelFont != nil)
            {
                self.label.font = self.labelFont;
            }
            return;
        }
    }
}

/**
 * @brief  当textfield中文字发生变化时，走这个方法,限制最大字数100
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
-(void)textFieldDidChanged:(id)sender
{ 
    UITextField *temp = (UITextField *)sender;
    
	if ([temp.text length] > 100) 
	{	
        if ([temp.text length] != 100)
        {
            temp.text = [temp.text substringToIndex:100];
        }
		
	}
    int before;
    if (textHasChanged_) 
    {
        before = [self.label.text length];
    }
    else
    {
        before = 0;
        textHasChanged_ = YES;
    }
    self.label.text = temp.text;
    int after = [self.label.text length];
    if ([temp.text isEqualToString:@""] || temp.text.length == 0 || [self.label.text isEqualToString:@""])
    {
        self.label.font = [UIFont systemFontOfSize:40.0];
        fontSize_ = 40;
        return;
    }
    if (after - before > 2)
    {
        [self setFontSize2];
    }
    else
    {
        [self setFontSize];
    }
    
}

/**
 * @brief  弹出键盘时，让textfield随之下移
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    float height = keyboardFrame.size.height > keyboardFrame.size.width ? keyboardFrame.size.width:keyboardFrame.size.height;    
    [UIView beginAnimations:@"TextFieldMoveUp" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.textFieldBgImageView.frame = CGRectMake(0, 194 + (240-height), 320, 46);
    [UIView commitAnimations];
}

/**
 * @brief  隐藏键盘时，让textfield随之上移
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardFrame;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:@"TextFieldMoveDown" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.textFieldBgImageView.frame = CGRectMake(0, 194, 320, 46);
    [UIView commitAnimations];
}

/**
 * @brief  //如果点击到键盘外面区域，则隐藏键盘
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

@end
