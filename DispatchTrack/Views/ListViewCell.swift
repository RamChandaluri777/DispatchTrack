//
//  ListViewCell.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 02/03/24.
//

import SwiftUI

struct ListViewCell: View {
    var item: Dispatch
    var listViewCell: some View {
        
            VStack(alignment: .leading) {
                Text(item.dispatchGuide?.code ?? "0")
                    .font(.body)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity,alignment: .leading)
                HStack(spacing: 8) {
                    Text("Delivery")
                        .foregroundStyle(.blue)
                        .font(.callout)
                    Divider().frame(height: 10)
                }
                Text(item.dispatchGuide?.address?.name ?? "location not found")
                    .foregroundStyle(.separator)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }.frame(maxWidth: .infinity)
            
        
    }
    var body: some View {
        VStack(alignment: .leading) {
            listViewCell
                .padding()
                .background(.white)
                .cornerRadius(8.0)
                .shadow(radius: 8)
                
        }
        
    }
}

//#Preview {
//    ListViewCell(item: Dispatch(id: 0, statusCode: 0, dispatchSubStatusId: 0, estimatedAt: "Time", slot: 0, isTrunk: false, isPickup: true, destinationId: 0, canManageDispatch: false, dispatchGuide: <#T##DispatchGuide#>))
//}
