//
//  LocationExtensions.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 02/03/24.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
           let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
           let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
           return location1.distance(from: location2)
       }
}
