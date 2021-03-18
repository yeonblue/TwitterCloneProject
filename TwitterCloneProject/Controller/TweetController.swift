//
//  TweetController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/18.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let reuseHeaderIdentifier = "TweetHeader"

class TweetController: UICollectionViewController {
    
    // MARK: - Properties
    private let tweet: Tweet
    
    // MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .twitterBlue
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.register(TweetHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: reuseHeaderIdentifier)
    }
}

// MARK: - UICollectionViewDataSource/Delegate
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TweetCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: reuseHeaderIdentifier,
                                                                     for: indexPath) as! TweetHeader
        return header
    }
}

// MARK: - UICollecitonViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}
