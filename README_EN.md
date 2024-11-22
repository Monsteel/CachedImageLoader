# CachedImageLoader

#### Caching images based on E-Tag.

💁🏻‍♂️ Implemented in pure Swift.<br>
💁🏻‍♂️ Caches images based on E-Tag.<br>
💁🏻‍♂️ Retrieve cached images without UI dependency.<br>

## Advantages

✅ Cached based on E-Tag, so the URL remains the same, but if the image changes, it updates with the new image.<br>
✅ No UI dependency, allowing free use in both SwiftUI and UIKit.<br>
✅ Provides memory caching by default, with optional disk caching that can be toggled on or off.<br>

## Usage

You can load cached images with simple code.<br>

```swift
import SwiftUI
import CachedImageLoader

public struct DummyView: View {
  private let imageLoader = CachedImageLoader.default
  @State var image: UIImage? = nil

  public var body: some View {
    Image(uiImage: image)
      .task {
        guard let data = try? await imageLoader.load(urls.randomElement()) else { return }
        self.image = UIImage(data: data)
      }
  }
}
```

You can also easily clear cached data

```swift
import SwiftUI
import CachedImageLoader

public struct DummyView: View {
  private let imageLoader = CachedImageLoader.default

  public var body: some View {
    // Binding the state.
    Button("clear Cache") {
      Task {
        await imageLoader.clearCache()
      }
    }
  }
}
```

You can use `CachedAsyncImage` implemented for SwiftUI.<br>

```swift
import SwiftUI
import CachedAsyncImage

struct SampleView: View {
  let url: URL
  var body: some View {
    CachedAsyncImage(url: url, imageLoader: .default) { image in
      image
        .resizable()
        .scaledToFit()
        .frame(width: 100)
    } placeholder: {
      ProgressView()
    }
  }
}
```

## Swift Package Manager (SPM) Installation

```swift
dependencies: [
  .package(url: "https://github.com/Monsteel/CachedImageLoader.git", .upToNextMajor(from: "0.0.1"))
]
```

## Currently in Use

| Company                                                                                                 | Description                                                                                                                                                                                                                                                                                                                                       |
| ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/ddca8614-c940-425c-a0d1-6a0e8f9d2458" height="50"> | Utilized in the [Jeongyookgak Commerce App](https://apps.apple.com/kr/app/%EC%A0%95%EC%9C%A1%EA%B0%81-%EC%96%B8%EC%A0%9C%EB%82%98-%EC%B4%88%EC%8B%A0%EC%84%A0/id1490984523?l=en-GB), developed based on UIKit.<br> Currently integrating SwiftUI components with the goal of transitioning entirely to SwiftUI and introducing TCA in the future. |
| <img src="https://github.com/user-attachments/assets/f699bbbe-16ff-4c33-a4de-0dadd9d836e6" height="50"> | Used for image loading in the [Chorocmaeul Commerce App](https://apps.apple.com/kr/app/%EC%B4%88%EB%A1%9D%EB%A7%88%EC%9D%84-%EC%B9%9C%ED%99%98%EA%B2%BD-%EC%9C%A0%EA%B8%B0%EB%86%8D-no-1/id1144455477) developed with SwiftUI.                                                                                                                    |

## Let's Build Together

I'm open to contributions and improvements for anything that can be enhanced.
Feel free to contribute through Pull Requests. 🙏

## License

CachedImageLoader is available under the MIT license. See the [LICENSE](https://github.com/Monsteel/ReactorViewStore/tree/main/LICENSE) file for more info.

## Auther

Youngeun Lee(Tony) | dev.e0eun@gmail.com

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FMonsteel%2FCachedImageLoader&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
