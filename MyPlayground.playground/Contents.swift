import Foundation

var greeting = "Hello, playground"

struct Restaurant {
    
}

//Singleton classes
final class RestaurantManager {
    @MainActor static let shared = RestaurantManager()
    
    
    private(set) var cachedRestaurants: [Restaurant] = []
    
    private var timeStamp: Date?
    
    private init() {}
    
    func getData(_ completion: @escaping([Restaurant]) -> Void)  {
        if let _ = timeStamp {
            print("Returning Cached Restaurants")
            completion(cachedRestaurants)
        } else {
            fetchDataFromServer(completion)
        }
    }
    
    private func fetchDataFromServer(_ completion: @escaping([Restaurant]) -> Void) {
        self.timeStamp = Date()
        print("Returning From Server")
        completion([])
    }
}

RestaurantManager.shared.getData { _ in
    print("Received items")
}

RestaurantManager.shared.getData { _ in
    print("Received items")
}
