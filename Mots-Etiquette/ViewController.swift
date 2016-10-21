import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBAction func didTapNextButton(_ sender: AnyObject) {
        previousButton.isHidden = false
        index += 1
        wordLabel.text = shuffledWords[index]
        if index == shuffledWords.count - 1 {
            nextButton.isHidden = true
        }
    }
    @IBAction func didTapPreviousButton(_ sender: AnyObject) {
        nextButton.isHidden = false
        index -= 1
        wordLabel.text = shuffledWords[index]
        if index == 0 {
            previousButton.isHidden = true
        }
    }

    var shuffledWords: Array<String>!
    var index: Int = 0
    let csvUrl = URL(string: "https://dl.dropboxusercontent.com/u/8766933/mots-etiquettes.csv")!

    override func viewDidLoad() {
        super.viewDidLoad()

        wordLabel.text = "Chargement..."
        previousButton.isHidden = true
        nextButton.isHidden = true

        fetchWords()
    }

    private func fetchWords() {
        let urlContent = try? String.init(contentsOf: csvUrl)

        if let urlContents = urlContent {
            let words = urlContents.replacingOccurrences(of: "\n", with: "").components(separatedBy: ",")
            if words.isEmpty {
                self.wordLabel.text = "⚠ Erreur 😟"
            } else {
                self.shuffledWords = words.shuffled()
                self.wordLabel.text = self.shuffledWords[0]
                self.nextButton.isHidden = false
            }
        }
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

