//
//  SpotTypeCollectionViewCell.swift
//  goodspots
//
//  Created by Alexander Grach on 3/8/19.
//  Copyright © 2019 goodbox. All rights reserved.
//

import Foundation


public class SpotTypeCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbSpotTypeName: UILabel!
    @IBOutlet weak var spotIcon: UIImageView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        // imageView.layer.cornerRadius = self.imageView.bounds.size.width / 2
        
        // imageView.layer.masksToBounds = true
        
        // self.imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        // self.imageView.layer.cornerRadius = self.imageView.layer.frame.width/2
        
        // self.imageView.layer.masksToBounds = true
        
        // self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // self.lbSpotTypeName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override public func layoutSubviews() {
        
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = self.imageView.layer.frame.width/2
        
        imageView.layer.masksToBounds = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // self.lbSpotTypeName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // imageView.layer.cornerRadius = self.imageView.bounds.size.width / 2
        
        // imageView.layer.masksToBounds = true
        
        // self.imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(_ spotModel: SpotTypeModel) {
        
        lbSpotTypeName.text = spotModel.SpotName
        
        if spotModel.IsSelected {
            self.imageView.backgroundColor = UIColor.spotsGreen()
        } else {
            self.imageView.backgroundColor = Color.grey.lighten3
        }
        
        self.spotIcon.contentMode = .scaleAspectFit
        
        switch spotModel.SpotName {
        case "Diving":
            self.spotIcon.image = SpotIcons.diving?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Camping":
            self.spotIcon.image = SpotIcons.camping?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Fishing":
            self.spotIcon.image = SpotIcons.fishing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Hiking":
            self.spotIcon.image = SpotIcons.hiking?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Rock Climbing":
            self.spotIcon.image = SpotIcons.rockclimbing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Mtn Biking":
            self.spotIcon.image = SpotIcons.mtnbiking?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Ice Climbing":
            self.spotIcon.image = SpotIcons.iceclimbing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Rafting":
            self.spotIcon.image = SpotIcons.rafting?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Canoeing":
            self.spotIcon.image = SpotIcons.canoeing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Surfing":
            self.spotIcon.image = SpotIcons.surfing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Swimming":
            self.spotIcon.image = SpotIcons.swimming?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Hot Springs":
            self.spotIcon.image = SpotIcons.hottub?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Beach":
            self.spotIcon.image = SpotIcons.beach?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Add Custom":
            self.spotIcon.image = SpotIcons.add_button?.tint(with: Color.grey.darken3)
        case "Firepit":
            self.spotIcon.image = SpotIcons.firepit?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Kid Friendly":
            self.spotIcon.image = SpotIcons.kidfriendly?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Pet Friendly":
            self.spotIcon.image = SpotIcons.petfriendly?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        default:
            self.spotIcon.image = SpotIcons.other?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        }
    }
    
}
