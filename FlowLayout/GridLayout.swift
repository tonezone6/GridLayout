//
//  Grid2Layout.swift
//  FlowLayout
//
//  Created by Alex on 17/10/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    private var computedContentSize: CGSize = .zero
    private var columns: CGFloat = 1
    private var insets: UIEdgeInsets = .zero
    private var cellAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]
    
    override init() {
        super.init()
    }
    
    convenience init(
        columns: Int,
        insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
        spacing: CGFloat = 8) {
        
        self.init()
        scrollDirection = .vertical
        self.columns = CGFloat(columns)
        self.insets = insets
        sectionInset = insets
        minimumInteritemSpacing = spacing
        minimumLineSpacing = spacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var collectionViewContentSize: CGSize {
        return computedContentSize
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
       
        // clear previous results
        computedContentSize = .zero
        cellAttributes = [:]
        
        let availableW = collectionView.bounds.width - (sectionInset.left + sectionInset.right)
        let itemW = (availableW - minimumInteritemSpacing*(columns - 1))/(columns)
        let itemH = itemW
        var rowsY: CGFloat = 0
        
        for section in 0..<collectionView.numberOfSections {
            let h = section == 0 ? 0 : itemH
            rowsY += sectionInset.top + h
            for index in 0..<collectionView.numberOfItems(inSection: section) {
                // determine the frame of your cell...
                let column = CGFloat(index % Int(columns))
                let x = sectionInset.left + (itemW + minimumInteritemSpacing) * column
                let rect = CGRect(x: x, y: rowsY, width: itemW, height: itemH)
                              
                // move to next line
                if x + itemW > availableW {
                    rowsY += itemH + minimumLineSpacing
                }
              
                // create the layout attributes and set the frame...
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = rect
               
                // store the results...
                cellAttributes[indexPath] = attributes
            }
            // store computed content size
            computedContentSize = CGSize(
                width: collectionView.bounds.width,
                height: rowsY + itemH + sectionInset.bottom
            )
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributeList = [UICollectionViewLayoutAttributes]()
        for (_, attributes) in cellAttributes {
            if attributes.frame.intersects(rect) {
                attributeList.append(attributes)
            }
        }
        return attributeList
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath]
    }
}
