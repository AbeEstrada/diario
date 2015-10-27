//
//  ArticleCell.m
//  Diario
//
//  Created by Abraham Estrada on 5/6/14.
//  Copyright (c) 2014 Abraham Estrada. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

@synthesize title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
