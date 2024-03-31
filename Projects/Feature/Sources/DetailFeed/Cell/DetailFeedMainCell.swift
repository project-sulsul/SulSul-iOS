//
//  DetailFeedMainCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import UIKit
import DesignSystem

final class DetailFeedMainCell: UICollectionViewCell {
    static let reuseIdentifier: String = "DetailFeedMainCell"
    
    private var drinkName: String = ""
    private var snackName: String = ""
    private var carouselCurrentIndex: Int = 1
    private var imageOfList: [String] = []
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
        $0.frame = .zero
    }
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 353, height: 353)
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    private lazy var carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var indexLabel = PaddableLabel(edgeInsets: 2, 8, 2, 8).then {
        $0.setLineHeight(18, font: Font.regular(size: 12))
        $0.font = Font.regular(size: 12)
        $0.text = "\(carouselCurrentIndex)/\(imageOfList.count)"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = CGFloat(8)
        $0.layer.masksToBounds = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(36, font: Font.bold(size: 24))
        $0.font = Font.bold(size: 24)
        $0.text = "썸네일이 위스키인 피드글에 최적의 소맥 비율을 묻다"
        $0.textColor = DesignSystemAsset.white.color
        $0.numberOfLines = 2
    }
    
    private lazy var indicatorView = UIView().then {
        $0.frame = .zero
        $0.backgroundColor = DesignSystemAsset.main.color
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = CGFloat(20)
        $0.layer.masksToBounds = true
    }
    
    private lazy var usernameLabel = UILabel().then {
        $0.setLineHeight(28, font: Font.bold(size: 18))
        $0.font = Font.bold(size: 18)
        $0.text = "알 수 없음"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var createdAtLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.regular(size: 10))
        $0.font = Font.regular(size: 10)
        $0.text = "24.03.14"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.bold(size: 10.67))
        $0.font = Font.bold(size: 10.67)
        $0.text = "0점"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var scoreLevelImageView = UIImageView().then {
        $0.image = UIImage(named: "score_level_0")
    }
    
    private lazy var drinkLabel = PaddableLabel(edgeInsets: 1, 4, 1, 4).then {
        $0.setLineHeight(18, font: Font.semiBold(size: 12))
        $0.font = Font.semiBold(size: 12)
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var snackLabel = PaddableLabel(edgeInsets: 1, 4, 1, 4).then {
        $0.setLineHeight(18, font: Font.semiBold(size: 12))
        $0.font = Font.semiBold(size: 12)
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var textView = UITextView().then {
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.isSelectable = true
        $0.font = Font.medium(size: 16)
        $0.backgroundColor = .clear
        $0.textColor = DesignSystemAsset.gray800.color
        $0.text = "작성된 내용이 없습니다."
    }
    
    private lazy var feedViewsImageView = UIImageView().then {
        $0.image = UIImage(named: "views")
    }
    
    private lazy var feedCommentsImageView = UIImageView().then {
        $0.image = UIImage(named: "comments")
    }
    
    private lazy var feedLikesImageView = UIImageView().then {
        $0.image = UIImage(named: "likes")
    }
    
    private lazy var feedViewsLabel = UILabel().then {
        $0.setLineHeight(22, font: Font.medium(size: 14))
        $0.font = Font.medium(size: 14)
        $0.text = "0"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var feedCommentsLabel = UILabel().then {
        $0.setLineHeight(22, font: Font.medium(size: 14))
        $0.font = Font.medium(size: 14)
        $0.text = "0"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var feedLikesLabel = UILabel().then {
        $0.setLineHeight(22, font: Font.medium(size: 14))
        $0.font = Font.medium(size: 14)
        $0.text = "0"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var feedViewsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.distribution = .fillEqually
        $0.addArrangedSubviews([feedViewsImageView, feedViewsLabel])
    }
    
    private lazy var feedCommentsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.distribution = .fillEqually
        $0.addArrangedSubviews([feedCommentsImageView, feedCommentsLabel])
    }
    
    private lazy var feedLikesStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.distribution = .fillEqually
        $0.addArrangedSubviews([feedLikesImageView, feedLikesLabel])
    }
    
    private lazy var pairingStackView = PairingStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        containerView.addSubviews([
            carouselCollectionView,
            indicatorView,
            profileImageView,
            usernameLabel,
            createdAtLabel,
            textView,
            scoreLabel,
            scoreLevelImageView,
            feedViewsStackView,
            feedCommentsStackView,
            feedLikesStackView,
            pairingStackView
        ])
        
        self.addSubviews([
            containerView,
            indexLabel,
            titleLabel
        ])
        
        self.bringSubviewToFront(indexLabel)
        self.bringSubviewToFront(titleLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        carouselCollectionView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 353))
        }
        indexLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalTo(titleLabel.snp.top).offset(moderateScale(number: -4))
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(carouselCollectionView.snp.leading).inset(moderateScale(number: 18))
            $0.bottom.equalTo(carouselCollectionView.snp.bottom).inset(moderateScale(number: 16))
            $0.width.equalTo(moderateScale(number: 317))
            $0.height.equalTo(moderateScale(number: 72))
        }
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(indicatorView.snp.bottom).offset(moderateScale(number: 26))
            $0.size.equalTo(moderateScale(number: 40))
        }
        usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(moderateScale(number: 12))
            $0.top.equalTo(indicatorView.snp.bottom).offset(moderateScale(number: 24))
        }
        scoreLabel.snp.makeConstraints {
            $0.trailing.equalTo(scoreLevelImageView.snp.leading).offset(moderateScale(number: -7.11))
            $0.top.equalTo(indicatorView.snp.bottom).offset(moderateScale(number: 27))
        }
        scoreLevelImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(scoreLabel)
        }
        pairingStackView.snp.makeConstraints {
            $0.top.equalTo(scoreLabel.snp.bottom).offset(moderateScale(number: 2))
            $0.trailing.equalToSuperview()
        }
        createdAtLabel.snp.makeConstraints {
            $0.leading.equalTo(usernameLabel)
            $0.top.equalTo(usernameLabel.snp.bottom).offset(moderateScale(number: 8))
        }
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(moderateScale(number: 18))
            $0.height.equalTo(moderateScale(number: 144))
        }
        feedViewsStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.bottom).inset(moderateScale(number: 22))
        }
        feedCommentsStackView.snp.makeConstraints {
            $0.leading.equalTo(feedViewsStackView.snp.trailing).offset(moderateScale(number: 16))
            $0.bottom.equalTo(feedViewsStackView)
        }
        feedLikesStackView.snp.makeConstraints {
            $0.leading.equalTo(feedCommentsStackView.snp.trailing).offset(moderateScale(number: 16))
            $0.bottom.equalTo(feedViewsStackView)
        }
    }
    
    func bind(_ model: DetailFeed.Feed) {
        imageOfList = model.images
        updateIndicatorViewWidth()
        updateIndex(to: carouselCurrentIndex)
        updateScore(to: model.score)
        carouselCollectionView.reloadData()
        
        textView.text = model.content
        updateTextViewHeightDimension(textView)
        
        titleLabel.text = model.title
        
        feedViewsLabel.text = String(model.viewCount)
        
        feedCommentsLabel.text = String(model.commentCount)
        
        feedLikesLabel.text = String(model.likeCount)
        
        if let username = model.writerInfo?.nickname {
            usernameLabel.text = username
        } else {
            usernameLabel.text = "알 수 없음"
        }
        
        if let profileImageURL = model.writerInfo?.image,
           let profileImage = URL(string: profileImageURL) {
            profileImageView.loadImage(profileImage)
        } else {
            print("Image URL is not available.")
            profileImageView.image = UIImage()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if let createdAtDate = dateFormatter.date(from: model.createdAt) {
            let displayDateFormat = DateFormatter()
            displayDateFormat.dateFormat = "yy.MM.dd"
            createdAtLabel.text = displayDateFormat.string(from: createdAtDate)
        } else {
            createdAtLabel.text = model.createdAt
        }
    }
    
    private func updateScore(to score: Int) {
        switch score {
        case 5: 
            scoreLabel.text = "5점"
            scoreLabel.textColor = DesignSystemAsset.main.color
            scoreLevelImageView.image = UIImage(named: "score_level_5")
        case 4: 
            scoreLabel.text = "4점"
            scoreLabel.textColor = DesignSystemAsset.main.color
            scoreLevelImageView.image = UIImage(named: "score_level_4")
        case 3: 
            scoreLabel.text = "3점"
            scoreLabel.textColor = DesignSystemAsset.main.color
            scoreLevelImageView.image = UIImage(named: "score_level_3")
        case 2: 
            scoreLabel.text = "2점"
            scoreLabel.textColor = DesignSystemAsset.main.color
            scoreLevelImageView.image = UIImage(named: "score_level_2")
        case 1: 
            scoreLabel.text = "1점"
            scoreLabel.textColor = DesignSystemAsset.main.color
            scoreLevelImageView.image = UIImage(named: "score_level_1")
        default: 
            scoreLabel.text = "0점"
            scoreLabel.textColor = DesignSystemAsset.main.color
            scoreLevelImageView.image = UIImage(named: "score_level_0")
        }
    }
    
    private func updateTextViewHeightDimension(_ textView: UITextView) {
        let contentSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        textView.snp.updateConstraints {
            $0.height.equalTo(contentSize.height)
        }
        self.layoutIfNeeded()
    }
    
    private func updateIndex(to currentIndex: Int) {
        self.indexLabel.text = "\(carouselCurrentIndex)/\(imageOfList.count)"
    }
    
    private func updateIndicatorViewWidth() {
        let divided = imageOfList.count
        
        indicatorView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(carouselCollectionView.snp.bottom).offset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 2))
            $0.width.equalToSuperview().dividedBy(imageOfList.count)
        }
    }
}

extension DetailFeedMainCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return imageOfList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseIdentifier, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
        
        let item = imageOfList[indexPath.item]
        
        cell.configure(item)
        
        return cell
    }
}

extension DetailFeedMainCell: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth) + 1
        
        carouselCurrentIndex = currentPage
        updateIndex(to: carouselCurrentIndex)

        if carouselCurrentIndex != imageOfList.count {
            indicatorView.snp.remakeConstraints {
                $0.leading.equalToSuperview()
                $0.top.equalTo(carouselCollectionView.snp.bottom).offset(moderateScale(number: 16))
                $0.height.equalTo(moderateScale(number: 2))
                $0.width.equalToSuperview().dividedBy(imageOfList.count)
            }
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else if carouselCurrentIndex == imageOfList.count {
            indicatorView.snp.remakeConstraints {
                $0.leading.equalToSuperview()
                $0.top.equalTo(carouselCollectionView.snp.bottom).offset(moderateScale(number: 16))
                $0.height.equalTo(moderateScale(number: 2))
                $0.width.equalToSuperview()
            }
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
}
