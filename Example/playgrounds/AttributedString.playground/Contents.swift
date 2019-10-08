import UIKit
import PlaygroundSupport
import Stem

class CustomViewController: UIViewController {

    let label = UILabel()
    let textView = UITextView()

    func attributedString() -> NSAttributedString {
        return NSAttributedString()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        label.backgroundColor = .red
        view.addSubview(label)
        label.frame = view.bounds.st.changed(height: view.bounds.height * 0.5)

        textView.backgroundColor = .blue
        view.addSubview(textView)
        textView.frame = view.bounds
            .st.changed(height: view.bounds.height * 0.5)
            .st.changed(y: view.bounds.height * 0.5)
    }

}

let viewController = CustomViewController()
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true
