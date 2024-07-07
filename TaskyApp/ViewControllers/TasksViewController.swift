//
//  TasksViewController.swift
//  TaskyApp
//
//  Created by Yuri Correa on 05/07/24.
//

import UIKit


protocol TaskDelegate: AnyObject {
    func didAddTask(newTask: Task)
}

class TasksViewController: UIViewController {
 
    private lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 24.0
        let header = TasksTableViewHeader(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64.0))
        tableView.tableHeaderView = header
        header.delegate = self
        return tableView
    }()
    
    private lazy var taskIllustrationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: AssetsConstants.taskIllustration))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientBackground()
        setupNavigationBar()
        addSubviews()
        setupConstraints()
    }
    
   
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func addSubviews() {
        view.addSubview(taskIllustrationImageView)
        view.addSubview(tasksTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskIllustrationImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskIllustrationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tasksTableView.topAnchor.constraint(equalTo: taskIllustrationImageView.bottomAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func didTapCompleteTaskButton(_ sender: UIButton) {
        guard let cell = sender.superview as? UITableViewCell else {return}
        guard let indexPath = tasksTableView.indexPath(for: cell) else {return}
        TaskRepository.shared.completeTask(at: indexPath.row)
        tasksTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskRepository.shared.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell()
        cell.selectionStyle = .none
        var content = cell.defaultContentConfiguration()
        content.text = TaskRepository.shared.tasks[indexPath.row].title
        content.secondaryText = TaskRepository.shared.tasks[indexPath.row].description ?? ""
        cell.contentConfiguration = content
        cell.accessoryView = createTaskCheckmarkButton(task: TaskRepository.shared.tasks[indexPath.row])
        return cell
    }
    
    private func createTaskCheckmarkButton(task: Task) -> UIButton {
        let completeButton = UIButton()
        completeButton.addTarget(self, action: #selector(didTapCompleteTaskButton), for: .touchUpInside)
        let symbolName = task.isCompleted ? "checkmark.circle.fill" : "checkmark.circle"
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0)
        let image = UIImage(systemName: symbolName, withConfiguration: configuration)
        completeButton.setImage(image, for: .normal)
        completeButton.frame = .init(x: 0, y: 0, width: 24, height: 24)
        return completeButton
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TaskRepository.shared.removeTask(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension TasksViewController: TasksTableViewHeaderDelegate {
    func didTapAddTaskButton() {
       let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        navigationController?.present(addTaskVC, animated: true)
    }
}

extension TasksViewController: TaskDelegate {
    func didAddTask(newTask: Task) {
        TaskRepository.shared.addTask(newTask: newTask)
      tasksTableView.reloadData()
    }
}
