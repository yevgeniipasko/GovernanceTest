import UIKit

class DrawerViewController: UIViewController {
    
    struct Constants {
        static let selectedConstraint: CGFloat = -15
        static let defaultConstraint: CGFloat = 0
    }
    
    @IBOutlet weak var redPencilButton: UIButton!
    @IBOutlet weak var bluePencilButton: UIButton!
    @IBOutlet weak var greenPencilButton: UIButton!
    @IBOutlet weak var erasePencilButton: UIButton!

    @IBOutlet weak var redPencilButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bluePencilButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var greenPencilButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var erasePencilButtonConstraint: NSLayoutConstraint!

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!

    private var pencil: Pencil = .darkGreen
    private var brushWidth: CGFloat = 10.0
    private var opacity: CGFloat = 1.0
    
    private var drawingPoints: [CGPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectPencilView(with: pencil)
    }
    
    // MARK: - Actions
    
    @IBAction func resetPressed(_ sender: Any) {
        mainImageView.image = nil
    }

    @IBAction func pencilPressed(_ pencilButton: UIButton) {
        guard let pencil = getPencil(with: pencilButton) else {
            return
        }
        selectPencilView(with: pencil)
        self.pencil = pencil
        if pencil == .eraser {
            opacity = 1.0
        }
    }
    
    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(pencil.color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        
        UIGraphicsEndImageContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let lastPoint = touch.location(in: view)
        drawingPoints.append(lastPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let lastPoint = touch.location(in: view)
        drawingPoints.append(lastPoint)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pencilTime = pencil.timeDelaySec
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(pencilTime)) {
            self.drawPoints()
        }
    }
    
    private func drawPoints() {
        guard drawingPoints.count > 0 else {
            print("No points found")
            return
        }

        guard drawingPoints.count > 1 else {
            // Draw single point
            if let point = drawingPoints.first {
                drawLine(from: point, to: point)
            }
            return
        }

        for pointIndex in 0..<(drawingPoints.count - 1) {
            drawLine(from: drawingPoints[pointIndex], to: drawingPoints[pointIndex + 1])
        }

        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil

        drawingPoints.removeAll()
    }

}

extension DrawerViewController {

    fileprivate func getPencil(with button: UIButton) -> Pencil? {
        switch button {
        case redPencilButton:
            return .red
        case bluePencilButton:
            return .darkBlue
        case greenPencilButton:
            return .darkGreen
        case erasePencilButton:
            return .eraser
        default:
            return nil
        }
    }

    private func selectPencilView(with pencil: Pencil) {
        var selectedConstraint: NSLayoutConstraint
        var defaultConstraints: [NSLayoutConstraint]

        switch pencil {
        case .red:
            selectedConstraint = redPencilButtonConstraint
            defaultConstraints = [
                bluePencilButtonConstraint,
                greenPencilButtonConstraint,
                erasePencilButtonConstraint
            ]
        case .darkBlue:
            selectedConstraint = bluePencilButtonConstraint
            defaultConstraints = [
                redPencilButtonConstraint,
                greenPencilButtonConstraint,
                erasePencilButtonConstraint
            ]
        case .darkGreen:
            selectedConstraint = greenPencilButtonConstraint
            defaultConstraints = [
                redPencilButtonConstraint,
                bluePencilButtonConstraint,
                erasePencilButtonConstraint
            ]
        case .eraser:
            selectedConstraint = erasePencilButtonConstraint
            defaultConstraints = [
                redPencilButtonConstraint,
                bluePencilButtonConstraint,
                greenPencilButtonConstraint
            ]
        }

        selectedConstraint.constant = Constants.selectedConstraint
        defaultConstraints.forEach { constraint in
            constraint.constant = Constants.defaultConstraint
        }
    }

}
