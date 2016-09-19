//
//  DifusionViewController.m
//  PagedAlertController
//
//  Created by Daniel Cardona Rojas on 9/7/16.
//  Copyright © 2016 Daniel Cardona Rojas. All rights reserved.
//

#import "DifusionViewController.h"
#import "SocialPageView.h"


@interface DifusionViewController ()

@property (strong,nonatomic) PagedAlertViewController* pagedAlert;
@end

@implementation DifusionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PagedAlertViewController* pagedAlert = (PagedAlertViewController*)[segue destinationViewController];
    
    [pagedAlert setDelegate:self];
    [pagedAlert setDataSource:self];
    pagedAlert.showsPageBullets = YES;
    [pagedAlert setCloseImage: [UIImage imageNamed:@"close_button.png"]];
    
    self.pagedAlert = pagedAlert;
}


- (IBAction)showPagedAlert:(id)sender {
    
    [self performSegueWithIdentifier:@"toPagedAlert" sender:self];
    
}


#pragma mark - PagedAlertDataSource

//View cell for alert page
-(UIView *)viewForAlertPage:(NSUInteger)index{
    
    
    SocialPageView* social = (SocialPageView*)[[[NSBundle mainBundle] loadNibNamed:@"SocialPageView" owner:self options:nil] firstObject];
    
        
    [social.facebookButton addTarget:self action:@selector(didTapFacebookButton:) forControlEvents:UIControlEventTouchUpInside];
    [social.twitterButton addTarget:self action:@selector(didTapTwitterButton:) forControlEvents:UIControlEventTouchUpInside];
    [social.whatsappButton addTarget:self action:@selector(didTapWhatsappButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(index == 0){
        [social.messageLabel setText:@"Queremos saber que te ha parecido Filapp"];
        [social.facebookButton setHidden:YES];
        [social.twitterButton setHidden:YES];
        [social.whatsappButton setHidden:YES];
    }
    
    if(index == 1){
        [social.messageLabel setText:@"Quieres regalarle Filapp a un amigo o familiar? Enviales un mensaje a traves de uno de los siguientes canales:"];
    }
    
    
    return  social;

}

-(UIView *)updateViewOnPageFlipRejection:(UIView *)view pageIndex:(NSUInteger)index directon:(PagedAlertFlipDirection)direction{
    
    for (UIView *i in view.subviews){
        if([i isKindOfClass:[UILabel class]]){
            UILabel *newLbl = (UILabel *)i;
            if(newLbl.tag == 3){
                [newLbl setText:@"Wrong input"];
            }
        }
    }
    
    return view;
}

-(NSUInteger)numberOfPagesForPagedAlertController:(UIViewController *)pagedController{
    return 2;
}

-(NSString *)titleForPageAtIndex:(NSUInteger)index{
    NSString* title = [NSString stringWithFormat:@"Pagina %lu",(unsigned long)index];
    
    switch (index) {
        case 0:
            title = @"Danos tu opinion";
            break;
        case 1:
            title = @"Cuentale a otros";
            break;
            
        default:
            break;
    }
    
    return title;
}

-(UIColor *)titleColorForPageAtIndex:(NSUInteger)index{
    return [UIColor colorWithRed:(255.f/255.f) green:(120.f/250.f) blue:(31/250.f) alpha:1];
}


-(NSArray *)pagedAlertControllerButtonTitles{
    
    NSArray* array = @[@"No me gusto",@"Si me gusto",@"Anterior",@"Finalizar"];
    
    return array;
}

-(NSArray *)pagedAlertControllerButtonIcons{
    
    UIImage* likeIcon = [UIImage imageNamed:@"like.png"];
    UIImage* dislikeIcon = [UIImage imageNamed:@"dislike.png"];
//    UIImage* nextArrow = [UIImage imageNamed:@"right-arrow.png"];
//    UIImage* previousArrow = [UIImage imageNamed:@"left-arrow.png"];
    
    
    //Resize programmatically
    CGSize destinationSize = CGSizeMake(24, 24);
    
    UIGraphicsBeginImageContext(destinationSize);
    [likeIcon drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newLikeIcon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(destinationSize);
    [dislikeIcon drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newDislikeIcon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    
    
    NSArray* array = @[newDislikeIcon, newLikeIcon];
    
    
    return array;
}

#pragma mark - PagedAlertDelegate

-(void)didDismissPagedAlertControllerAtIndex:(NSUInteger)index{
    
}

-(BOOL)pagedAlert:(UIView*)view rejectsPageFlip:(NSUInteger)index direction:(PagedAlertFlipDirection) direction{
    return NO;
}


-(void)pagedAlert:(UIView *)view didTurnToPageAtIndex:(NSUInteger)pageIndex{
    //
    if([view isKindOfClass:[SocialPageView class]]){
        NSLog(@"did turn to social page");
        
    }
}

-(BOOL)shouldReverseNextButtonLayout:(NSUInteger)index{
    if (index == 1) {
        return YES;
    }
    
    return NO;
}

#pragma mark - UITextFieldDelegate


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString* fullText = [textField.text stringByAppendingString:string];
    NSLog(@"textfield input: %@", fullText);
    
    return YES;
}

#pragma mark - Target Selectors
-(void) didTapFacebookButton:(id)sender{
    [self.pagedAlert dismissViewControllerAnimated:YES completion:^{
        //Present Facebook compose controller
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *facebookComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookComposer setInitialText:@"texto a postear"];
            //TODO: change url depending on language
            [facebookComposer addURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=rosRxrPupF4"]];
            [facebookComposer addImage:[UIImage imageNamed:@"filapp_beta_58.png"]];
            [facebookComposer setCompletionHandler:^(SLComposeViewControllerResult result){
                
                if (result == SLComposeViewControllerResultDone) {
                    //TODO: Count user interaction
                    
                    
                }
                
                
            }];
            //TODO: Since facebook doesnt allow prefilling Present alert if user taps ok yank to UIPasteBoard
            
            [self presentViewController:facebookComposer animated:YES completion:nil];
        }else{
            //Present alert
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Facebook no disponible" message:@"Por favor vaya a Ajustes > Facebok para configurar su cuenta " preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
    
}

-(void)didTapTwitterButton:(id)sender{
    
    [self.pagedAlert dismissViewControllerAnimated:YES completion:^{
        //Present Twitter compose controller
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweetComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetComposer setInitialText:@"texto a postear"];
            //TODO: change url depending on language
            [tweetComposer addURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=rosRxrPupF4"]];
            [tweetComposer addImage:[UIImage imageNamed:@"filapp_beta_58.png"]];
            [tweetComposer setCompletionHandler:^(SLComposeViewControllerResult result){
                
                if (result == SLComposeViewControllerResultDone) {
                    //TODO: Count user interaction
                    
                    
                }
                
                
            }];
            
            [self presentViewController:tweetComposer animated:YES completion:nil];
        }else{
            //Present alert
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Twitter no disponible" message:@"Por favor vaya a Ajustes > Twitter para configurar su cuenta " preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
    
    
    
    
    
}

-(void)didTapWhatsappButton:(id)sender{
    /* 
     Be sure to include WhatsApp URL scheme in your application's Info.plist under LSApplicationQueriesSchemes key 
     if you want to query presence of WhatsApp on user's iPhone using -[UIApplication canOpenURL:].
     */
    [self.pagedAlert dismissViewControllerAnimated:YES completion:^{
    NSString* formattedMessage = [NSString stringWithFormat: @"whatsapp://send?text=%@", @"Descarga whatsapp"];

        
    formattedMessage = [formattedMessage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *whatsappURL = [NSURL URLWithString:formattedMessage];
        
//        NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=Hello%2C%20World!"];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
//        [self sendWhatsAppMedia];
    }else {
        //Present alert
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Whatsapp no disponible" message:@"Ud no tiene whatsapp instalado" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    //Send video

    }];
    
    NSLog(@"tapped whatsapp button");
}


-(void)sendWhatsAppMedia{
    
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
        
        NSString *savePath = [[NSBundle mainBundle] pathForResource:@"filapp_beta_58" ofType:@"png"];
        
        UIDocumentInteractionController* documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        
        documentInteractionController.UTI = @"net.whatsapp.images";
        
        documentInteractionController.delegate = (id)self;
        
        [documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Whatsapp no disponible" message:@"Ud no tiene whatsapp instalado" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



@end
