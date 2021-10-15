//
//  RPPostersViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/15.
//

import UIKit

class RPPostersViewController: RPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "展业海报"
        
        /**
         NSArray * datas = response[@"datas"][@"data"];
         weakSelf.totalCount = [response[@"datas"][@"count"] integerValue];
         if (weakSelf.pageIndex == 1) {
             [weakSelf.dataArray removeAllObjects];
             [weakSelf.dataArray addObjectsFromArray:datas];
             [weakSelf.collectionView reloadData];
         }else{
             NSMutableArray*indexPaths = [[NSMutableArray alloc] init];
             for (NSDictionary * d in datas) {
                 [weakSelf.dataArray addObject:d];
                 //这里要计算对了，因为我是放在model添加数组之后的，所以-1
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataArray.count-1 inSection: 0];
                 //把获取到的indexpath添加到新建的数组中
                 [indexPaths addObject: indexPath];
             }
             if(indexPaths.count > 0) {
                 //把新获取到的cell插入到collectionview中
                 [self.collectionView insertItemsAtIndexPaths:indexPaths];

                 [UIView performWithoutAnimation:^{
                     //刷新新获取到的cell
                     [self.collectionView reloadItemsAtIndexPaths:indexPaths];
                 }];
             }
         }
         */
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
