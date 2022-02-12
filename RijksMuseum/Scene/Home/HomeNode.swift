//
//  HomeNode.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 12/02/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

final class HomeNode: ASCellNode {
    
    struct Attributes {
        static let placeholderColor: UIColor = UIColor.gray.withAlphaComponent(0.8)
    }
    
    lazy var postNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 320)
        node.clipsToBounds = true
        node.placeholderColor = Attributes.placeholderColor
        node.placeholderEnabled = true
        node.placeholderFadeDuration = 0.3
        node.shouldCacheImage = true
        node.contentMode = .scaleAspectFill
        node.shouldRenderProgressImages = true
        return node
    }()
    
    init(data: ArtObjects) {
        super.init()
        self.backgroundColor = .white
        self.automaticallyManagesSubnodes = true
        self.postNode
            .setURL(URL(string: data.headerImage.url), resetToDefault: false)
    }
}

extension HomeNode {
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentStack = ASStackLayoutSpec(direction: .horizontal,
                                             spacing: 1.0,
                                             justifyContent: .start,
                                             alignItems: .start,
                                             children: [postNode])
        contentStack.style.flexGrow = 1.0
        contentStack.style.flexShrink = 1.0
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 4.0,
                                                      left: 4.0,
                                                      bottom: 4.0,
                                                      right: 4.0),
                                 child: contentStack)
    }
}
