//
//  ArrayDataSource.h
//  objc.io example project (issue #1)
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,KSDataType) {
    KSDataTypeArray,
    KSDataTypeDictionary
};


/**
 刷新表示cell的回调

 @param cell 当前刷新的cell
 @param item cell绑定的模型
 */
typedef void (^TableViewCellConfigureBlock)(id cell, id item,NSIndexPath* indexPath);

/**
 删除Cell的回调

 @param table     cell所在表
 @param indexPath cell的索引路径
 @param data      数据源
 @param model     cell绑定的模型
 */
typedef void (^CellDeleteBlock)(UITableView* table,NSIndexPath* indexPath,id data,id model);

typedef NS_ENUM(NSInteger,SectionOpenStyle){
    SectionOpenStyleNone = -1,
    SectionOpenStyleSingle = 0,
    SectionOpenStyleMultiple = 1
};


@interface ArrayDataSource : NSObject <UITableViewDataSource>


/**
 //是否自定义区头
 */
@property (nonatomic,assign)BOOL customSectionHeader;

/**
 //是否需要区索引
 */
@property (nonatomic,assign)BOOL needSectionIndex;

/**
 //是否需要编辑Cell
 */
@property (nonatomic,assign)BOOL needCellEditable;

/**
 //是否要区头标题
 */
@property (nonatomic,assign)BOOL needSectionTitle;

/**
 //是否需要区打开的处理
 */
@property (nonatomic,assign)BOOL needSectionToggle;
@property (nonatomic,assign)SectionOpenStyle sectionOpenStyle;


/**
 展开某一区
 @description 调用完该方法要reloadSections或reloadData;
 @param sectionIndex 区索引
 */
- (void)open:(BOOL)open section:(NSInteger)sectionIndex;

- (id)initWithData:(id)data dataType:(KSDataType)dataType
     cellIdentifier:(NSString *)aCellIdentifier
configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (void)configureCellDeleteBlock:(CellDeleteBlock)block;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
@end
