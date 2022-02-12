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
    }
    
    struct Output {
        let itemsO: BehaviorRelay<[ArtObjects]>
        let refreshO: Driver<Void>
    }
    
    private let refreshSubject = PublishSubject<String>()
    private let items = BehaviorRelay<[ArtObjects]>(value: [])
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    
    init() {
        input = Input(refreshI: refreshSubject.asObserver())
        
        // fetch data
        let items = refreshSubject.startWith("")
            .flatMapLatest { (_) -> Observable<[ArtObjects]> in
                return NetworkManager.instance.requestObject(RijksAPI.collection(p: 1, ps: 50), c: Collection.self)
                    .map({ $0.artObjects })
                    .do(onSuccess: { [weak self] (collection) in
                        guard let wSelf = self else { return }
                        wSelf.items.accept(collection)
                    }, onError: { (error) in
                        print(error)
                    })
                    .trackActivity(self.activityIndicator)
                    .trackError(self.errorTracker)
                    .asObservable()
            }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
            
        output = Output(itemsO: self.items, refreshO: items)
    }
}
