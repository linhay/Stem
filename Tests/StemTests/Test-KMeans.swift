//
//  File.swift
//  
//
//  Created by linhey on 2021/11/18.
//

import Foundation
import XCTest
import Stem

class KMeansTests: XCTestCase {
    
    func test2() {
        let rgb = StemColor.RGBSpace(SIMD3<Double>(0.48235294, 0.14509805, 0.93333334))
        let linear = rgb.linear
        let xyz: StemColor.CIEXYZSpace = StemColor.spaceCalculator.convert(linear, illuminants: .D65)
        let lab: StemColor.CIELABSpace = StemColor.spaceCalculator.convert(xyz)
        print(lab)
    }
    
    func test() {
        let points: [SIMD3<Double>] = [
            .init(0.48235294, 0.14509805, 0.93333334),
            .init(0.45490196, 0.09803922, 0.92156863),
            .init(0.50980395, 0.18039216, 0.95686275),
            .init(0.52156866, 0.20392157, 0.9529412),
            .init(0.5058824, 0.17254902, 0.95686275),
            .init(0.44705883, 0.09411765, 0.9137255),
            .init(0.43529412, 0.09019608, 0.8901961),
            .init(0.46666667, 0.105882354, 0.9529412),
            .init(0.46666667, 0.105882354, 0.9490196),
            .init(0.5058824, 0.18039216, 0.9490196),
            .init(0.5176471, 0.2, 0.9490196),
            .init(0.5019608, 0.17254902, 0.9490196),
            .init(0.46666667, 0.105882354, 0.9490196),
            .init(0.46666667, 0.105882354, 0.9529412),
            .init(0.46666667, 0.101960786, 0.9529412),
            .init(0.46666667, 0.105882354, 0.9529412),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.5019608, 0.1764706, 0.9490196),
            .init(0.5176471, 0.2, 0.9490196),
            .init(0.5019608, 0.17254902, 0.9490196),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.4627451, 0.105882354, 0.9490196),
            .init(0.46666667, 0.105882354, 0.9529412),
            .init(0.46666667, 0.101960786, 0.9490196),
            .init(0.47058824, 0.11372549, 0.9411765),
            .init(0.45490196, 0.09411765, 0.972549),
            .init(0.44313726, 0.08627451, 0.98039216),
            .init(0.4392157, 0.101960786, 0.9607843),
            .init(0.4392157, 0.078431375, 0.94509804),
            .init(0.4392157, 0.101960786, 0.95686275),
            .init(0.48235294, 0.16078432, 0.98039216),
            .init(0.5019608, 0.18431373, 0.9843137),
            .init(0.47843137, 0.16078432, 0.9764706),
            .init(0.4392157, 0.09411765, 0.9529412),
            .init(0.4392157, 0.08235294, 0.94509804),
            .init(0.4392157, 0.101960786, 0.96862745),
            .init(0.44705883, 0.08627451, 0.98039216),
            .init(0.45490196, 0.09411765, 0.9764706),
            .init(0.46666667, 0.10980392, 0.9372549),
            .init(0.47843137, 0.14117648, 0.92156863),
            .init(0.5176471, 0.19607843, 0.95686275),
            .init(0.4862745, 0.14901961, 0.9607843),
            .init(0.5686275, 0.20784314, 0.75686276),
            .init(0.63529414, 0.27058825, 0.6431373),
            .init(0.6862745, 0.12156863, 0.8117647),
            .init(0.69803923, 0.3764706, 0.9411765),
            .init(0.6784314, 0.11764706, 0.81960785),
            .init(0.65882355, 0.3137255, 0.6627451),
            .init(0.6666667, 0.34117648, 0.6509804),
            .init(0.6627451, 0.25882354, 0.69411767),
            .init(0.6901961, 0.16470589, 0.87058824),
            .init(0.69803923, 0.3372549, 0.93333334),
            .init(0.6745098, 0.13725491, 0.74509805),
            .init(0.6313726, 0.28235295, 0.64705884),
            .init(0.57254905, 0.21176471, 0.7529412),
            .init(0.4862745, 0.14901961, 0.9607843),
            .init(0.5176471, 0.19215687, 0.95686275),
            .init(0.47058824, 0.13725491, 0.9137255),
            .init(0.43529412, 0.09019608, 0.8862745),
            .init(0.47058824, 0.105882354, 0.9529412),
            .init(0.50980395, 0.18431373, 0.9529412),
            .init(0.5176471, 0.2, 0.9490196),
            .init(0.48235294, 0.15686275, 0.98039216),
            .init(0.81960785, 0.44313726, 0.33333334),
            .init(1.0, 0.6627451, 0.0),
            .init(1.0, 0.27058825, 0.34509805),
            .init(1.0, 0.6117647, 0.8901961),
            .init(1.0, 0.34901962, 0.74509805),
            .init(1.0, 0.46666667, 0.1254902),
            .init(1.0, 0.6666667, 0.0),
            .init(1.0, 0.3019608, 0.2901961),
            .init(1.0, 0.5372549, 0.8627451),
            .init(1.0, 0.42745098, 0.7921569),
            .init(1.0, 0.41960785, 0.16862746),
            .init(1.0, 0.65882355, 0.0),
            .init(0.83137256, 0.4509804, 0.31764707),
            .init(0.48235294, 0.15686275, 0.9764706),
            .init(0.5176471, 0.2, 0.9490196),
            .init(0.50980395, 0.18431373, 0.9529412),
            .init(0.47058824, 0.105882354, 0.9529412),
            .init(0.46666667, 0.101960786, 0.9529412),
            .init(0.46666667, 0.105882354, 0.9529412),
            .init(0.4627451, 0.101960786, 0.94509804),
            .init(0.49019608, 0.15686275, 0.9490196),
            .init(0.50980395, 0.19607843, 0.9647059),
            .init(0.47843137, 0.15294118, 1.0),
            .init(0.7254902, 0.44705883, 0.5019608),
            .init(1.0, 0.8352941, 0.0),
            .init(1.0, 0.7058824, 0.07058824),
            .init(1.0, 0.3019608, 0.60784316),
            .init(1.0, 0.6627451, 0.8901961),
            .init(1.0, 0.3019608, 0.3647059),
            .init(1.0, 0.7529412, 0.03529412),
            .init(1.0, 0.23137255, 0.54509807),
            .init(1.0, 0.69803923, 0.90588236),
            .init(1.0, 0.3137255, 0.42745098),
            .init(1.0, 0.80784315, 0.011764706),
            .init(1.0, 0.827451, 0.0),
            .init(0.7372549, 0.45882353, 0.4862745),
            .init(0.4745098, 0.15294118, 1.0),
            .init(0.50980395, 0.19607843, 0.96862745),
            .init(0.49019608, 0.15294118, 0.9529412),
            .init(0.4627451, 0.101960786, 0.94509804),
            .init(0.46666667, 0.105882354, 0.9529412),
            .init(0.46666667, 0.101960786, 0.9490196),
            .init(0.4627451, 0.101960786, 0.93333334),
            .init(0.4627451, 0.105882354, 0.9529412),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.45882353, 0.101960786, 0.9490196),
            .init(0.4862745, 0.13725491, 0.9254902),
            .init(0.5882353, 0.23529412, 0.80784315),
            .init(0.58431375, 0.21568628, 0.81960785),
            .init(0.7254902, 0.42352942, 0.50980395),
            .init(1.0, 0.91764706, 0.14901961),
            .init(1.0, 0.9137255, 0.09411765),
            .init(1.0, 0.41568628, 0.23529412),
            .init(1.0, 0.6039216, 0.8117647),
            .init(1.0, 0.39215687, 0.58431375),
            .init(1.0, 0.36078432, 0.24705882),
            .init(1.0, 0.5254902, 0.7411765),
            .init(1.0, 0.44705883, 0.68235296),
            .init(1.0, 0.62352943, 0.11764706),
            .init(1.0, 0.8862745, 0.007843138),
            .init(1.0, 0.8862745, 0.003921569),
            .init(0.73333335, 0.4392157, 0.5058824),
            .init(0.5803922, 0.21568628, 0.8235294),
            .init(0.5882353, 0.23529412, 0.8039216),
            .init(0.49019608, 0.13725491, 0.91764706),
            .init(0.45882353, 0.101960786, 0.9490196),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.46666667, 0.105882354, 0.9529412),
            .init(0.46666667, 0.09803922, 0.9490196),
            .init(0.45882353, 0.101960786, 0.9254902),
            .init(0.4627451, 0.105882354, 0.9490196),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.44705883, 0.09803922, 0.96862745),
            .init(0.5803922, 0.18039216, 0.7372549),
            .init(0.96862745, 0.43529412, 0.047058824),
            .init(0.8901961, 0.3882353, 0.12156863),
            .init(0.90588236, 0.47058824, 0.09803922),
            .init(0.99607843, 0.84705883, 0.12156863),
            .init(0.99607843, 0.8666667, 0.1254902),
            .init(1.0, 0.7137255, 0.02745098),
            .init(1.0, 0.43137255, 0.52156866),
            .init(1.0, 0.7137255, 0.8745098),
            .init(1.0, 0.4627451, 0.7529412),
            .init(1.0, 0.7137255, 0.89411765),
            .init(1.0, 0.4862745, 0.40784314),
            .init(1.0, 0.8117647, 0.0),
            .init(1.0, 0.81960785, 0.023529412),
            .init(1.0, 0.8156863, 0.023529412),
            .init(0.90588236, 0.48235294, 0.105882354),
            .init(0.8901961, 0.38431373, 0.1254902),
            .init(0.9647059, 0.4392157, 0.043137256),
            .init(0.6156863, 0.20392157, 0.67058825),
            .init(0.44705883, 0.09411765, 0.9764706),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.46666667, 0.105882354, 0.9490196),
            .init(0.45882353, 0.09803922, 0.9372549),
            .init(0.45490196, 0.09803922, 0.9254902),
            .init(0.4627451, 0.105882354, 0.9490196),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.45490196, 0.101960786, 0.9607843),
            .init(0.53333336, 0.15294118, 0.8),
            .init(0.91764706, 0.40784314, 0.09019608),
            .init(0.42745098, 0.16470589, 0.5803922),
            .init(0.42352942, 0.1882353, 0.58431375),
            .init(0.9490196, 0.7411765, 0.09411765),
            .init(1.0, 0.8235294, 0.07058824),
            .init(1.0, 0.8156863, 0.078431375),
            .init(1.0, 0.6392157, 0.7019608),
            .init(1.0, 0.24313726, 0.7372549),
            .init(1.0, 0.16862746, 0.69803923),
            .init(1.0, 0.20784314, 0.7176471),
            .init(1.0, 0.6392157, 0.73333335),
            .init(1.0, 0.81960785, 0.12941177),
            .init(1.0, 0.7882353, 0.007843138),
            .init(0.95686275, 0.7372549, 0.0627451),
            .init(0.43529412, 0.2, 0.5764706),
            .init(0.4, 0.15294118, 0.6117647),
            .init(0.8980392, 0.40392157, 0.08235294),
            .init(0.5254902, 0.16470589, 0.6509804),
            .init(0.4509804, 0.09803922, 0.972549),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.46666667, 0.105882354, 0.9490196),
            .init(0.45882353, 0.09803922, 0.9372549),
            .init(0.47058824, 0.1254902, 0.9254902),
            .init(0.4627451, 0.105882354, 0.9490196),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.4627451, 0.105882354, 0.9529412),
            .init(0.45490196, 0.105882354, 0.9098039),
            .init(0.88235295, 0.38039216, 0.14509805),
            .init(0.5294118, 0.21960784, 0.48235294),
            .init(0.3372549, 0.1254902, 0.6745098),
            .init(0.8784314, 0.63529414, 0.14509805),
            .init(1.0, 0.78039217, 0.003921569),
            .init(1.0, 0.7921569, 0.35686275),
            .init(1.0, 0.3647059, 0.73333335),
            .init(1.0, 0.2627451, 0.6627451),
            .init(1.0, 0.70980394, 0.87058824),
            .init(1.0, 0.3137255, 0.6862745),
            .init(1.0, 0.3019608, 0.7137255),
            .init(1.0, 0.77254903, 0.44313726),
            .init(1.0, 0.7647059, 0.0),
            .init(0.8901961, 0.6431373, 0.13333334),
            .init(0.34901962, 0.13333334, 0.6666667),
            .init(0.48235294, 0.19607843, 0.53333336),
            .init(0.89411765, 0.39215687, 0.09803922),
            .init(0.36862746, 0.09019608, 0.6666667),
            .init(0.4509804, 0.101960786, 0.9372549),
            .init(0.4627451, 0.105882354, 0.9490196),
            .init(0.46666667, 0.10980392, 0.9490196),
            .init(0.47843137, 0.12941177, 0.9411765),
            .init(0.49019608, 0.16078432, 0.92941177),
            .init(0.4745098, 0.1254902, 0.9490196),
            .init(0.4627451, 0.101960786, 0.94509804),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.42745098, 0.09019608, 0.9607843),
            .init(0.74509805, 0.3019608, 0.3019608),
            .init(0.7137255, 0.30980393, 0.28627452),
            .init(0.30588236, 0.101960786, 0.70980394),
            .init(0.7921569, 0.5254902, 0.23137255),
            .init(1.0, 0.7372549, 0.0),
            .init(1.0, 0.7607843, 0.42745098),
            .init(1.0, 0.2784314, 0.61960787),
            .init(1.0, 0.49803922, 0.69803923),
            .init(1.0, 1.0, 1.0),
            .init(1.0, 0.6, 0.7607843),
            .init(1.0, 0.21960784, 0.5803922),
            .init(1.0, 0.7411765, 0.5058824),
            .init(1.0, 0.7411765, 0.0),
            .init(0.8039216, 0.5411765, 0.21568628),
            .init(0.30980393, 0.101960786, 0.7058824),
            .init(0.6627451, 0.28627452, 0.34901962),
            .init(0.78039217, 0.3254902, 0.21176471),
            .init(0.29411766, 0.05490196, 0.6745098),
            .init(0.41960785, 0.09411765, 0.85882354),
            .init(0.46666667, 0.105882354, 0.95686275),
            .init(0.48235294, 0.13725491, 0.9490196),
            .init(0.49411765, 0.16078432, 0.9411765),
            .init(0.49411765, 0.16862746, 0.92941177),
            .init(0.5019608, 0.17254902, 0.9529412),
            .init(0.4627451, 0.101960786, 0.94509804),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.44313726, 0.09411765, 0.96862745),
            .init(0.5529412, 0.19215687, 0.5254902),
            .init(0.8784314, 0.39215687, 0.11372549),
            .init(0.32156864, 0.105882354, 0.69411767),
            .init(0.6862745, 0.41568628, 0.33333334),
            .init(1.0, 0.7019608, 0.0),
            .init(1.0, 0.7411765, 0.23137255),
            .init(1.0, 0.5176471, 0.6666667),
            .init(1.0, 0.27450982, 0.5019608),
            .init(1.0, 0.38431373, 0.5529412),
            .init(1.0, 0.2901961, 0.5058824),
            .init(1.0, 0.4627451, 0.6509804),
            .init(1.0, 0.7490196, 0.30588236),
            .init(1.0, 0.7019608, 0.0),
            .init(0.7058824, 0.43137255, 0.31764707),
            .init(0.30588236, 0.09803922, 0.70980394),
            .init(0.8509804, 0.38039216, 0.15686275),
            .init(0.5764706, 0.21176471, 0.4117647),
            .init(0.2901961, 0.05490196, 0.6745098),
            .init(0.36862746, 0.08235294, 0.75686276),
            .init(0.46666667, 0.10980392, 0.9529412),
            .init(0.50980395, 0.18431373, 0.9529412),
            .init(0.49411765, 0.16078432, 0.9411765),
            .init(0.49411765, 0.16470589, 0.92941177),
            .init(0.5176471, 0.2, 0.9529412),
            .init(0.47843137, 0.12941177, 0.94509804),
            .init(0.4627451, 0.101960786, 0.94509804),
            .init(0.4627451, 0.105882354, 0.95686275),
            .init(0.39215687, 0.09803922, 0.72156864),
            .init(0.89411765, 0.39215687, 0.08627451),
            .init(0.59607846, 0.24313726, 0.41568628),
            .init(0.5803922, 0.3137255, 0.43529412),
            .init(1.0, 0.6666667, 0.007843138),
            .init(1.0, 0.6509804, 0.015686275),
            .init(1.0, 0.7294118, 0.4),
            .init(1.0, 0.57254905, 0.627451),
            .init(1.0, 0.41960785, 0.54509807),
            .init(1.0, 0.54509807, 0.61960787),
            .init(1.0, 0.7254902, 0.45490196),
            .init(1.0, 0.654902, 0.02745098),
            .init(1.0, 0.6666667, 0.007843138),
            .init(0.59607846, 0.3254902, 0.42352942),
            .init(0.54901963, 0.22352941, 0.45882353),
            .init(0.92156863, 0.40784314, 0.07450981),
            .init(0.3764706, 0.101960786, 0.6039216),
            .init(0.3137255, 0.06666667, 0.6627451),
            .init(0.32941177, 0.07058824, 0.6784314),
            .init(0.47058824, 0.14117648, 0.91764706),
            .init(0.52156866, 0.20392157, 0.95686275),
            .init(0.49411765, 0.15686275, 0.9411765),
            .init(0.49019608, 0.16078432, 0.92941177),
            .init(0.5176471, 0.20392157, 0.9529412),
            .init(0.5019608, 0.1764706, 0.9490196),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.46666667, 0.105882354, 0.95686275),
            .init(0.36078432, 0.07450981, 0.79607844),
            .init(0.4862745, 0.16470589, 0.48235294),
            .init(0.8980392, 0.4, 0.105882354),
            .init(0.91764706, 0.43529412, 0.09019608),
            .init(1.0, 0.6156863, 0.015686275),
            .init(1.0, 0.6117647, 0.023529412),
            .init(1.0, 0.6156863, 0.011764706),
            .init(1.0, 0.67058825, 0.16078432),
            .init(1.0, 0.69411767, 0.26666668),
            .init(1.0, 0.6784314, 0.18039216),
            .init(1.0, 0.60784316, 0.003921569),
            .init(1.0, 0.7019608, 0.14509805),
            .init(1.0, 0.72156864, 0.15686275),
            .init(0.9137255, 0.42745098, 0.08627451),
            .init(0.90588236, 0.40392157, 0.09411765),
            .init(0.5294118, 0.1882353, 0.45882353),
            .init(0.3019608, 0.05882353, 0.6784314),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.31764707, 0.07450981, 0.64705884),
            .init(0.44705883, 0.16470589, 0.83137256),
            .init(0.5254902, 0.20392157, 0.9647059),
            .init(0.49019608, 0.14901961, 0.9411765),
            .init(0.46666667, 0.11764706, 0.9254902),
            .init(0.5137255, 0.19607843, 0.9529412),
            .init(0.5176471, 0.2, 0.9490196),
            .init(0.48235294, 0.14117648, 0.94509804),
            .init(0.46666667, 0.101960786, 0.95686275),
            .init(0.39607844, 0.09019608, 0.8117647),
            .init(0.29803923, 0.05882353, 0.6627451),
            .init(0.3882353, 0.13725491, 0.61960787),
            .init(0.4862745, 0.19607843, 0.5254902),
            .init(0.7647059, 0.40784314, 0.25490198),
            .init(1.0, 0.6039216, 0.0),
            .init(1.0, 0.5803922, 0.02745098),
            .init(1.0, 0.57254905, 0.015686275),
            .init(1.0, 0.57254905, 0.003921569),
            .init(1.0, 0.57254905, 0.007843138),
            .init(1.0, 0.59607846, 0.05490196),
            .init(1.0, 0.7411765, 0.19215687),
            .init(0.7764706, 0.44705883, 0.28627452),
            .init(0.49019608, 0.19607843, 0.52156866),
            .init(0.39607844, 0.14509805, 0.60784316),
            .init(0.3019608, 0.05882353, 0.6784314),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.32156864, 0.06666667, 0.65882355),
            .init(0.3372549, 0.101960786, 0.6509804),
            .init(0.39607844, 0.15294118, 0.7294118),
            .init(0.5137255, 0.1882353, 0.95686275),
            .init(0.46666667, 0.105882354, 0.9411765),
            .init(0.45490196, 0.09803922, 0.9254902),
            .init(0.49019608, 0.15686275, 0.9529412),
            .init(0.5176471, 0.2, 0.9490196),
            .init(0.5058824, 0.18431373, 0.9490196),
            .init(0.47058824, 0.11372549, 0.95686275),
            .init(0.4117647, 0.09411765, 0.84313726),
            .init(0.3137255, 0.06666667, 0.64705884),
            .init(0.33333334, 0.09803922, 0.6666667),
            .init(0.3372549, 0.1254902, 0.68235296),
            .init(0.3647059, 0.1254902, 0.6392157),
            .init(0.7764706, 0.39215687, 0.23529412),
            .init(1.0, 0.5568628, 0.011764706),
            .init(1.0, 0.5372549, 0.023529412),
            .init(1.0, 0.53333336, 0.02745098),
            .init(1.0, 0.54509807, 0.03137255),
            .init(1.0, 0.6, 0.06666667),
            .init(0.7882353, 0.41960785, 0.25490198),
            .init(0.37254903, 0.1254902, 0.627451),
            .init(0.3372549, 0.1254902, 0.68235296),
            .init(0.33333334, 0.09803922, 0.6666667),
            .init(0.32156864, 0.06666667, 0.65882355),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.3254902, 0.078431375, 0.65882355),
            .init(0.3529412, 0.12941177, 0.65882355),
            .init(0.36078432, 0.13725491, 0.6627451),
            .init(0.45490196, 0.12941177, 0.8980392),
            .init(0.4627451, 0.09803922, 0.94509804),
            .init(0.45882353, 0.09803922, 0.9254902),
            .init(0.46666667, 0.10980392, 0.9490196),
            .init(0.5058824, 0.18431373, 0.9490196),
            .init(0.5176471, 0.20392157, 0.9490196),
            .init(0.49411765, 0.15294118, 0.95686275),
            .init(0.42352942, 0.09411765, 0.87058824),
            .init(0.31764707, 0.06666667, 0.654902),
            .init(0.32941177, 0.08235294, 0.65882355),
            .init(0.35686275, 0.13333334, 0.65882355),
            .init(0.34117648, 0.11764706, 0.6666667),
            .init(0.31764707, 0.0627451, 0.6666667),
            .init(0.5764706, 0.2627451, 0.42352942),
            .init(0.9607843, 0.63529414, 0.08627451),
            .init(1.0, 0.6666667, 0.05490196),
            .init(0.9529412, 0.627451, 0.09411765),
            .init(0.5686275, 0.24705882, 0.42352942),
            .init(0.32156864, 0.06666667, 0.65882355),
            .init(0.34117648, 0.11764706, 0.6666667),
            .init(0.35686275, 0.13333334, 0.65882355),
            .init(0.32941177, 0.08235294, 0.65882355),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.32156864, 0.06666667, 0.65882355),
            .init(0.34509805, 0.11372549, 0.65882355),
            .init(0.36078432, 0.13725491, 0.65882355),
            .init(0.34117648, 0.11372549, 0.64705884),
            .init(0.39215687, 0.08627451, 0.8),
            .init(0.46666667, 0.101960786, 0.9490196),
            .init(0.45882353, 0.101960786, 0.9254902),
            .init(0.4627451, 0.101960786, 0.9490196),
            .init(0.47843137, 0.13333334, 0.94509804),
            .init(0.5137255, 0.2, 0.9490196),
            .init(0.5137255, 0.19215687, 0.95686275),
            .init(0.44705883, 0.11372549, 0.8980392),
            .init(0.32156864, 0.07058824, 0.6627451),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.3529412, 0.1254902, 0.65882355),
            .init(0.35686275, 0.13333334, 0.65882355),
            .init(0.32156864, 0.07450981, 0.6666667),
            .init(0.30588236, 0.07058824, 0.6784314),
            .init(0.7764706, 0.40784314, 0.23529412),
            .init(1.0, 0.56078434, 0.015686275),
            .init(0.7764706, 0.40392157, 0.23529412),
            .init(0.29411766, 0.05882353, 0.6862745),
            .init(0.32156864, 0.078431375, 0.6666667),
            .init(0.35686275, 0.13333334, 0.65882355),
            .init(0.3529412, 0.12156863, 0.65882355),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.32156864, 0.06666667, 0.65882355),
            .init(0.32941177, 0.08627451, 0.65882355),
            .init(0.35686275, 0.13333334, 0.65882355),
            .init(0.35686275, 0.12941177, 0.65882355),
            .init(0.3254902, 0.078431375, 0.6509804),
            .init(0.34509805, 0.07450981, 0.70980394),
            .init(0.45490196, 0.09803922, 0.92941177),
            .init(0.45882353, 0.101960786, 0.9254902),
            .init(0.4627451, 0.105882354, 0.9490196),
            .init(0.4627451, 0.101960786, 0.94509804),
            .init(0.49803922, 0.16470589, 0.9490196),
            .init(0.5176471, 0.20392157, 0.9529412),
            .init(0.48235294, 0.16078432, 0.92156863),
            .init(0.32941177, 0.07058824, 0.6784314),
            .init(0.31764707, 0.06666667, 0.654902),
            .init(0.32941177, 0.09411765, 0.67058825),
            .init(0.34117648, 0.12156863, 0.6784314),
            .init(0.32156864, 0.08235294, 0.67058825),
            .init(0.3764706, 0.101960786, 0.60784316),
            .init(0.9254902, 0.46666667, 0.08235294),
            .init(1.0, 0.5176471, 0.007843138),
            .init(0.9137255, 0.45882353, 0.09411765),
            .init(0.36078432, 0.09019608, 0.62352943),
            .init(0.3254902, 0.08627451, 0.67058825),
            .init(0.34509805, 0.1254902, 0.6745098),
            .init(0.3254902, 0.09411765, 0.6745098),
            .init(0.32156864, 0.06666667, 0.65882355),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.34901962, 0.11764706, 0.65882355),
            .init(0.36078432, 0.13725491, 0.65882355),
            .init(0.3372549, 0.101960786, 0.65882355),
            .init(0.32156864, 0.06666667, 0.65882355),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.41960785, 0.09019608, 0.85882354),
            .init(0.45882353, 0.105882354, 0.9254902),
            .init(0.4627451, 0.105882354, 0.9490196),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.47058824, 0.11764706, 0.94509804),
            .init(0.50980395, 0.1882353, 0.9490196),
            .init(0.50980395, 0.19607843, 0.9372549),
            .init(0.3529412, 0.09411765, 0.69803923),
            .init(0.3137255, 0.0627451, 0.65882355),
            .init(0.44313726, 0.18039216, 0.5529412),
            .init(0.54901963, 0.27450982, 0.4627451),
            .init(0.8235294, 0.39215687, 0.18431373),
            .init(0.85882354, 0.40392157, 0.14117648),
            .init(0.9764706, 0.46666667, 0.02745098),
            .init(0.9843137, 0.4745098, 0.019607844),
            .init(0.9764706, 0.46666667, 0.03137255),
            .init(0.85882354, 0.40392157, 0.14509805),
            .init(0.8392157, 0.4, 0.16862746),
            .init(0.5764706, 0.28627452, 0.43529412),
            .init(0.44313726, 0.18039216, 0.5529412),
            .init(0.3137255, 0.0627451, 0.6627451),
            .init(0.33333334, 0.09411765, 0.65882355),
            .init(0.36078432, 0.13725491, 0.65882355),
            .init(0.34901962, 0.12156863, 0.65882355),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.31764707, 0.07450981, 0.6509804),
            .init(0.3882353, 0.09803922, 0.76862746),
            .init(0.49411765, 0.16078432, 0.9411765),
            .init(0.48235294, 0.13333334, 0.9529412),
            .init(0.4627451, 0.101960786, 0.94509804),
            .init(0.45882353, 0.101960786, 0.94509804),
            .init(0.4862745, 0.14509805, 0.9490196),
            .init(0.5176471, 0.2, 0.9490196),
            .init(0.38039216, 0.13333334, 0.72156864),
            .init(0.30588236, 0.05882353, 0.6627451),
            .init(0.8235294, 0.4745098, 0.19215687),
            .init(1.0, 0.6627451, 0.007843138),
            .init(1.0, 0.6745098, 0.03137255),
            .init(1.0, 0.6784314, 0.03529412),
            .init(1.0, 0.6666667, 0.047058824),
            .init(0.99607843, 0.6666667, 0.047058824),
            .init(1.0, 0.6666667, 0.047058824),
            .init(1.0, 0.6784314, 0.03137255),
            .init(1.0, 0.6745098, 0.03137255),
            .init(1.0, 0.6627451, 0.007843138),
            .init(0.8352941, 0.48235294, 0.18431373),
            .init(0.3137255, 0.06666667, 0.6666667),
            .init(0.3529412, 0.1254902, 0.65882355),
            .init(0.35686275, 0.13333334, 0.65882355),
            .init(0.32941177, 0.08627451, 0.65882355),
            .init(0.32156864, 0.06666667, 0.65882355),
            .init(0.32156864, 0.07058824, 0.65882355),
            .init(0.34117648, 0.11372549, 0.6431373),
            .init(0.4, 0.12156863, 0.7647059),
            .init(0.49803922, 0.16078432, 0.9490196),
            .init(0.47843137, 0.12941177, 0.9529412),
            .init(0.4627451, 0.105882354, 0.9490196),
            .init(0.4627451, 0.105882354, 0.94509804),
            .init(0.5058824, 0.1764706, 0.95686275),
            .init(0.40784314, 0.15686275, 0.7529412),
            .init(0.31764707, 0.08235294, 0.65882355),
            .init(0.81960785, 0.4627451, 0.19215687),
            .init(1.0, 0.75686276, 0.050980393),
            .init(0.99215686, 0.8117647, 0.09411765),
            .init(0.99607843, 0.7490196, 0.07450981),
            .init(0.99607843, 0.7490196, 0.07450981),
            .init(0.99607843, 0.7490196, 0.07450981),
            .init(0.99607843, 0.74509805, 0.07450981),
            .init(0.99607843, 0.7411765, 0.07058824),
            .init(0.99215686, 0.7921569, 0.09019608),
            .init(1.0, 0.7607843, 0.05490196),
            .init(0.83137256, 0.47058824, 0.18431373),
            .init(0.32941177, 0.09411765, 0.6666667),
            .init(0.35686275, 0.13725491, 0.65882355),
            .init(0.34509805, 0.10980392, 0.65882355),
            .init(0.32156864, 0.06666667, 0.65882355),
            .init(0.32156864, 0.07058824, 0.654902),
            .init(0.34901962, 0.11372549, 0.6627451),
            .init(0.39215687, 0.12156863, 0.7490196),
            .init(0.47058824, 0.11372549, 0.9529412),
            .init(0.4627451, 0.101960786, 0.9490196),
            .init(0.48235294, 0.12941177, 0.95686275),
            .init(0.42352942, 0.15686275, 0.78039217),
            .init(0.33333334, 0.11372549, 0.65882355),
            .init(0.8235294, 0.47058824, 0.19215687),
            .init(1.0, 0.7607843, 0.050980393),
            .init(0.99215686, 0.8156863, 0.09411765),
            .init(0.99607843, 0.7411765, 0.07058824),
            .init(0.99607843, 0.7411765, 0.07058824),
            .init(0.99607843, 0.7529412, 0.07450981),
            .init(0.99607843, 0.8, 0.09019608),
            .init(0.99607843, 0.8, 0.09019608),
            .init(0.99607843, 0.8235294, 0.09803922),
            .init(1.0, 0.7607843, 0.05490196),
            .init(0.8352941, 0.48235294, 0.18431373),
            .init(0.34509805, 0.12156863, 0.6666667),
            .init(0.3529412, 0.1254902, 0.65882355),
            .init(0.32156864, 0.07450981, 0.654902),
            .init(0.32156864, 0.07058824, 0.654902),
            .init(0.36862746, 0.105882354, 0.72156864),
            .init(0.44313726, 0.09411765, 0.90588236),
            .init(0.4745098, 0.105882354, 0.96862745),
            .init(0.41960785, 0.1254902, 0.8156863),
            .init(0.34117648, 0.1254902, 0.65882355),
            .init(0.83137256, 0.4862745, 0.19607843),
            .init(1.0, 0.67058825, 0.023529412),
            .init(1.0, 0.6901961, 0.05490196),
            .init(1.0, 0.6901961, 0.05490196),
            .init(1.0, 0.6901961, 0.05490196),
            .init(1.0, 0.6901961, 0.05490196),
            .init(1.0, 0.69411767, 0.05490196),
            .init(1.0, 0.69803923, 0.05490196),
            .init(1.0, 0.69411767, 0.05490196),
            .init(1.0, 0.67058825, 0.023529412),
            .init(0.8392157, 0.49411765, 0.1882353),
            .init(0.34901962, 0.12941177, 0.6666667),
            .init(0.32941177, 0.09411765, 0.6509804),
            .init(0.34117648, 0.07058824, 0.69803923),
            .init(0.38431373, 0.08235294, 0.7764706),
            .init(0.41960785, 0.09019608, 0.8509804),
            .init(0.3529412, 0.1254902, 0.67058825),
            .init(0.4509804, 0.20784314, 0.5568628),
            .init(0.47058824, 0.19215687, 0.5176471),
            .init(0.4862745, 0.21176471, 0.52156866),
            .init(0.49019608, 0.22352941, 0.52156866),
            .init(0.47843137, 0.2, 0.52156866),
            .init(0.49411765, 0.23137255, 0.52156866),
            .init(0.4745098, 0.19607843, 0.52156866),
            .init(0.49019608, 0.22352941, 0.52156866),
            .init(0.48235294, 0.21176471, 0.52156866),
            .init(0.4745098, 0.2, 0.5176471),
            .init(0.45490196, 0.21176471, 0.5568628),
            .init(0.3529412, 0.11372549, 0.6784314),
            .init(0.3764706, 0.078431375, 0.76862746),
            .init(0.3764706, 0.11372549, 0.7490196),
            .init(0.3254902, 0.09411765, 0.6745098),
            .init(0.31764707, 0.08235294, 0.67058825),
            .init(0.34117648, 0.12156863, 0.6745098),
            .init(0.3254902, 0.09411765, 0.6745098),
            .init(0.34117648, 0.12156863, 0.6745098),
            .init(0.32156864, 0.09019608, 0.6745098),
            .init(0.34117648, 0.12156863, 0.6745098),
            .init(0.31764707, 0.08627451, 0.67058825),
            .init(0.32941177, 0.101960786, 0.6784314),
            .init(0.38039216, 0.11372549, 0.7607843),
            .init(0.35686275, 0.09019608, 0.7137255),
            .init(0.3529412, 0.13333334, 0.6509804),
            .init(0.34901962, 0.1254902, 0.654902),
            .init(0.35686275, 0.12941177, 0.65882355),
            .init(0.34901962, 0.11764706, 0.654902),
            .init(0.3529412, 0.13333334, 0.654902),
            .init(0.3647059, 0.09803922, 0.72156864),
            .init(0.39607844, 0.105882354, 0.77254903),
            .init(0.36862746, 0.12941177, 0.6862745),
            .init(0.3529412, 0.13725491, 0.64705884),
            .init(0.37254903, 0.12941177, 0.69411767),
            .init(0.39607844, 0.101960786, 0.7764706),
            .init(0.40392157, 0.105882354, 0.7921569),
            
        ]
        
        let colors = points
            .map({ StemColor.RGBSpace($0) })
            .map({ StemColor(rgb: $0) })
        
        colors.kmeansClusterAnalysis(count: 16, difference: .ciede2000)
            .forEach { result in
                print(result.size, " : ", result.center.hexString())
            }
    }
    
}