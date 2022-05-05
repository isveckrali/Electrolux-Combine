//
//  CustomAlertView.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 05/05/2022.
//

import SwiftUI

struct CustomAlertView: View {
    
    //MARK: -PROPERTIES
    var alertContent: String = "Donwloaded"
    @Binding var isDownloaded:Bool
    
    //MARK: -FUNCS
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, 10)
                .background(.green)
                .foregroundColor(.white)
                .clipShape(Circle())
            Spacer()
            Text(alertContent)
                .foregroundColor(Color.white)
            Spacer()
            Divider()
            Button("Ok") { // Button title
                self.isDownloaded.toggle()
                // Button action
            }.foregroundColor(.white) // Change the title of button
                .frame(width: screenWidth/2-30, height: 40) // Change the frames of button
        } //: VSTACK
        .frame(width: screenWidth-50, height: 200)
        .background(Color.black.opacity(0.5))
        .cornerRadius(12)
        .clipped()
    }
}

//MARK: -PREVIEW
struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(isDownloaded: .constant(true))
    }
}
