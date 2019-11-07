https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIDiscBlur
let groups = window.document.getElementsByClassName("task-group")
let item = groups[0]
let section_name = item.getElementsByClassName("section-name")[0].innerText
let fliters = item.getElementsByClassName("item symbol obj-c-only")

let fliter = fliters[0]
fliter.display_name = fliter.getElementsByClassName("display-name")[0].getElementsByTagName("p")[0].innerText.replace(" ","")
fliter.



//*[@id="s0"]/div[2]/section/div[3]/p
