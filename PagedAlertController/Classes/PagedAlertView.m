//
//  PagedAlertView.m
//  PagedAlertController
//
//  Created by Daniel Cardona Rojas on 8/25/16.
//  Copyright © 2016 Daniel Cardona Rojas. All rights reserved.
//

#import "PagedAlertView.h"

@interface PagedAlertView ()
@property (weak,nonatomic) IBOutlet UIView* innerview;



@end

@implementation PagedAlertView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Initialization code
        [self setup];
        //Prevent bad configuration in storyboard
        [self.innerContentView setAlpha:1];

        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.innerview = [self loadFromNib];
    self.innerview.frame = self.bounds;
    self.innerview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.innerview.layer setCornerRadius:20.0f];
    [self addSubview:self.innerview];
    [self.nextButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [self.previousButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    
    //TODO: Set Constraints, set borders with CALayers, crop button corners
    
    [self.nextButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15.f)];
    [self.previousButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15.f)];
    
    
    
    
    [self.innerContentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.innerContentView.layer setBorderWidth:1.0f];
    [self.innerContentView.layer setContentsRect:CGRectMake(-2, 50, 305, 305)];
    [self.innerview setClipsToBounds:NO];

    
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    blurView.clipsToBounds = YES;
//    blurView.frame = self.innerview.bounds;
//    blurView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor;
//    blurView.layer.borderWidth = 1.0;
//    blurView.layer.cornerRadius = 20.0f;
//    [blurView.contentView addSubview:self.innerview];
//    [self insertSubview:blurView atIndex:0];
//    
    
}
-(UIView*)loadFromNib{
    
//    NSBundle* podBunble = [NSBundle bundleForClass:[self classForCoder]];
//    NSURL* bundleURL = [podBunble URLForResource:@"PodBundle" withExtension:@"bundle"];
//    
//    if (podBunble) {
//        NSBundle* bundle = [NSBundle bundleWithURL:bundleURL];
//        if (bundle) {
//            UINib* nib = [UINib nibWithNibName:@"PagedAlertView" bundle:bundle];
//            UIView* pagedAlertView = [[nib instantiateWithOwner:self options:nil] firstObject];
//            
//            return pagedAlertView;
//        }
//    }
    
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    UINib* nib = [UINib nibWithNibName:@"PagedAlertView" bundle:bundle];
    UIView* view = [[nib instantiateWithOwner:self options:nil] firstObject];
    return view;
}



@end
