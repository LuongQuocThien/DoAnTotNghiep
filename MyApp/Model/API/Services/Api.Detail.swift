//
//  Api.Detail.swift
//  MyApp
//
//  Created by PCI0010 on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import Firebase

extension Api.Venue {

    static func getDetailVenue(id: String, completion: @escaping Completion<Restaurant>) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/venue")
        ref.queryOrdered(byChild: "id").queryEqual(toValue: id)
            .observe(.value, with: { (snapshot) in
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let restaurant = Mapper<Restaurant>().mapArray(JSONArray: items).first ?? Restaurant()
                completion(.success(restaurant))
            }) { (error) in
                completion(.failure(error))
        }
    }

    struct DetailComment {
        var id = ""
        let offset: Int
        let limit = 10

        var toJSON: Parameters {
            return [
                "limit": limit,
                "offset": offset]
        }
    }

    static func getComment(venueId: String, limits: Int, completion: @escaping Completion<[Comment]>) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/comment")
        ref.queryOrdered(byChild: "venueId").queryEqual(toValue: venueId).queryLimited(toLast: UInt(limits))
            .observe(.value, with: { (snapshot) in
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let comments = Mapper<Comment>().mapArray(JSONArray: items)
                completion(.success(comments))
            }) { (error) in
                completion(.failure(error))
        }
    }

    @discardableResult
    static func getPhoto(id: String, completion: @escaping Completion<[Photo]>) -> Request? {
        let url = Api.Path.Venue(id: id).photos
        return api.request(method: .get, urlString: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    guard let json = value as? JSObject, let response = json["response"] as? JSObject,
                        let photos = response["photos"] as? JSObject,
                        let group = (photos["groups"] as? JSArray)?.first,
                        let itemsJS = group["items"] as? JSArray else {
                        completion(.failure(Api.Error.json))
                        return
                    }
                    Mapper<Photo>().mapArray(array: itemsJS) { photos in
                        completion(.success(photos))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
