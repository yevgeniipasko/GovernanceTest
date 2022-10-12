import UIKit

enum Pencil {

    case red
    case blue
    case green
    case eraser

    init?(tag: Int) {
        switch tag {
        case 1:
            self = .red
        case 2:
            self = .blue
        case 3:
            self = .green
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
        case .blue:
            return 3
        case .green:
            return 5
        case .eraser:
            return 2
        }
    }

    var color: UIColor {
        switch self {
        case .red:
            return UIColor(named: "red") ?? .red
        case .blue:
            return UIColor(named: "blue") ?? .blue
        case .green:
            return UIColor(named: "green") ?? .green
        case .eraser:
            return .white
        }
    }

}
