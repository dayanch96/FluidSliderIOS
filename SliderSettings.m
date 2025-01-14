#import "SliderSettings.h"

#define TAG_FOR_INDEX_PATH(section, row) ((section << 16) | (row & 0xFFFF))
#define SECTION_FROM_TAG(tag) (tag >> 16)
#define ROW_FROM_TAG(tag) (tag & 0xFFFF)

@implementation SliderSettings
{
    NSArray *_sections;
    NSArray *_tintSlider;
    NSArray *_visualEffectSlider;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {

    self = [super initWithStyle:UITableViewStyleInsetGrouped];

    if (self) {
        _tintSlider = @[
            @{@"type": @"slider", @"prefersVE": @NO, @"min": @0, @"max": @100, @"key": @"tintSlider", @"id": @"tsCell"}
        ];

        _visualEffectSlider = @[
            @{@"type": @"slider", @"prefersVE": @YES, @"min": @0, @"max": @100, @"key": @"veSlider", @"id": @"vesCell"}
        ];

        _sections = @[_tintSlider, _visualEffectSlider];
    }

    return self;
}

- (void)loadView {
    [super loadView];

    self.view.tintColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:0/255.0 alpha:255/255.0];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == [_sections indexOfObject:_tintSlider]) {
        return @"Slider with tint color";
    }

    if (section == [_sections indexOfObject:_visualEffectSlider]) {
        return @"Slider with visual effect";
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    if (_sections[indexPath.section]) {
        NSDictionary *data = _sections[indexPath.section][indexPath.row];

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:data[@"id"]];

        if ([data[@"type"] isEqualToString:@"slider"]) {
            _UISliderFluidConfiguration *configuration = [[_UISliderFluidConfiguration alloc] init];
            configuration.stretchLimit = 10;
            configuration.expansionFactor = 2;
            
            if ([data[@"prefersVE"] boolValue]) {
                configuration.minimumTrackBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
                configuration.maximumTrackBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThickMaterial];
            }

            UISlider *slider = [self sliderWithKey:data[@"key"] min:[data[@"min"] floatValue] max:[data[@"max"] floatValue] configuration:configuration];

            slider.tag = TAG_FOR_INDEX_PATH(indexPath.section, indexPath.row);

            [cell.contentView addSubview:slider];

            [slider.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:20.0].active = YES;
            [slider.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-20.0].active = YES;
            [slider.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor].active = YES;
        }

        return cell;
    }

    return cell;
}

- (UISlider *)sliderWithKey:(NSString *)key min:(CGFloat)min max:(CGFloat)max configuration:(_UISliderFluidConfiguration *)configuration {
    UISlider *slider = [[UISlider alloc] init];
    slider._sliderStyle = 110; //https://x.com/sebjvidal/status/1878372898068369544
    slider.sliderConfiguration = configuration;
    slider.minimumValue = min;
    slider.maximumValue = max;
    slider.minimumValueImage = [UIImage systemImageNamed:@"sun.min"];
    slider.maximumValueImage = [UIImage systemImageNamed:@"sun.max"];
    slider.value = [[NSUserDefaults standardUserDefaults] floatForKey:key];
    slider.translatesAutoresizingMaskIntoConstraints = NO;

    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    return slider;
}

- (void)sliderValueChanged:(UISlider *)sender {
    NSInteger tag = sender.tag;
    NSInteger section = SECTION_FROM_TAG(tag);
    NSInteger row = ROW_FROM_TAG(tag);

    NSDictionary *data = _sections[section][row];

    if (data) {
        [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:data[@"key"]];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
