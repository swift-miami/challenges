//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let sortingStackView = SelfSortingStackView()
        
        view.addSubview(sortingStackView)
        self.view = view
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
// 1. Is your solution working?
// 2. Is it flexible? Can I only use that enum or is there a way through protocols to
//    use (almost) anything?
// 3. Can I remove views?
// 4. Can I sort in a different order?
// --------------------------------------------------------------------

enum Views: Int {
    case viewA, viewB, viewC, viewD
}

class SelfSortingStackView: UIStackView {

}



// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
