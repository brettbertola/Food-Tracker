//
//  MealTableViewController.swift
//  Food Tracker
//
//  Created by Brett Bertola on 2/10/18.
//  Copyright © 2018 Brett Bertola. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMeals = loadMeals(){
            meals += savedMeals
        } else {
        loadSampleMeals()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveMeals()
        }
    }
    //MARK: Private Methods
    
    private func loadSampleMeals() {
        guard let meal1 = Meal(name: "Salad", photo: #imageLiteral(resourceName: "meal1"), rating: 3) else {
            fatalError("You blew it")
        }
        guard let meal2 = Meal(name: "Tuna", photo: #imageLiteral(resourceName: "meal1"), rating: 0) else {
            fatalError("No coming back from this")
        }
        guard let meal3 = Meal(name: "Tacos", photo: #imageLiteral(resourceName: "meal1"), rating: 5) else {
            fatalError("SIGBRT")
        }
        
        meals += [meal1, meal2, meal3]
        
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meal was saved", log: OSLog.default, type: .debug)
        } else {
            os_log("Somehting happened and the meal did not save to the core", log: OSLog.default,  type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("HAHAHAAHAHAHAHAHAHA")
        }
        
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyles: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyles == .delete {
            
            // Delete the row
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyles == .insert {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? ViewController else {
                fatalError("Nope.")
            }
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Try again")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("Peace out, I'm no help here")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("That segue does not exist")
            

        }
    }


}
