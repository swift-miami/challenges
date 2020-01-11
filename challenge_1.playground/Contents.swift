//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    private let sortingStackView = SelfSortingStackView()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view

        // Add the sorting stack view
        sortingStackView.translatesAutoresizingMaskIntoConstraints = false
        sortingStackView.axis = .vertical
        sortingStackView.distribution = .fillEqually
        sortingStackView.spacing = 8
        view.addSubview(sortingStackView)
        NSLayoutConstraint.activate([
            sortingStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            sortingStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Add the views
        sortingStackView.addArrangedViewTypes(Views.allCases)
        
        addButtons()
    }
    
    private func addButtons() {
        let buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8
        view.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        let titles = ["↕️", "🅰", "🅱", "🅲", "🅳"]
        titles.forEach {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor.blue.withAlphaComponent(0.15)
            button.setTitle($0, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            button.addTarget(self, action: #selector(handleButtonTap(button:)), for: .touchUpInside)
            button.layer.cornerRadius = 12
            buttonStack.addArrangedSubview(button)
        }
    }
    
    @objc
    private func handleButtonTap(button: UIButton) {
        switch button.title(for: .normal) {
        case "🅰":
            sortingStackView.addArrangedViewTypes([.viewA])
        case "🅱":
            sortingStackView.addArrangedViewTypes([.viewB])
        case "🅲":
            sortingStackView.addArrangedViewTypes([.viewC])
        case "🅳":
            sortingStackView.addArrangedViewTypes([.viewD])
        case "↕️":
            sortingStackView.order = (sortingStackView.order == .ascending) ? .descending : .ascending
        default:
            break
        }
    }
}

// --------------------------------------------------------------------
// CHALLENGE
// Build a fill out the SelfSortingStackView with the ability to sort itself
// Find a way to associate the Views enum with a view and insert it in the stackview
// When inserted it should automagically sort

// You have complete control over the API, do your best to make it easy to work with
// First get it working, then iterate on it until you like it. There is no 1 answer
// You could do this multiple ways

// Things to keep in mind:
// 1. Is your solution working? ✅
// 2. Is it flexible? Can I only use that enum or is there a way through protocols to
//    use (almost) anything? ✅ (uses tags, so any UIView will work 😱)
// 3. Can I remove views? ✅ (tap on an item to remove it)
// 4. Can I sort in a different order? ✅ (ascending/descending)
// --------------------------------------------------------------------

enum Views: Int, CaseIterable {
    case viewA, viewB, viewC, viewD
    
    /// Create a view for a specific case above
    var view: UIView {
        let r = CGFloat(Int.random(in: 0 ..< 255))/255
        let g = CGFloat(Int.random(in: 0 ..< 255))/255
        let b = CGFloat(Int.random(in: 0 ..< 255))/255
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        view.tag = self.rawValue + 1 // Tags start at 1
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\n\(self) [\(self.rawValue)]\n"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        label.isUserInteractionEnabled = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        return view
    }
}

class SelfSortingStackView: UIStackView {

    enum Order {
        case ascending, descending
    }
    
    var order = Order.ascending {
        didSet {
            sortViews()
        }
    }
    
    /// Arranges a list of views and sorts them.
    func addArrangedViewTypes(_ types: [Views]) {
        types.forEach {
            super.addArrangedSubview($0.view)
        }
        sortViews()
    }
    
    /// Sort the arranged subviews based on their tag
    private func sortViews() {
        arrangedSubviews
            .sorted {
                if order == .ascending {
                    return $0.tag < $1.tag
                } else {
                    return $0.tag > $1.tag
                }
            }
            .forEach {
                // We could call insertArrangedSubview here, but
                // luckily we can be lazy and not have to figure out
                // where the view should go, as UIStackView takes care of it.
                super.addArrangedSubview($0)
            }
    }
    
    // MARK: - Overrides
    
    // Tell people that they shouldn't use this anymore.
    @available(iOS, deprecated: 13.0, message: "Use addArrangedViewTypes() instead")
    override func addArrangedSubview(_ view: UIView) {
        super.addArrangedSubview(view)
    }
    
    /// Super dirty way of removing elements by tapping on them 😬
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        for view in arrangedSubviews where view.frame.contains(location) {
            view.removeFromSuperview()
            break
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
