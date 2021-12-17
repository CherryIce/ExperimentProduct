//
//  RPNiceCellNode.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/17.
//

import UIKit
import AsyncDisplayKit

class RPNiceCellNode: ASCellNode {
    
    let avatarImageNode: ASNetworkImageNode = {
        let imageNode = ASNetworkImageNode()
        imageNode.contentMode = .scaleAspectFill
        imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        return imageNode
    }()
    
    let photoImageNode: ASNetworkImageNode = {
        let imageNode = ASNetworkImageNode()
        imageNode.contentMode = .scaleAspectFill
        return imageNode
    }()
    
    init(model: RPFollowModel) {
        super.init()
        automaticallyManagesSubnodes = true
        
        /**
        为了图片缓存的统一管理 需要对RPImageView进行修改才行
         */
        avatarImageNode.url = URL(string:model.author.image)
        photoImageNode.url = URL(string:model.cover.url)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        //一个区域 一个Stack<横向的/纵向的>:包含当前区域里面的Children
        
        var headerChildren: [ASLayoutElement] = []
        let headerStack = ASStackLayoutSpec.horizontal()
        headerStack.alignItems = .center
        avatarImageNode.style.preferredSize = CGSize(width: 30, height: 30)
        headerChildren.append(ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10), child: avatarImageNode))
        headerStack.children = headerChildren
        
        let verticalStack = ASStackLayoutSpec.vertical()
        
        verticalStack.children = [
            ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), child: headerStack),
            ASRatioLayoutSpec(ratio: 1.0, child: photoImageNode),
        ]
        
        return verticalStack
    }
}
