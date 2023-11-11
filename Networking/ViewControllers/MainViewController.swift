//
//  MainViewController.swift
//  Networking
//
//  Created by Alexey Efimov on 21/08/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import UIKit

enum Link {
    case imageURL
    case courseURL
    case coursesURL
    case aboutUsURL
    case aboutUsURL2
    
    var url: URL {
        switch self {
        case .imageURL:
            return URL(string: "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg")!
        case .courseURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_course")!
        case .coursesURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_courses")!
        case .aboutUsURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_website_description")!
        case .aboutUsURL2:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields")!
        }
    }
}

enum UserAction: CaseIterable {
    case showImage
    case fetchCourse
    case fetchCourses
    case aboutSwiftBook
    case aboutSwiftBook2
    case showCourses
    
    var title: String {
        switch self {
        case .showImage:
            return "Show Image"
        case .fetchCourse:
            return "Fetch Course"
        case .fetchCourses:
            return "Fetch Courses"
        case .aboutSwiftBook:
            return "About SwiftBook"
        case .aboutSwiftBook2:
            return "About SwiftBook 2"
        case .showCourses:
            return "Show Courses"
        }
    }
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see the results in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

final class MainViewController: UICollectionViewController {
    
    private let userActions = UserAction.allCases
    
    // MARK: - Private Methods
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}

// MARK: UICollectionViewDataSource
extension MainViewController {
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath) as? UserActionCell else { return UICollectionViewCell() }
        
        cell.userActionLabel.text = userActions[indexPath.item].title
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .showImage:
            performSegue(withIdentifier: "showImage", sender: nil)
        case .fetchCourse:
            fetchCourse()
        case .fetchCourses:
            fetchCourses()
        case .aboutSwiftBook:
            fetchInfoAboutUs()
        case .aboutSwiftBook2:
            fetchInfoAboutUsWithEmptyFields()
        case .showCourses:
            performSegue(withIdentifier: "showCourses", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
        
    }
}

// MARK: - Networking
extension MainViewController {
    private func fetchCourse() {
        URLSession.shared.dataTask(with: Link.courseURL.url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let course = try jsonDecoder.decode(Course.self, from: data)
                print(course)
                self.showAlert(withStatus: .success)
            } catch let error{
                print(error.localizedDescription)
                self.showAlert(withStatus: .failed)
            }
            
        }.resume()
    }
    
    private func fetchCourses() {
        URLSession.shared.dataTask(with: Link.coursesURL.url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let courses = try jsonDecoder.decode([Course].self, from: data)
                print(courses)
                self.showAlert(withStatus: .success)
            } catch let error{
                print(error.localizedDescription)
                self.showAlert(withStatus: .failed)
            }
            
        }.resume()
        
    }
    
    private func fetchInfoAboutUs() {
        URLSession.shared.dataTask(with: Link.aboutUsURL.url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let swiftbookInfo = try jsonDecoder.decode(SwiftbookInfo.self, from: data)
                print(swiftbookInfo)
                self.showAlert(withStatus: .success)
            } catch let error{
                print(error.localizedDescription)
                self.showAlert(withStatus: .failed)
            }
            
        }.resume()
        
    }
    
    private func fetchInfoAboutUsWithEmptyFields() {
        URLSession.shared.dataTask(with: Link.aboutUsURL2.url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let swiftbookInfo = try jsonDecoder.decode(SwiftbookInfo.self, from: data)
                print(swiftbookInfo)
                self.showAlert(withStatus: .success)
            } catch let error{
                print(error.localizedDescription)
                self.showAlert(withStatus: .failed)
            }
            
        }.resume()
        
    }
}
