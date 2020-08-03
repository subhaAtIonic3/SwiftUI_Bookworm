//
//  AddBookView.swift
//  Bookworm_2
//
//  Created by Subhrajyoti Chakraborty on 02/08/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var showAlert = false
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        if self.genre.count == 0 {
                            self.showAlert = true
                            return
                        } else {
                            let bookData = Book(context: self.moc)
                            bookData.title = self.title
                            bookData.author = self.author
                            bookData.genre = self.genre
                            bookData.rating = Int16(self.rating)
                            bookData.review = self.review
                            bookData.date = Date()
                            
                            try? self.moc.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error!"), message: Text("Please select the genre"), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
