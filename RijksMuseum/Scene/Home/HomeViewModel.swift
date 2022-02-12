//
//  HomeViewModel.swift
//  RijksMuseum
//
//  Created by M Hanif Sugiyanto on 12/02/22.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    var input: Input
    var output: Output!
    
    struct Input {
        let refreshI: AnyObserver<String>
        let insertNewCollection: AnyObserver<Void>
    }
    
    struct Output {
        let itemsO: BehaviorRelay<[ArtObjects]>
        let refreshO: Driver<Void>
        let newItemsO: Driver<Void>
    }
    
    private let refreshSubject = PublishSubject<String>()
    private let insertNewCollectionSubject = PublishSubject<Void>()
    private let items = BehaviorRelay<[ArtObjects]>(value: [])
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    private let totalPages = 1000
    private var currentPage = 1
    
    init() {
        input = Input(refreshI: refreshSubject.asObserver(),
                      insertNewCollection: insertNewCollectionSubject.asObserver())
        
        // fetch data
        let canFetchData = insertNewCollectionSubject
            .flatMapLatest { [weak self] (_) -> Observable<Bool> in
                guard let wSelf = self else { return Observable.empty() }
                if wSelf.currentPage <= wSelf.totalPages {
                    wSelf.refreshSubject.onNext("")
                    return Observable.just(true)
                } else {
                    return Observable.just(false)
                }
            }
            .trackActivity(self.activityIndicator)
            .trackError(self.errorTracker)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    
        let items = refreshSubject
            .flatMapLatest { [weak self] (_) -> Observable<[ArtObjects]> in
                guard let wSelf = self else { return Observable.empty() }
                return NetworkManager.instance.requestObject(RijksAPI.collection(p: wSelf.currentPage, ps: 10), c: Collection.self)
                    .map({ $0.artObjects })
                    .do(onSuccess: { (collection) in
                        print("current page == \(wSelf.currentPage)")
                        wSelf.currentPage += 1
                        let itemsCollection = wSelf.items.value + collection
                        wSelf.items.accept(itemsCollection)
                    }, onError: { (error) in
                        print(error)
                    })
                    .trackActivity(wSelf.activityIndicator)
                    .trackError(wSelf.errorTracker)
                    .asObservable()
            }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
            
        output = Output(itemsO: self.items,
                        refreshO: items,
                        newItemsO: canFetchData)
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {

    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
}
