/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var people: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "The List"
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "Cell")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    
  }

  @IBAction func addName(_ sender: UIBarButtonItem) {

    let alert = UIAlertController(title: "New Name",
                                  message: "Add a new name",
                                  preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in

      guard let nameTextField = alert.textFields?.first,
            let nameToSave = nameTextField.text else {
          return
      }

      self.save(name: nameToSave)
      self.tableView.reloadData()
    }

    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)

    alert.addTextField()
    
    alert.textFields?[0].placeholder = "Name"

    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true)
  }

  func save(name: String) {
    people.append(name)
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return people.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath)
    
    let name = people[indexPath.row]
    
    cell.textLabel?.text = name
    return cell
  }
}