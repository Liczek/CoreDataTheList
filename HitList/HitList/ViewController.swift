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
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  var people: [Person] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "The List"
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: self.view.bounds.size.width/2.0 - 16, height: 250)
    
    collectionView.dataSource = self
    collectionView.setCollectionViewLayout(layout, animated: false)
    collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    collectionView.reloadData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    
    
    do {
      people = try managedContext.fetch(Person.fetchRequest())
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  @IBAction func addPerson(_ sender: UIBarButtonItem) {

    let alert = UIAlertController(title: "New Person", message: "Add a new person", preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in

      guard let nameToSave = alert.textFields?[0].text,
            let addressToSave = alert.textFields?[1].text,
            let age = alert.textFields?[2].text,
            let eyeColor = alert.textFields?[3].text,
            let ageToSave = Int16(age) else {
          return
      }
      let eyeColorToSave = self.eyeColorFromString(eyeColor)
      self.save(name: nameToSave, address: addressToSave, age: ageToSave, eyeColor: eyeColorToSave)
      self.collectionView.reloadData()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .default)

    alert.addTextField()
    alert.addTextField()
    alert.addTextField()
    alert.addTextField()

    

    alert.textFields?[0].placeholder = "Name"
    alert.textFields?[1].placeholder = "Address"
    alert.textFields?[2].placeholder = "Age"
    alert.textFields?[3].placeholder = "Eye Color"

    

    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true)
  }
  
  func eyeColorFromString(_ eyeColor: String) -> UIColor {
    switch eyeColor {
    case "Blue":
      return UIColor.blue
    case "Green":
      return UIColor.green
    case "Grey":
      return UIColor.gray
    case "Brown":
      return UIColor.brown
    case "Purple":
      return UIColor.purple
    default:
      return UIColor.blue
    }
  }

  func save(name: String, address: String, age: Int16, eyeColor: UIColor) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let person = Person(entity: Person.entity(), insertInto: managedContext)
    
    person.name = name
    person.address = address
    person.age = age
    person.eyeColor = eyeColor
    
    do {
      try managedContext.save()
      people.append(person)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return people.count
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let person = people[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TargetCollectionViewCell
    
    cell.nameLabel.text = person.value(forKey: "name") as! String?
    cell.addressLabel.text = person.value(forKey: "address") as! String?
    
    return cell
  }
}
