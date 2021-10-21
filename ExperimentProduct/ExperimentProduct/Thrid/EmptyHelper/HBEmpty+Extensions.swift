//
//  HBEmpty+Extensions.swift
//  EmptyKit-Demo
//
//  Created by hubin on 2021/10/21.
//  Copyright © 2021 archerzz. All rights reserved.
//

import Foundation
import UIKit

/// Keys
private var delegateKey: Void?
private var emptyViewKey: Void?
private var addFooerKey: Void?

// MARK: - Common methods
fileprivate extension UIScrollView {
    
    static func swizzle(originalSelector: Selector, to swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }
    }
    /**
     reload emtpy view
     
     - author: archerzz
     - date: 2016-11-22
     */
    @objc func ept_reloadData() {
        guard hb_ept.setupEmptyView(withItemsCount: hb_ept.itemsCount) else {
            return
        }
    }
}

// MARK: - UITableView Swizzle
extension UITableView {
    
    static let swizzleIfNeeded: () = {
        UITableView.swizzle(originalSelector: #selector(reloadData), to: #selector(swizzle_reloadData))
        UITableView.swizzle(originalSelector: #selector(endUpdates), to: #selector(swizzle_endUpdates))
    }()
    
    @objc fileprivate func swizzle_reloadData() {
        swizzle_reloadData()
        ept_reloadData()
    }
  
    @objc fileprivate func swizzle_endUpdates() {
        swizzle_endUpdates()
        ept_reloadData()
    }
    
}

// MARK: - UICollectionView Swizzle
extension UICollectionView {
    
    static let swizzleIfNeeded: () = {
        UICollectionView.swizzle(originalSelector: #selector(reloadData), to: #selector(swizzle_reloadData))
    }()
    
    @objc fileprivate func swizzle_reloadData() {
        swizzle_reloadData()
        ept_reloadData()
    }
    
}

// MARK: - Base: UIScrollView Computed Properties
public extension HBEmpty where Base: UIScrollView {
    
    weak var delegate: HBEmptyDelegate? {
        get {
            return objc_getAssociatedObject(base, &delegateKey) as? HBEmptyDelegate
        }
        set {
            UITableView.swizzleIfNeeded
            UICollectionView.swizzleIfNeeded
            objc_setAssociatedObject(base, &delegateKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    fileprivate var isAddFooter: Bool? {
        get {
            return objc_getAssociatedObject(base, &addFooerKey) as? Bool
        }
        set {
            objc_setAssociatedObject(base, &addFooerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var emptyView: UIView? {
        get {
            if let view = objc_getAssociatedObject(base, &emptyViewKey) as? UIView {
                return view
            }
            let view = UIView()
            view.isHidden = true
            objc_setAssociatedObject(base, &emptyViewKey, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
        set {
            objc_setAssociatedObject(base, &emptyViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var itemsCount: Int {
        if let tableView = base as? UITableView, let dataSource = tableView.dataSource {
            let sections = dataSource.numberOfSections?(in: tableView) ?? 1
            return itemsCount(in: sections, with: { (section) -> Int in
                return dataSource.tableView(tableView, numberOfRowsInSection: section)
            })
        }
        if let collectionView = base as? UICollectionView, let dataSource = collectionView.dataSource {
            let sections = dataSource.numberOfSections?(in: collectionView) ?? 1
            return itemsCount(in: sections, with: { (section) -> Int in
                return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            })
        }
        return 0
    }
    
}

// MARK: - Base: UIScrollView Funcs
public extension HBEmpty where Base: UIScrollView {
    
    func reloadData() {
        base.ept_reloadData()
    }
    
    fileprivate func itemsCount(in sections: Int, with transform: (Int) -> Int) -> Int {
        var items = 0
        for sectionIndex in 0..<sections {
            items += transform(sectionIndex)
        }
        return items
    }
    
    fileprivate func clearEmptyView() {
        if self.isAddFooter == true {
            if let tableView = base as? UITableView {
                let footer = tableView.tableFooterView
                var frame = footer?.frame
                if (frame?.size.height ?? 0 == self.emptyView?.frame.size.height) {
                    footer?.frame = CGRect.zero
                }else{
                    frame?.origin.y = 0
                    frame?.size.height -= (self.emptyView?.frame.size.height)!
                    footer?.frame = frame!
                }
                tableView.tableFooterView = footer
                self.isAddFooter = false
            }
        }
        self.emptyView?.removeFromSuperview()
        self.emptyView = nil
    }
  
    fileprivate func setupEmptyView(withItemsCount itemsCount: Int) -> Bool {
        
        guard let delegate = delegate, itemsCount == 0 else {
            clearEmptyView()
            return false
        }
       
        if let customView = delegate.customViewForEmpty() {
            if self.isAddFooter == true {
                clearEmptyView()
            }
            self.emptyView = customView
            let frame = self.emptyView?.frame
            if let tableView = base as? UITableView {
                if tableView.tableHeaderView != nil {
                    self.isAddFooter = true
                    if tableView.tableFooterView != nil {
                        let footer = tableView.tableFooterView
                        let newFooter = UIView.init()
                        newFooter.frame = CGRect.init(x: 0,
                                                      y: 0,
                                                      width:footer?.frame.size.width ?? 0,
                                                      height:(frame?.size.height ?? 0) + (footer?.frame.size.height ?? 0))
                        newFooter.backgroundColor = footer?.backgroundColor
                        newFooter.addSubview(self.emptyView ?? UIView.init())
                        newFooter.addSubview(footer ?? UIView.init())
                        footer?.frame = CGRect.init(x: footer?.frame.minX ?? 0,
                                                    y: newFooter.frame.size.height - (footer?.frame.size.height ?? 0),
                                                    width: footer?.frame.size.width ?? 0,
                                                    height: footer?.frame.size.height ?? 0)
                        
                        tableView.tableFooterView = newFooter
                    }else{
                        tableView.tableFooterView = self.emptyView
                    }
                }else{
                    if tableView.tableFooterView != nil {
                        self.isAddFooter = true
                        let footer = tableView.tableFooterView
                        let newFooter = UIView.init()
                        newFooter.frame = CGRect.init(x: 0,
                                                      y: 0,
                                                      width:footer?.frame.size.width ?? 0,
                                                      height:(frame?.size.height ?? 0) + (footer?.frame.size.height ?? 0))
                        newFooter.backgroundColor = footer?.backgroundColor
                        newFooter.addSubview(self.emptyView ?? UIView.init())
                        newFooter.addSubview(footer ?? UIView.init())
                        footer?.frame = CGRect.init(x: footer?.frame.minX ?? 0,
                                                    y: newFooter.frame.size.height - (footer?.frame.size.height ?? 0),
                                                    width: footer?.frame.size.width ?? 0,
                                                    height: footer?.frame.size.height ?? 0)
                        
                        tableView.tableFooterView = newFooter
                    }else{
                        base.addSubview(self.emptyView ?? UIView.init())
                    }
                }
            }else{
                base.addSubview(self.emptyView ?? UIView.init())
            }
        }
        return true
    }
    
}
