//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//

class LeftViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var imgLogoutIcon: UIImageView!
    @IBOutlet var imgLeftLine: UIImageView!
    @IBOutlet var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        titleLabel.alpha = highlighted ? 0.5 : 1.0
    }

}
