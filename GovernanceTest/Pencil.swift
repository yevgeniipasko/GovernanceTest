import UIKit

enum Pencil {

    case red
    case darkBlue
    case darkGreen
    case eraser

    init?(tag: Int) {
        switch tag {
        case 1:
            self = .red
        case 2:
            self = .darkBlue
        case 3:
            self = .darkGreen
        case 4:
            self = .eraser
        default:
            return nil
        }
    }
    
    var timeDelaySec: Int {
        switch self {
        case .red:
            return 1
        case .darkBlue:
            return 3
        case .darkGreen:
            return 5
        case .eraser:
            return 2
        }
    }

    var color: UIColor {
        switch self {
        case .red:
            return UIColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        case .darkBlue:
            return UIColor(red: 0, green: 0, blue: 1, alpha: 1.0)
        case .darkGreen:
            return UIColor(red: 102/255.0, green: 204/255.0, blue: 0, alpha: 1.0)
        case .eraser:
            return .white
        }
    }

}
