//
//  TodosDetailViewController.swift
//  todo
//
//  Created by Alejandro Mendoza on 07/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit
import CoreData

class TodosDetailViewController: UIViewController {

    
    @IBOutlet weak var addTodoView: AddTodo!
    @IBOutlet weak var toolbarView: Toolbar!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTodoBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var addTodoBackgroundView: UIView!
    
    let keyboardHandler = KeyboardEvents()
    
    var actualTodoDetailState: TodoState = .discard
    var actualKeyboardState: KeyboardState = .hidden
    
    var _fetchedResultsController: NSFetchedResultsController<Todo>? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler.registerForKeyboardEvents()
        
        keyboardHandler.delegate = self
        toolbarView.delegate = self
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.allowsMultipleSelectionDuringEditing = false
        
        if let todos = fetchedResultsController.fetchedObjects {
            TodoManager.sharedInstance.todos = todos
        }
        
        setupUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHandler.unregisterFromKeyboardEvents()
        
    }
    
    func setupUI(){
        let discardTap = UITapGestureRecognizer(target: self, action: #selector(addTodoBackgroundViewWasSelected))
        addTodoBackgroundView.addGestureRecognizer(discardTap)
        
        detailTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.DetailTodoCellIdentifier)
    }
    
    @IBAction func addTodoButtonTapped(_ sender: UIButton) {
        actualTodoDetailState = .present
        let animationDuration: TimeInterval = 0.25
        addTodoView.alpha = 0
        addTodoView.isHidden = false
        
        addTodoBackgroundView.alpha = 0
        addTodoBackgroundView.isHidden = false
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.addTodoView.alpha = 1
            self.addTodoBottomConstraint.constant = self.view.frame.height * 0.4
            self.view.layoutIfNeeded()
        }) { (_) in
            
            UIView.animate(withDuration: animationDuration) {
                self.addTodoBackgroundView.alpha = 1
            }
            
            self.addTodoView.todoTextView.becomeFirstResponder()
        }
    }
    
    func insertNewTodo(){
        let context = self.fetchedResultsController.managedObjectContext
        let newTodo = Todo(context: context)
             
        newTodo.compleated = false
        newTodo.tagName = "#Test"
        newTodo.todoDescription = "Esta es una descripción"
        newTodo.dateCreation = Date()
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    @objc func addTodoBackgroundViewWasSelected(){
        discardActionWasSelected()
    }
    
    
}

// MARK: - Handle Keyboard Events
extension TodosDetailViewController: KeyboardHandlingDelegate {
    func keyboardWillShow(_ notification: Notification) {
        
        toolbarView.isHidden = false
        toolbarView.alpha = 0
        
        let keyboardSize = notification.keyboardSize
        
        if let keyboardHeight = keyboardSize?.height, let animationDuration = notification.keyboardAnimationDuration {
            UIView.animate(withDuration: animationDuration, animations: {
                self.addTodoBottomConstraint.constant = keyboardHeight + 50.0
                self.toolbarView.alpha = 1
                self.toolbarBottomConstraint.constant = keyboardHeight - 35.0
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
        }
        
    }
    
    func keyboardDidShow(_ notification: Notification) {
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if actualTodoDetailState == .discard {
            UIView.animate(withDuration: 0.25) {
                self.toolbarView.alpha = 0
                self.toolbarBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        else if actualTodoDetailState == .schedule {
            let animationDuration = notification.keyboardAnimationDuration ?? 0.25
            UIView.animate(withDuration: animationDuration, animations: {
                self.toolbarView.alpha = 0
                self.toolbarBottomConstraint.constant = 0
            }) { (_) in
                 
            }
        }
    }
    
    func keyboardDidHide(_ notification: Notification) {
        
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        
    }
    
    func keyboardDidChangeFrame(_ notification: Notification) {
        
    }
    
    
}

// MARK: - Handle Toolbar Events
extension TodosDetailViewController: ToolbarDelegate {
    func addActionWasSelected() {
        insertNewTodo()
    }
    
    func scheduleActionWasSelected() {
        actualTodoDetailState = .schedule
        
        addTodoView.todoTextView.resignFirstResponder()
    }
    
    func discardActionWasSelected() {
        
        actualTodoDetailState = .discard
        let animationDuration: TimeInterval = 0.25
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.addTodoBottomConstraint.constant = 0
            self.addTodoView.alpha = 0
            self.addTodoBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.addTodoView.todoTextView.resignFirstResponder()
            self.addTodoView.isHidden = true
        }
        
    }
    
    
}

// MARK: - Handle View Updates
extension TodosDetailViewController {
    
    enum TodoState {
        case present
        case keyboardHidden
        case discard
        case schedule
    }
    
    enum KeyboardState{
        case hidden
        case presented
    }
    
}

// MARK: - Handle UI Updated

extension TodosDetailViewController {
    
}



// MARK: - Fetched Results Controller

extension TodosDetailViewController: NSFetchedResultsControllerDelegate {
    var fetchedResultsController: NSFetchedResultsController<Todo> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "dateCreation", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        detailTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                detailTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                detailTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let todos = fetchedResultsController.fetchedObjects {
            TodoManager.sharedInstance.todos = todos
        }
        
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        detailTableView.endUpdates()
    }
}





