//
//  FilePreviewVC.m
//  barcode_scan
//
//  Created by wenjunhuang on 2018/9/6.
//
#import "WebKit/WebKit.h"
#import "FilePreviewVC.h"

@interface FilePreviewVC ()
@property (nonatomic, strong) WKWebView *myWebView;
@end

@implementation FilePreviewVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setNeedsStatusBarAppearanceUpdate];
    self.modalPresentationStyle=UIModalPresentationFullScreen;
 // UIImage *backIcon = [UIImage imageWithContentsOfFile:self.backImgPath];
  UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 10, 20)];
    [backBtn setTitle: @"返回" forState: UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setTextColor:[UIColor blackColor]];
  //[backBtn setImage:backIcon forState:UIControlStateNormal];
  [backBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
  self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.selectionGranularity = WKSelectionGranularityDynamic;
    configuration.allowsInlineMediaPlayback = YES;
    
    WKPreferences *preferences = [WKPreferences new];
    //是否支持JavaScript
    preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    self.myWebView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:configuration];
  [self.view addSubview:self.myWebView];
}



- (void)viewWillAppear:(BOOL)animated {
  //NSURL *filePath = [NSURL URLWithString:self.url];
  NSURL *filePath = [NSURL fileURLWithPath:self.url];
  NSURLRequest *request = [NSURLRequest requestWithURL: filePath];
  [self.myWebView loadRequest:request];
}

- (void)close {
  [self dismissViewControllerAnimated:true completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  if (@available(iOS 13.0, *)) {
    return UIStatusBarStyleDarkContent;
  } else {
    return UIStatusBarStyleDefault;
  }
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
  UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
  
  if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
    statusBar.backgroundColor = color;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
