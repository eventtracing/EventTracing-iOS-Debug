//
//  EventTracingInfoListViewLayout.h
//  EventTracingDebug
//
//  Created by Smallfly on 2021/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTracingInfoListViewLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, copy) NSString *backgroundHexColor;
@end

@interface EventTracingInfoListViewLayout : UICollectionViewFlowLayout

- (instancetype)initWithBackgroundColorBlock:(NSString *(^)(NSInteger))colorBlock;

@end

NS_ASSUME_NONNULL_END
