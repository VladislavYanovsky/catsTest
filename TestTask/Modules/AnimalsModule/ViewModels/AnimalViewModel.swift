//
//  AnimalViewModel.swift
//  TestTask
//
//  Created by Vladislav on 1.09.23.
//

import Foundation
import UIKit

class AnimalViewModel: NSObject {
    
    private let requestManager: RequestManagerProtocol
    var reloadCollectionView: (() -> Void)?
    private var animals = Animals()
    private var imageUrls = [String]()
    private var imageParameters: QueryStringParameters = ["limit":"10",  "api_key" : "live_9U2GmakPWHQ276ZKub6ZTLrLcOKrD1P4n6cqkqBKqAynmQTJyscC6XgDMSNsRybR"]
    private var breedParameters: QueryStringParameters = ["limit":"10", "page": "0", "api_key" : "live_9U2GmakPWHQ276ZKub6ZTLrLcOKrD1P4n6cqkqBKqAynmQTJyscC6XgDMSNsRybR"]
    
    var animalCellViewModels = [AnimalCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getAnimals() {
        print("FIRST TASK gets all breeds")
        requestManager.makeRequest(
            reqestParameters: RequestParams(
                baseURL: "https://api.thecatapi.com/v1",
                queryStringData: self.breedParameters,
                endpoint: "breeds"),
            type: [Animal].self) { result in
                switch result {
                case .success (let data):
                    print("1st REQUEST COMPLETE got all breeds")
                    let referenceImageIds = data
                        .map{ $0.referenceImageId }
                        .compactMap{$0}
                    
                    self.fetchImagesUrlsFrom(ids: referenceImageIds) {
                        self.fetchData(animals: data)
                    }
                    
                case .failure (let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func fetchImagesUrlsFrom(ids: [String], completion: @escaping(() -> Void)) {
        for id in ids {
            let reqestParameters = RequestParams(
                baseURL: "https://api.thecatapi.com/v1/",
                endpoint: "images",
                subPath: id)
            
            requestManager.makeRequest(
                reqestParameters: reqestParameters,
                type: ImageResponseData.self) { result in
                    switch result {
                    case .success (let data):
                        
                        self.imageUrls.append(data.url.absoluteString)
                        if self.imageUrls.count >= 10 {
                            completion()
                        }
                        
                    case .failure (let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    private func fetchData(animals: Animals) {
        self.animals = animals
        var viewModels = [AnimalCellViewModel]()
        for animal in animals {
            if let firstUrl = imageUrls.first {
                viewModels.append(createCellModel(animal: animal, url: firstUrl))
                imageUrls.removeFirst()
            }
        }
        animalCellViewModels = viewModels
    }
    
    private func createCellModel(animal: Animal, url: String) -> AnimalCellViewModel {
        let id = animal.id
        let breed = animal.name
        let wikiUrl = animal.wikipediaURL ?? ""
        let imageUrl = url
        return AnimalCellViewModel(id: id, breed: breed, imageUrl: imageUrl, wikipediaURL: wikiUrl)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> AnimalCellViewModel {
        return animalCellViewModels[indexPath.row]
    }
    
    private func animalsInfoViewModel(for index: Int) -> AnimalsInfoViewModel {
        return AnimalsInfoViewModel(animal: animals[index])
    }
    
    func presentAnimalInfo(at indexPath: IndexPath, navController: UINavigationController?) {
        let animalsInfoViewModel = animalsInfoViewModel(for: indexPath.row)
        let animalInfoViewController = AnimalsInfoViewController()
        animalInfoViewController.viewModel = animalsInfoViewModel
        navController?.pushViewController(animalInfoViewController, animated: true)
    }
}
