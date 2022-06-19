#import <UIKit/UIKit.h>

@interface YTCollectionViewCell : UICollectionViewCell
@end

@interface YTSettingsCell : YTCollectionViewCell
@end

@interface YTSettingsSectionItem : NSObject
@property BOOL hasSwitch;
@property BOOL switchVisible;
@property BOOL on;
@property BOOL (^switchBlock)(YTSettingsCell *, BOOL);
@property int settingItemId;
- (instancetype)initWithTitle:(NSString *)title titleDescription:(NSString *)titleDescription;
@end

%hook YTSettingsViewController
- (void)setSectionItems:(NSMutableArray <YTSettingsSectionItem *>*)sectionItems forCategory:(NSInteger)category title:(NSString *)title titleDescription:(NSString *)titleDescription headerHidden:(BOOL)headerHidden {
      	if (category == 1) {
             		NSInteger appropriateIdx = [sectionItems indexOfObjectPassingTest:^BOOL(YTSettingsSectionItem *item, NSUInteger idx, BOOL *stop) {
	                  		return item.settingItemId == 294;
	             	}];
            		if (appropriateIdx != NSNotFound) {
		                    YTSettingsSectionItem *ytOldIconStyle = [[%c(YTSettingsSectionItem) alloc] initWithTitle:@"Change the Icon Material" titleDescription:@"App restart is required."];
		                    ytOldIconStyle.hasSwitch = YES;
                        ytOldIconStyle.switchVisible = YES;
		                  	ytOldIconStyle.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"ytOldIconStyle_enabled"];
		                  	ytOldIconStyle.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
	          	              		[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"ytOldIconStyle_enabled"];
		           	               	return YES;
		                  	};
		                  	[sectionItems insertObject:ytOldIconStyle atIndex:appropriateIdx + 1];
	            	}
       	}
      	%orig;
}
%end

%hook YTSystemIcons
- (void)setHidden:(BOOL)hidden {
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ytOldIconStyle_enabled"])
		hidden = YES;
	%orig;
}
%end
