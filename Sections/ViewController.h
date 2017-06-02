//
//  ViewController.h
//  Sections
//
//  Created by Vasilii on 01.06.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(copy, nonatomic) NSDictionary *names;
@property(copy, nonatomic) NSArray *keys;

@end

