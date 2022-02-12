//
//  HomeDetailController.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 13/02/22.
//

import Foundation
import AsyncDisplayKit

final class HomeDetailController: ASDKViewController<ASDisplayNode> {
    
    private var viewModel: HomeDetailViewModel!
    private lazy var imageNode: ASNetworkImageNode = {
       let node = ASNetworkImageNode()
        node.style.preferredSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
        node.clipsToBounds = true
        node.placeholderColor = Attributes.placeholderColor
        node.placeholderEnabled = true
        node.placeholderFadeDuration = 0.3
        node.contentMode = .scaleAspectFill
        node.shouldRenderProgressImages = true
        return node
    }()
    
    private lazy var textNode: ASTextNode = {
       let node = ASTextNode()
        return node
    }()
    
    init(viewModel: HomeDetailViewModel) {
        super.init(node: ASDisplayNode())
        self.viewModel = viewModel
        self.node.automaticallyManagesSubnodes = true
        
        // Initialize
        
        self.node.layoutSpecBlock = { _, _ in
            let mainStack = ASStackLayoutSpec(direction: .vertical, spacing: 5.0, justifyContent: .center, alignItems: .center, children: [self.imageNode, self.textNode])
            return mainStack
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
