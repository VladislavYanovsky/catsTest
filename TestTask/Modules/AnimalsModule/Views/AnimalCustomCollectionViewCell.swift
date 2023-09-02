//
//  AnimalCustomCollectionViewCell.swift
//  TestTask
//
//  Created by Vladislav on 1.09.23.
//

import UIKit

class AnimalCustomCollectionViewCell: UICollectionViewCell {
    
    var cellViewModel: AnimalCellViewModel? {
        didSet {
            animalBreedLabel.text = cellViewModel?.breed
            
            if let urlString = cellViewModel?.imageUrl,
               let url = URL(string: urlString) {
                self.animalImageView.load(url: url)
            }
        }
    }
    
    fileprivate let animalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate let animalBreedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: Constants.textColor)
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = UIColor(named: Constants.backgroundColor)
        contentView.addSubview(animalImageView)
        contentView.addSubview(animalBreedLabel)
        contentView.clipsToBounds = true

        animalImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        animalImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        animalImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        animalImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        animalImageView.image = nil
        animalBreedLabel.text = nil
    }
}
