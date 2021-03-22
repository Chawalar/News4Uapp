//
//  NewsListTableViewCell.swift
//  News4U
//
//  Created by Igor Gaidamaka on 21.03.2021.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleSourceLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainView.layer.cornerRadius = 10
        self.mainView.layer.borderColor = UIColor.clear.cgColor
        self.mainView.layer.masksToBounds = true
        descriptionStackView.setCustomSpacing(4.0, after: articleTitleLabel)
        descriptionStackView.setCustomSpacing(4.0, after: articleSourceLabel)
        newsImageView.isAccessibilityElement = false
    }
    
    static var nib: UINib {
        let bundle = Bundle(for: NewsListTableViewCell.self)
        return UINib(nibName: identifier, bundle: bundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func configureCell(title: String, source: String, description: String) {
        self.articleTitleLabel.text = title
        self.articleSourceLabel.text = source
        self.articleDescriptionLabel.text = description
        applyAccessibility(title: title, source: source, description: description)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func applyAccessibility(title: String, source: String, description: String) {
        
        articleTitleLabel.accessibilityLabel = "News title \(title)"
        articleSourceLabel.accessibilityLabel = "Source \(source)"
        articleDescriptionLabel.accessibilityLabel = "News description \(description)"
    }
    
}

