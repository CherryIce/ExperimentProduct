//
//  RPFromTableProtocol.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/12.
//

import UIKit

protocol RPFromTableCellActionDelegate:NSObjectProtocol {
    //事件
    func textfiledDidChangeValue(_ indexPath:IndexPath,cellData:RPFromTableModel)
    //to be contiune ...
}

extension RPFromTableCellActionDelegate {
    func textfiledDidChangeValue(_ indexPath:IndexPath,cellData:RPFromTableModel){}
}

protocol RPFromTableCellDataDelegate:NSObjectProtocol {
    func setCellData(cellData:RPFromTableModel,delegate:RPFromTableCellActionDelegate,indexPath:IndexPath)
}
