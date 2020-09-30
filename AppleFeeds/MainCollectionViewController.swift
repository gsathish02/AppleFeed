//
//  MainCollectionViewController.swift
//  AppleFeeds
//
//  Created by Sathish Kumar G on 9/30/20.
//  Copyright © 2020 Sathish Kumar G. All rights reserved.
//

import UIKit

private let listReuseIdentifier = "ListCell"
private let gridReuseIdentifier = "GridCell"

class MainCollectionViewController: UICollectionViewController {
    
    var feedResult: [Feed] = []
    var feedManager = FeedManager()
    var totalResult: [Result] = []
    let customFlowLayout = UICollectionViewFlowLayout()
    
    private var layoutOption: LayoutOption = .list {
        didSet {
            setupLayout(with: view.bounds.size)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBarItem()
        setupLayout(with: view.bounds.size)
        fetchFeedResult()
        self.title = "Top 50 Free Apps"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupLayout(with: size)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLayout(with: view.bounds.size)
    }
    
    private func fetchFeedResult() {
        feedManager.getFeedResult(urlString: Constants.baseUrl, completionHandler:{ receivedModel in
            guard let modelData = receivedModel else {
                //Error Handling
                let alert = UIAlertController(title: "Alert", message: Constants.genericErrorMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.feedResult.append(modelData)
            self.totalResult.append(contentsOf: modelData.results)
            
            self.collectionView.reloadData()
            self.hideLoader()
        })
    }
    
    private func showLoader() {
        feedManager.showHUD(thisView: self.view)
    }
    
    private func hideLoader() {
        feedManager.hideHUD()
    }
    
    private func setupCollectionView() {
        // Register cell classes
        collectionView.register(UINib(nibName: "ResultListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: listReuseIdentifier)
        collectionView.register(UINib(nibName: "ResultGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: gridReuseIdentifier)
        
        customFlowLayout.sectionInsetReference = .fromContentInset // .fromContentInset is default
        customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        customFlowLayout.minimumInteritemSpacing = 10
        customFlowLayout.minimumLineSpacing = 10
        customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        customFlowLayout.headerReferenceSize = CGSize(width: 0, height: 40)
        
        collectionView.collectionViewLayout = customFlowLayout
        collectionView.contentInsetAdjustmentBehavior = .always
    }
    
    private func setupLayout(with containerSize: CGSize) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        switch layoutOption {
        case .list:
            break
        case .grid:
            break
            
        }
        collectionView.reloadData()
    }
    
    private func setupNavigationBarItem() {
        let barButtonItem = UIBarButtonItem(title: "Layout", style: .plain, target: self, action: #selector(layoutTapped(_:)))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func layoutTapped(_ sender: Any) {
        
        if self.layoutOption == .list {
            self.layoutOption = .grid
        } else {
            self.layoutOption = .list
        }
    }
}

extension MainCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalResult.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutOption {
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listReuseIdentifier, for: indexPath) as! ResultListCollectionViewCell
            let feed = totalResult[indexPath.item]
            cell.setup(with: feed)
            return cell
            
        case .grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridReuseIdentifier, for: indexPath) as! ResultGridCollectionViewCell
            let feed = totalResult[indexPath.item]
            cell.setup(with: feed)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        switch layoutOption {
        case .list:
            return CGSize(width: collectionViewSize, height: collectionViewSize)
        case .grid:
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        }
    }
}


final class CustomFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach({ layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        })
        return layoutAttributesObjects
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            fatalError()
        }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}
