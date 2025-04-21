//
//  SwiftUIView.swift
//  Meal Plan
//
//  Created by Jack Guenther on 3/10/25.
//
import SwiftUI

struct SwiftUIView: View {
    @Binding var selectedMeal: Meal
    
    var body: some View {
        VStack(spacing: 20) {
            Image(selectedMeal.image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(15)
            
            Text(selectedMeal.name)
                .font(.largeTitle)
                .bold()
            
            Text("Category: \(selectedMeal.category)")
                .font(.title2)
                .foregroundColor(.gray)
            
            Text(selectedMeal.description)
                .font(.body)
                .padding()
                .multilineTextAlignment(.center)
                
            Button(action: {
                selectedMeal.isFavorite.toggle()
                saveMeals(mealsToBeSaved: [selectedMeal])
            }) {
                HStack {
                    Image(systemName: selectedMeal.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(selectedMeal.isFavorite ? .red : .gray)
                    Text(selectedMeal.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        }
        .padding()
    }
}
