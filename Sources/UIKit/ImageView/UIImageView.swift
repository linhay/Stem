// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if canImport(UIKit)
import UIKit

// MARK: - UILabel 函数扩展
public extension Stem where Base: UIImageView {
    
    /// 异步解码
    ///
    /// - Parameter image: 待解码图片
    @discardableResult
    func setImage(async image: UIImage) -> Stem<Base> {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.base.image = image
            }
        }
        return self
    }
    
    /// 从网络上下载图片
    ///
    /// - Parameters:
    ///   - url: url
    ///   - contentMode: 内容模式
    ///   - placeholder: 占位图片
    ///   - completionHandler: 完成回调
    @discardableResult
    func download(from url: URL,
                  contentMode: UIView.ContentMode = .scaleAspectFit,
                  placeholder: UIImage? = nil,
                  completionHandler: ((UIImage?) -> Void)? = nil) -> Stem<Base> {
        
        base.image = placeholder
        base.contentMode = contentMode

        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType,
                mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async {
                self.base.image = image
                completionHandler?(image)
            }
        }.resume()

        return self
    }

    /// 毛玻璃效果
    ///
    /// - Parameter style: 毛玻璃样式
    @discardableResult
    func blur(withStyle style: UIBlurEffect.Style = .light) -> Stem<Base> {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = base.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        base.addSubview(blurEffectView)
        base.clipsToBounds = true
        return self
    }

    /// 毛玻璃效果
    ///
    /// - Parameter style: 毛玻璃样式
    func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        blur(withStyle: style)
        return base
    }
    
}
#endif
