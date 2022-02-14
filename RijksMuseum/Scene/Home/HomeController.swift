//
//  HomeController.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 12/02/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import UIKit

final class HomeController: ASDKViewController<ASCollectionNode> {
    // Context
    private var context: ASBatchContext?
    // viewModel
    private var viewModel: HomeViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    let layoutInspector = MosaicCollectionViewLayoutInspector()
    var barItem: UIBarButtonItem = UIBarButtonItem()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        let layout = MosaicCollectionViewLayout()
        layout.numberOfColumns = 2
        layout.columnSpacing = 10
        let collectionNode = ASCollectionNode(frame: .zero, collectionViewLayout: layout)
        super.init(node: collectionNode)
        layout.delegate = self
        collectionNode.automaticallyManagesSubnodes = true
        collectionNode.layoutInspector = layoutInspector
        collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        
        self.node.onDidLoad { (node) in
            guard let `node` = node as? ASCollectionNode else { return }
            print("Hello")
            node.leadingScreensForBatching = 2.0
            node.dataSource = self
            node.delegate = self
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "Rijks Collections"
        viewModel.input.refreshI.onNext("")
        viewModel.output.refreshO
            .do(onNext: { [weak self] (_) in
                guard let wSelf = self else { return }
                wSelf.node.reloadData()
                wSelf.context?.completeBatchFetching(true)
                wSelf.context = nil
            })
            .drive()
            .disposed(by: disposeBag)
        viewModel.output.newItemsO
            .drive()
            .disposed(by: disposeBag)
        viewModel.output.itemSelectedO
            .drive()
            .disposed(by: disposeBag)
        setupDrawer()
    }
    
    private func setupDrawer() {
        barItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"))
        navigationItem.leftBarButtonItem = barItem
        
        barItem.rx.tap
            .bind(to: viewModel.input.drawerSelectedI)
            .disposed(by: disposeBag)
        
        viewModel.output.drawerO
            .drive()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Fetch New Batch
    private func fetchNewBatchWithContext(_ context: ASBatchContext?) {
        viewModel.input.insertNewCollectionI.onNext(())
        context?.completeBatchFetching(true)
    }
}

extension HomeController: ASCollectionDelegate {
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return self.context == nil
    }
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        self.context = context
        fetchNewBatchWithContext(context)
    }
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
      return ASCellNode()
    }
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.didSelectItemI.onNext(indexPath)
    }
}

extension HomeController: ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.output.itemsO.value.count
    }
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard self.viewModel.output.itemsO.value.count > indexPath.row else { return ASCellNode() }
            let data = self.viewModel.output.itemsO.value[indexPath.row]
            let cellNode = HomeNode(data: data)
            return cellNode
        }
    }
}

// MARK: - Mosaic
extension HomeController: MosaicCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: MosaicCollectionViewLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
        let data = self.viewModel.output.itemsO.value[originalItemSizeAtIndexPath.item]
        return CGSize(width: data.webImage.width, height: data.webImage.height)
    }
}
