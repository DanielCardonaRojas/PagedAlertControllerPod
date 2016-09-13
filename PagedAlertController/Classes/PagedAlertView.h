//
//  PagedAlertView.h
//  PagedAlertController
//
//  Created by Daniel Cardona Rojas on 8/25/16.
//  Copyright © 2016 Daniel Cardona Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface PagedAlertView : UIView

@property (strong,nonatomic) IBOutlet UIButton* nextButton;
@property (strong,nonatomic) IBOutlet UIButton* previousButton;
@property (strong,nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UIView *innerContentView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIView *alertView;


@end
