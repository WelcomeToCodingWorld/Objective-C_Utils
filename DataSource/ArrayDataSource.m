//
//  ArrayDataSource.h
//  objc.io example project (issue #1)
//data可能是数组(@[models])或字典，dic:{@"key":@[@"key1",@"key2",@"key3"],@"value":@[@[value1s],@[value2s],@[value3s]}

#import "ArrayDataSource.h"

@interface ArrayDataSource ()
@property (nonatomic,retain)id data;
@property (nonatomic, strong)NSArray* items;
@property (nonatomic,retain)NSArray<NSString *> *sectionTitleArr;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic,assign)KSDataType dataType;
@property (nonatomic,copy)CellDeleteBlock cellDeleteBlock;
@property (nonatomic,retain)NSMutableArray<NSNumber*>* sectionOpenTags;
@end

@implementation ArrayDataSource

- (id)init
{
    return nil;
}

- (void)dealloc{
    _configureCellBlock = nil;
}

- (id)initWithData:(id)data dataType:(KSDataType)dataType
     cellIdentifier:(NSString *)aCellIdentifier
configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.sectionOpenTags = @[].mutableCopy;
        self.sectionOpenStyle = SectionOpenStyleNone;
        self.data = data;
        self.dataType = dataType;
        switch (dataType) {
            case KSDataTypeArray:
            {
                self.items = data;
            }
                break;
            case KSDataTypeDictionary:
            {
                self.sectionTitleArr = [data objectForKey:@"key"];
                self.items = [data objectForKey:@"value"];
                
            }
                break;
            default:
                break;
        }
        
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataType == KSDataTypeArray?self.items[(NSUInteger) indexPath.row]:self.items[indexPath.section][indexPath.row];
}


#pragma mark- Public
- (void)open:(BOOL)open section:(NSInteger)sectionIndex{
    if (self.sectionOpenStyle == SectionOpenStyleNone) {
        return;
    }
    if (open) {
        if (self.sectionOpenStyle == SectionOpenStyleSingle){//关闭已经展开的区
            NSNumber* obj = [self.sectionOpenTags filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.boolValue = YES"]].firstObject;
            if (obj) {
                NSInteger idx = [self.sectionOpenTags indexOfObject:obj];
                [self.sectionOpenTags replaceObjectAtIndex:idx withObject:@(NO)];
            }
        }
    }
    self.sectionOpenTags[sectionIndex] = @(open);//展开或关闭当前区
}
#pragma mark -  Setter
- (void)setItems:(NSArray *)items{
    _items = items;
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataType == KSDataTypeDictionary) {
        if (!self.sectionOpenTags.count&&self.needSectionToggle) {
            for (int i = 0; i < self.items.count; i ++) {
                [self.sectionOpenTags addObject:@(NO)];
            }
        }
        return self.items.count;
    }else{
        return  1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataType == KSDataTypeArray) {
        return self.items.count;
    }else{
        if (self.needSectionToggle) {
            return self.sectionOpenTags[section].boolValue?[self.items[section] count]:0;
        }else{
            return [self.items[section] count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    if (self.configureCellBlock) {
        self.configureCellBlock(cell, item,indexPath);
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.customSectionHeader||!self.needSectionTitle) {
        return nil;
    }
    return [self.sectionTitleArr objectAtIndex:section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (!self.needSectionIndex) {
        return nil;
    }
    if (self.dataType == KSDataTypeDictionary) {
        return self.sectionTitleArr;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellDeleteBlock) {
        self.cellDeleteBlock(tableView,indexPath,self.data,[self itemAtIndexPath:indexPath]);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.needCellEditable) {
        return NO;
    }
    return YES;
}

- (void)configureCellDeleteBlock:(CellDeleteBlock)block{
    self.cellDeleteBlock = block;
}
@end
