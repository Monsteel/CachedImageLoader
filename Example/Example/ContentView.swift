//
//  ContentView.swift
//  Example
//
//  Created by Tony on 10/11/24.
//

import SwiftUI
import CachedImageLoader

struct ContentView: View {
  private let imageLoader = CachedImageLoader.shared
  
  @State var image: UIImage? = nil
  @State var loading: Bool = false
  
  public var body: some View {
    VStack(spacing: 24) {
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding(.horizontal, 24)
          .overlay {
            if loading {
              Rectangle()
                .foregroundStyle(Color.white)
              ProgressView()
            }
          }
      }
      
      HStack(spacing: 16) {
        Button("load") {
          self.loadImage()
        }
        .disabled(self.loading)
        
        Button("clear Cache") {
          self.clearCache()
        }
        .disabled(self.loading)
        .foregroundStyle(Color.red)
      }
      

    }
    .onAppear {
      self.loadImage()
    }
  }
}


extension ContentView {
  private func loadImage() {
    let urls: [URL] = [
      .init(string: "https://sajygdev.blob.core.windows.net/$web/standard_assets/s3/jyg-custom-seoul-app/frontend/thumbnails/transparent_background/beefsirloin-monep-detail.png")!,
      .init(string: "https://sajygdev.blob.core.windows.net/$web/standard_assets/s3/jyg-custom-seoul-app/frontend/thumbnails/transparent_background/porkbelly-fresh-detail.png")!,
      .init(string: "https://sajygdev.blob.core.windows.net/$web/standard_assets/s3/jyg-custom-seoul-app/frontend/thumbnails/transparent_background/porkneck-fresh-detail.png")!,
      .init(string: "https://sajygdev.blob.core.windows.net/$web/standard_assets/s3/jyg-custom-seoul-app/frontend/thumbnails/transparent_background/chickef-cut-detail.png")!,
      .init(string: "https://sajygdev.blob.core.windows.net/$web/standard_assets/commerce/goods_thumbnails/beefsirloinsteak-monep/list_thumbnails/beefsirloinsteak-monep.png")!,
      .init(string: "https://sajygdev.blob.core.windows.net/$web/standard_assets/commerce/goods_thumbnails/beeftendersteak-bonep/list_thumbnails/beeftendersteak-bonep.png")!,
    ]
    
    self.loading = true
    Task {
      guard let data = try? await imageLoader.load(urls.randomElement()) else { return }
      self.image = UIImage(data: data)
      self.loading = false
    }
  }
  
  private func clearCache() {
    Task {
      try await imageLoader.clearCache()
    }
  }
}
