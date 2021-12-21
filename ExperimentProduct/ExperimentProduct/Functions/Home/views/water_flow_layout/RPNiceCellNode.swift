//
//  RPNiceCellNode.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/17.
//

import UIKit
import AsyncDisplayKit

class RPNiceCellNode: ASCellNode {
    
    var rate = 1.0
    
    let photoImageNode: ASNetworkImageNode = {
        let imageNode = ASNetworkImageNode()
        imageNode.contentMode = .scaleAspectFill
        var cornerRadius: CGFloat = 4
        // Use the screen scale for corner radius to respect content scale
        var screenScale: CGFloat = UIScreen.main.scale
        imageNode.willDisplayNodeContentWithRenderingContext = { context, drawParameters in
            var bounds: CGRect = context.boundingBoxOfClipPath
            var radius: CGFloat = cornerRadius * screenScale
            var overlay = UIImage.as_resizableRoundedImage(withCornerRadius: radius,
                                                           cornerColor: .clear,
                                                           fill: .clear,
                                                           borderColor:nil,
                                                           borderWidth:0.0,
                                                           roundedCorners:[.topLeft,.topRight],
                                                           scale:0.0,
                                                           traitCollection: ASPrimitiveTraitCollectionMakeDefault())
            overlay.draw(in: bounds)
            UIBezierPath(roundedRect: bounds, byRoundingCorners:[.topLeft,.topRight] , cornerRadii: CGSize(width: radius, height: radius)).addClip()
//            UIBezierPath(roundedRect: bounds, cornerRadius: radius).addClip()
        }
        return imageNode
    }()
    
    let contentNode:ASTextNode = {
        let textNode = ASTextNode()
        textNode.maximumNumberOfLines = 2
        return textNode
    }()
    
    let userInfoNode:ASButtonNode = {
        let y = ASButtonNode()
        y.contentMode = .scaleToFill
        y.contentHorizontalAlignment = .left
        y.contentSpacing = 3
        y.imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        return y
    }()
    
    let likeNode:ASButtonNode = {
        let likeNode = ASButtonNode()
        likeNode.contentMode = .scaleToFill
        likeNode.contentHorizontalAlignment = .right
        likeNode.contentVerticalAlignment = .center
        likeNode.imageAlignment = .end
        likeNode.contentSpacing = 3
        likeNode.imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        return likeNode
    }()
    
    init(model: RPFollowModel) {
        super.init()
        self.backgroundColor = .white
        automaticallyManagesSubnodes = true
        
        /**
         为了图片缓存的统一管理 需要对RPImageView进行修改才行
         */
        photoImageNode.url = URL(string:model.cover.url)
        
        contentNode.attributedText = NSAttributedString(string: model.title, attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor:UIColor.black]
        
        userInfoNode.imageNode.image = RPImage.UserAvatarImage// photoImageNode.image
        userInfoNode.titleNode.attributedText = NSAttributedString(string: model.author.name, attributes:attrs)
        
        likeNode.setImage(UIImage.loadImage("likes"), for: .normal)
        likeNode.titleNode.attributedText = NSAttributedString(string: String(model.likes), attributes:attrs)
        
        rate = model.cover.width/model.cover.height
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        //绘制区域
        //垂直从上到下依次是 封面 文本
        //然后横向是从左至右 头像-昵称 点赞
        
        //垂直
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.style.flexShrink = 1.0
        verticalStack.style.flexGrow = 1.0
        
        //封面
        photoImageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.width/rate)
        
        //头像
        userInfoNode.imageNode.style.preferredSize = CGSize(width: 20, height: 20)
        userInfoNode.style.spacingBefore = 10
        userInfoNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 100, height: 20)
        
        //点赞
        likeNode.imageNode.style.preferredSize = CGSize(width: 20, height: 20)
        likeNode.style.preferredSize = CGSize(width: 80, height: 20)
        likeNode.style.spacingAfter = 10
        
        //横向
        let bottomLayout = ASStackLayoutSpec.horizontal()
        bottomLayout.justifyContent = .spaceBetween
        bottomLayout.alignItems = .start
        bottomLayout.children = [userInfoNode, likeNode]
        bottomLayout.style.spacingAfter = 10.0
        
        if contentNode.attributedText != nil {
            let contentLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left:10, bottom: 10, right: 10), child: contentNode)
            verticalStack.children = [photoImageNode, contentLayout,bottomLayout]
        } else {
            verticalStack.children = [photoImageNode,bottomLayout]
        }
        
        return verticalStack
    }
}
