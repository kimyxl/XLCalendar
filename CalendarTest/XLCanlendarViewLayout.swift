//
//  XLCanlendarLayout.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/3/11.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

class XLCanlendarViewLayout: UICollectionViewLayout {
    
    var itemWidth:CGFloat = 0
    let numbersInRow:Int = 7
    private var itemHeight:CGFloat = 0
    private var headerReferenceSize = CGSize.init(width: 0, height: 0)
    private var allAttributes = [UICollectionViewLayoutAttributes]()
    private var maxY:CGFloat = 0
    
    override func prepare() {
        super.prepare()
        self.itemWidth = CGFloat(floorf(Float(self.collectionView!.bounds.width/CGFloat(self.numbersInRow))))
        self.itemHeight = self.itemWidth
        self.headerReferenceSize = CGSize.init(width: self.itemWidth*CGFloat(self.numbersInRow), height: 35)
        self.maxY = 0
        let sectionCounts = self.collectionView!.numberOfSections
        
        for j in 0..<sectionCounts {
            let itemCounts = self.collectionView!.numberOfItems(inSection: j)
            
            let headerAttr = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath.init(item: 0, section: j))
            self.allAttributes.append(headerAttr!)
            
            for i in 0..<itemCounts {
                let indexpath = IndexPath.init(item: i, section: j)
                let attr = self.layoutAttributesForItem(at: indexpath)
                self.allAttributes.append(attr!)
                
            }
        }
        let leftMargin = (self.collectionView!.bounds.width-self.itemWidth*CGFloat(self.numbersInRow))/2.0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "XLCanlendarViewLayoutCalculateItemWidthDone"), object: ["leftMargin":leftMargin])
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        let leftMargin = (self.collectionView!.bounds.width-self.itemWidth*CGFloat(self.numbersInRow))/2.0
        let originX = leftMargin + CGFloat(indexPath.item%self.numbersInRow)*self.itemWidth
        let originY = self.maxY
        
        attr.frame = CGRect.init(x: originX, y: originY, width: self.itemWidth, height: self.itemHeight)
        if isLastItemInRow(indexPath) {
            self.maxY = attr.frame.maxY
        }
        return attr
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == UICollectionView.elementKindSectionHeader else {return nil}
        let attr = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
        let leftMargin = (self.collectionView!.bounds.width-self.itemWidth*CGFloat(self.numbersInRow))/2.0
        
        let originY = self.maxY
        
        attr.frame = CGRect.init(x: leftMargin, y: originY, width: self.headerReferenceSize.width, height: self.headerReferenceSize.height)
        self.maxY = attr.frame.maxY
        return attr
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            var height:CGFloat = 0
            let sectionCounts = self.collectionView!.numberOfSections
            for j in 0..<sectionCounts {
                let indexPath = IndexPath.init(item: 0, section: j)
                height += sectionHeight(indexPath)
            }
            return CGSize.init(width: self.collectionView!.bounds.width, height: height)
        }
    }
    
    private func sectionHeight(_ indexpath:IndexPath) -> CGFloat {
        let rows = self.numberOfRowsInSection(indexpath)
        return self.itemHeight*CGFloat(rows) + self.headerReferenceSize.height
    }
    
    private func numberOfRowsInSection(_ indexpath:IndexPath) -> Int {
        let itemsCount = self.collectionView!.numberOfItems(inSection: indexpath.section)
        let rows = itemsCount / self.numbersInRow
        return rows
    }
    private func isLastItemInRow(_ indexpath:IndexPath) -> Bool {
        let item = indexpath.item%self.numbersInRow
        if item == self.numbersInRow-1 {
            return true
        } else {
            return false
        }
    }
    
}
