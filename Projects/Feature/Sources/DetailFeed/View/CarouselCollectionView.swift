//
//  CarouselCollectionView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

//import Combine
//import UIKit
//import DesignSystem
//
//final class CarouselCollectionView: UICollectionView {
//    private var cancelBag = Set<AnyCancellable>()
//    private var datasourceCount = 0
//    private var feedImages: [String] = []
//    
//    init() {
//        let layout = UICollectionViewFlowLayout().then {
//            $0.scrollDirection = .horizontal
//            $0.itemSize = CGSize(width: 353, height: 353)
//            $0.minimumLineSpacing = 0
//            $0.minimumInteritemSpacing = 0
//        }
//        
//        super.init(frame: .zero, collectionViewLayout: layout)
//        
//        self.dataSource = self
//        self.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
//        self.showsHorizontalScrollIndicator = false
//        self.isPagingEnabled = true
//        self.backgroundColor = .clear
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func bind(viewModel: DetailFeedViewModel) {
//        viewModel.requestDetailFeed()
//        
//        viewModel
//            .imagePublisher
//            .receive(on: DispatchQueue.main)
//            .sink { value in
//                self.feedImages = value.images
//                self.datasourceCount = self.feedImages.count
//                self.reloadData()
//            }
//            .store(in: &cancelBag)
//    }
//}
//
//extension CarouselCollectionView: UICollectionViewDataSource {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int
//    ) -> Int {
//        return datasourceCount
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseIdentifier, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
//        
//        cell.configure(feedImages[indexPath.item])
//        
//        return cell
//    }
//}
