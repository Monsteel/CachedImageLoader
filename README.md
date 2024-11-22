# CachedImageLoader

#### E-Tag기반으로 이미지를 캐싱할 수 있습니다.

[There is also an explanation in English.](https://github.com/Monsteel/CachedImageLoader/tree/main/README_EN.md)

💁🏻‍♂️ 순수한 Swift를 사용하여 구현되었습니다.<br>
💁🏻‍♂️ E-Tag를 기반으로 하여 이미지를 캐싱합니다.<br>
💁🏻‍♂️ UI의존성 없이 캐싱된 이미지를 가져올 수 있습니다.<br>

## 장점

✅ E-Tag를 Base로 캐싱되어 URL은 그대로이지만 이미지가 변경된 경우 새로운 이미지로 업데이트 합니다.<br>
✅ UI와 의존성이 없어, SwiftUI, UIKit 모두에서 자유롭게 사용할 수 있습니다.<br>
✅ 메모리 캐싱은 기본적으로 제공되며, 디스크 캐싱은 필요에 따라 On/Off할 수 있습니다.<br>

## 사용방법

간단한 코드로, 캐싱된 이미지를 불러올 수 있습니다.<br>

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

간단한 코드로, 캐싱된 데이터를 제거할 수 있습니다.<br>

```swift
import SwiftUI
import CachedImageLoader

public struct DummyView: View {
  private let imageLoader = CachedImageLoader.default

  public var body: some View {
    // State를 Binding합니다.
    Button("clear Cache") {
      Task {
        await imageLoader.clearCache()
      }
    }
  }
}
```

SwiftUI를 위해 구현된 `CachedAsyncImage` 를 사용할 수 있습니다.<br>

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

## Swift Package Manager(SPM) 을 통해 사용할 수 있어요

```swift
dependencies: [
  .package(url: "https://github.com/Monsteel/CachedImageLoader.git", .upToNextMajor(from: "0.0.1"))
]
```

## 사용하고 있는 곳.

| 회사                                                                                                    | 설명                                                                                                                                                                                                                                   |
| ------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/ddca8614-c940-425c-a0d1-6a0e8f9d2458" height="50"> | SwiftUI와 UIKit을 사용하여 개발된 [정육각 커머스 앱](https://apps.apple.com/kr/app/%EC%A0%95%EC%9C%A1%EA%B0%81-%EC%96%B8%EC%A0%9C%EB%82%98-%EC%B4%88%EC%8B%A0%EC%84%A0/id1490984523)에서 이미지 로딩을 위해 사용하고 있습니다.         |
| <img src="https://github.com/user-attachments/assets/f699bbbe-16ff-4c33-a4de-0dadd9d836e6" height="50"> | SwiftUI를 사용하여 개발된 [초록마을 커머스 앱](https://apps.apple.com/kr/app/%EC%B4%88%EB%A1%9D%EB%A7%88%EC%9D%84-%EC%B9%9C%ED%99%98%EA%B2%BD-%EC%9C%A0%EA%B8%B0%EB%86%8D-no-1/id1144455477)에서 이미지 로딩을 위해 사용하고 있습니다. |

## 함께 만들어 나가요

개선의 여지가 있는 모든 것들에 대해 열려있습니다.<br>
PullRequest를 통해 기여해주세요. 🙏

## License

CachedImageLoader 는 MIT 라이선스로 이용할 수 있습니다. 자세한 내용은 [라이선스](https://github.com/Monsteel/CachedImageLoader/tree/main/LICENSE) 파일을 참조해 주세요.<br>
CachedImageLoader is available under the MIT license. See the [LICENSE](https://github.com/Monsteel/CachedImageLoader/tree/main/LICENSE) file for more info.

## Auther

이영은(Tony) | dev.e0eun@gmail.com

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FMonsteel%2FCachedImageLoader&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
