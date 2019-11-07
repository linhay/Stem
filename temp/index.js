// https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIDiscBlur
function deal_default_value(str) {
    let default_value = 'Default value: '
    let start_index = str.indexOf(default_value)
    if (start_index == -1) {
        return ''
    }
    start_index = start_index + default_value.length

    let end_index_1 = str.indexOf(' Identity')
    let end_index_2 = str.indexOf(' Minimum')

    let end_index = Math.min(end_index_1,end_index_2) > 0 ? Math.min(end_index_1,end_index_2) : Math.max(end_index_1,end_index_2)
    return str.slice(start_index, end_index)
}

function get_sections() {
    let sections = []
    for (const group of window.document.getElementsByClassName("task-group")) {
        let section = {}
        section.filters = []
        section.type = group.getElementsByClassName("section-name")[0].innerText
        section.sort_type = section.type.replace('CICategory', '')
        section.name = section.sort_type.slice(0,1).toLowerCase() + section.sort_type.slice(1,section.sort_type.length)
        console.log(section.name)

        for (const filter of group.getElementsByClassName("item symbol obj-c-only")) {
            let single = {}
            single.type  = filter.getElementsByClassName("filter Objective-C")[0].innerText.replace(" ","")
            single.sort_type = single.type.replace('CI', '')
            single.name = single.sort_type.slice(0,1).toLowerCase() + single.sort_type.slice(1,single.sort_type.length)
            
            let parameters = []
            console.log(' -',single.name)

            let parametersNode = filter.getElementsByClassName("parameters")[0] 
            if (parametersNode != undefined) {
                for (const parameter of parametersNode.getElementsByTagName("tr")) {
                    let parm = {}
                    let td = parameter.getElementsByTagName("td")
                    let veriable

                    veriable = td[0].getElementsByClassName("term")[0]
                    if (veriable) {
                        parm.key = veriable.innerText
                    }

                    veriable = td[1].getElementsByClassName("para")[0]
                    if (veriable) {
                        parm.decs = veriable.innerText
                    }

                    veriable = td[1].getElementsByClassName("code-voice")[0]
                    if (veriable) {
                        parm.type = veriable.innerText
                    }

                    veriable = td[1].getElementsByClassName("para")[1]
                    if (veriable) {
                        parm.default_value_desc = veriable.innerText
                        parm.default_value = deal_default_value(parm.default_value_desc)  
                    }

                    console.log('  -|', parm.key, ' - ', parm.type, ' - ', parm.default_value)
                    parameters.push(parm)
                }
            }

    
            single.parameters = parameters
            section.filters.push(single)
        }
    
        sections.push(section)
    }

    return sections
}


function toswift(section) {
    let str = 'extension CIFilter {' + '\n'
    section_type = section.name.replace("CICategory")
    section_name = section_type.slice(0,0).toLowerCase() + section_type.slice(1,section_type.length - 1)

    str += 'convenience init(' + section_name + ' type: ' + section_type + ') {\n'
    str += 'self.init(name: type.rawValue)!\n'
    str += '}\n'

    str += 'enum ' + section_type + ': String {\n' 

    let filters = section.filters

    for (const filter of filters) {
        filter.case_name = filter.name
        str += 'case ' + section_type + ': String {\n' 
    }
            @available(iOS 9.0, *)
            case boxBlur            = "CIBoxBlur"
            @available(iOS 9.0, *)
            case discBlur           = "CIDiscBlur"
            case gaussianBlur       = "CIGaussianBlur"
            @available(OSX 10.10, *)
            case maskedVariableBlur = "CIMaskedVariableBlur"
            @available(iOS 9.0, *)
            case medianFilter       = "CIMedianFilter"
            @available(iOS 9.0, *)
            case motionBlur         = "CIMotionBlur"
            @available(iOS 9.0, *)
            case noiseReduction     = "CINoiseReduction"
            @available(iOS 9.0, *)
            case zoomReduction     = "CIZoomBlur"
        }
        
    }'
}
