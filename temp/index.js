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
            single.availability  = filter.getElementsByClassName("para availability-item")[0].innerText.replace("\n","").replace("\n","")
            single.discussion  = ''
            if (filter.getElementsByClassName("discussion")[0]) {
                single.discussion  += '/**'
                for (const row of filter.getElementsByClassName("discussion")[0].innerText.split('\n')) {
                    if (row == '' || row == '  ') {
                        continue
                    }
                    single.discussion += '\n' + row
                }
                single.discussion  += '\n*/'
            }


            let parameters = []
            console.log(' -',single.name, " : ", single.availability)

            let parametersNode = filter.getElementsByClassName("parameters")[0] 

            if (parametersNode) {
                for (const parameter of parametersNode.getElementsByTagName("tr")) {
                    let parm = {}
                    let td = parameter.getElementsByTagName("td")
                    let veriable

                    veriable = td[0].getElementsByClassName("term")[0]
                    if (veriable) {
                        parm.key = veriable.innerText
                        let sort_key = veriable.innerText.replace('input','')
                        sort_key = sort_key.slice(0,1).toLowerCase() + sort_key.slice(1,sort_key.length)
                        parm.sort_key = sort_key
                    }

                    veriable = td[1]
                    if (veriable) {
                        parm.decs = ''
                        for (const row of veriable.innerText.split('\n')) {
                            if (row == '' || row == '  ') {
                                continue
                            }
                            parm.decs += '\n///' + row
                        }
                    }

                    veriable = undefined
                    for (const node of td[1].getElementsByClassName("code-voice")) {
                        let type = node.innerText
                        if (type == 'NSNumber' || type == 'CIVector' || type == 'CGColorSpaceRef' || type == 'NSData' || type == 'CIImage' || type == 'CIColor' || type == 'NSString') {
                            veriable = type
                            break
                        }
                    }

                    if (veriable) {
                        parm.type = veriable
                        if (parm.type == 'CGColorSpaceRef') {
                            parm.type = 'CGColorSpace'
                        } else if (parm.type == 'NSData') {
                            parm.type = 'Data'
                        } else if (parm.type == 'NSString') {
                            parm.type = 'String'
                        }
                    } else {
                        parm.type = 'Any'
                    }

                    veriable = td[1].getElementsByClassName("para")[1]
                    if (veriable) {
                        parm.default_value_desc = veriable.innerText
                        parm.default_value = veriable.getElementsByClassName("code-voice")[0]
                        if (parm.default_value) {
                            parm.default_value = parm.default_value.innerText
                        } else {
                            parm.default_value = deal_default_value(parm.default_value_desc) 
                        }
                        
                    }

                    console.log('  -|', parm.key, ' - ', parm.type, ' - ', parm.default_value, ' : ', parm.decs)
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


function toswift(sections) {

    let str = 'import UIKit\n'
    for (const section of sections) {
        str += 'extension CIFilter {' + '\n'
        str += 'convenience init(' + section.name + ' type: ' + section.sort_type + ') {\n'
        str += 'self.init(name: type.rawValue)!\n'
        str += '}\n'
    
        str += 'enum ' + section.sort_type + ': String {\n' 
    
        for (const filter of section.filters) {
            str += '///' + filter.availability + '\n'
            str += 'case ' + filter.name + ' = ' + '"' + filter.type + '"\n' 
        }
        str += ' }\n'
        str += '}\n'

        str += 'extension CIFilter.' + section.sort_type + ' {\n'

        for (const filter of section.filters) {
            str += filter.discussion + '\n'
            str += '///' + filter.availability + '\n'
            str += 'public struct ' + filter.sort_type + ': CIFilterContainerProtocol {\n'
            str += 'public var filter: CIFilter = CIFilter(' + section.name +  ': .' + filter.name + ')\n'
            
            if (filter.parameters.length != 0) {
                for (const parameter of filter.parameters) {
                    str += parameter.decs + '\n'
                    str += '@CIFilterValueBox var ' + parameter.sort_key + ': ' + parameter.type
                    if (!parameter.default_value) {
                        str += '?'
                    }
                    str += '\n'
                }
            
                str += 'init() {\n'
                for (const parameter of filter.parameters) {
                    str += '_' + parameter.sort_key + '.cofig(filter: filter, name: "' + parameter.key + '", default: '
                    if (parameter.default_value) {
                        if (parameter.type == 'NSNumber') {
                            str += parameter.default_value
                        } else if (parameter.type == 'CIVector') {
                            str += '.init(string: "' + parameter.default_value + '")'
                        } else if (parameter.type == 'String') {
                            str += '"' + parameter.default_value + '"'
                        }
                    } else {
                        str += 'nil'
                    }
                    str += ')\n'
                }
                str += ' }\n'
            }

            str += '}\n'
        }

        str += '}\n'
    }
    console.log(str)
}
    
toswift(get_sections())
