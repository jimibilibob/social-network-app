//
//  DeviceImageLibraryViewController.swift
//  social-network-app
//
//  Created by user on 14/7/22.
//

import UIKit

import UIKit
import Photos

protocol DeviceImageLibraryViewControllerDelegate {
    func onDevicePhotoSelected(selectedAsset: PHAsset)
}

class DeviceImageLibraryViewController: UIViewController {
    
    let cancelButton = UIButton()
    let collectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        // Register cell
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        
        return cv
    }()
    
    var delegate: DeviceImageLibraryViewControllerDelegate?
    
    
    var availableAssets: PHFetchResult<PHAsset>?
    var photos: [UIImage?]?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(cancelButton)
        view.addSubview(collectionView)
        
        setupCancelButton()
        setupCollectionView()
        
        loadData()
        
    }
    
    func loadData() {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate", ascending: false
            )
        ]
        
        
        availableAssets = PHAsset.fetchAssets(with: .image, options: options)
        photos = Array(repeating: nil, count: availableAssets?.count ?? 0)
        
        collectionView.reloadData()
        
        loadPhotosAsync()
    }
    
    func loadPhotosAsync() {
        for index in 0..<(availableAssets?.count ?? 0){
            availableAssets?[index].image(targetSize: CGSize(width: 500, height: 500), isSynchronous: false) { image in
                self.photos?[index] = image
                self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
    
    func setupCancelButton() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .black
        cancelButton.setTitleColor(.white, for: .normal)
        
        cancelButton.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        cancelButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.topAnchor.constraint(equalTo: cancelButton.topAnchor, constant: cancelButton.frame.height + 10).isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
}

extension DeviceImageLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width / 4
        let h = collectionView.frame.width / 4
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else {return UICollectionViewCell()}
        
        cell.photo = photos?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            if let asset = self.availableAssets?[indexPath.row] {
                self.delegate?.onDevicePhotoSelected(selectedAsset: asset)
            }
        })
    }
}

class PhotoCell: UICollectionViewCell {
    var photo: UIImage? {
        
        // This is called after something give values to this property
        didSet {
            imageView.image = photo
            imageView.contentMode = .scaleAspectFill
        }
    }
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PHAsset {
    func image(targetSize: CGSize = PHImageManagerMaximumSize, isSynchronous: Bool = true, completion: @escaping (_ image: UIImage?) -> Void) {
        let imageManager = PHCachingImageManager()
        let option = PHImageRequestOptions()
        option.isSynchronous = isSynchronous
        option.resizeMode = .exact
        
        DispatchQueue.main.async {
            imageManager.requestImage(for: self, targetSize: targetSize, contentMode: .aspectFit, options: option, resultHandler: {image, _ in
                
                completion(image)
            })
        }
    }
}

