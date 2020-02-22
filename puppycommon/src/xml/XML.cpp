/*Copyright (c) 2020 - 2022 xuzhenhai <282052309@qq.com>

This file is part of puppy builder
   License: MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */

#include "XML.h"
#include "xercesc/util/PlatformUtils.hpp"
#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/parsers/XercesDOMParser.hpp>
#include <xercesc/dom/DOMNodeList.hpp>
#include <xercesc/dom/DOMNamedNodeMap.hpp>
#include <xercesc/framework/LocalFileFormatTarget.hpp>
#include <xercesc/framework/MemBufInputSource.hpp>
#include <xercesc/framework/MemBufFormatTarget.hpp>
#include <xercesc/dom/DOMNodeFilter.hpp>
#include <xercesc/util/XMLUni.hpp>
#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/parsers/XercesDOMParser.hpp>
#include <xercesc/dom/DOMNodeList.hpp>
#include <xercesc/dom/DOMNamedNodeMap.hpp>
#include <xercesc/dom/DOMElement.hpp>
#include <xercesc/dom/DOMImplementationRegistry.hpp>
#include <xercesc/dom/DOMImplementation.hpp>
#include <xercesc/dom/DOMLSSerializer.hpp>
#include <xercesc/dom/DOMLSOutput.hpp>
#include "glog/logging.h"

using namespace puppy::common;

std::string toStr(const XMLCh *xmlch) {
    if (xmlch) {
        char *temp = xercesc::XMLString::transcode(xmlch);
        std::string value(temp);
        xercesc::XMLString::release(&temp);
        return value;
    }
    return "        ";
}

class XerceString {
public :
    XerceString(const char *const toTranscode) {
        fUnicodeForm = xercesc::XMLString::transcode(toTranscode);
    }

    ~XerceString() {
        xercesc::XMLString::release(&fUnicodeForm);
    }

    const XMLCh *unicodeForm() const {
        return fUnicodeForm;
    }

private :
    XMLCh *fUnicodeForm;
};

#define XStr(str) XerceString(str).unicodeForm()

void getTagsByName(std::string name, xercesc::DOMNode *pNode,
                   std::vector<xercesc::DOMNode *> &pVector) {
    xercesc::DOMNodeList *nodeList = pNode->getChildNodes();
    for (auto index = 0; index < nodeList->getLength(); index++) {
        if (toStr(nodeList->item(index)->getNodeName()) == name) {
            pVector.push_back(nodeList->item(index));
        }
    }
}

std::string attributeValue(xercesc::DOMNamedNodeMap *attributeMap, std::string name) {
    for (size_t size = 0; size < attributeMap->getLength(); size++) {
        xercesc::DOMNode *node = attributeMap->item(size);
        if (toStr(node->getNodeName()) == name) {
            return toStr((node->getNodeValue()));
        }
    }
    return "";
}

std::vector<xercesc::DOMNode *>
getListItemsByName(std::string name, xercesc::DOMNode *node) {
    std::vector<xercesc::DOMNode *> listElementNodes;
    std::vector<xercesc::DOMNode *> listNodes;
    getTagsByName("list", node, listNodes);
    for (auto listNode:listNodes) {
        xercesc::DOMNamedNodeMap *attributeMap = listNode->getAttributes();
        if (attributeValue(attributeMap, "name") == name) {
            getTagsByName(attributeValue(attributeMap, "type"), listNode, listElementNodes);
            return listElementNodes;
        }
    }
    return listElementNodes;
}

void getMapItemsByName(std::string name, xercesc::DOMNode *node, std::vector<xercesc::DOMNode *> &mapItems,
                       std::string &keyType, std::string &valueType) {
    std::vector<xercesc::DOMNode *> mapNodes;
    getTagsByName("map", node, mapNodes);
    for (auto mapNode:mapNodes) {
        xercesc::DOMNamedNodeMap *attributeMap = mapNode->getAttributes();
        if (attributeValue(attributeMap, "name") == name) {
            keyType = attributeValue(attributeMap, "keyType");
            valueType = attributeValue(attributeMap, "valueType");
            getTagsByName("item", mapNode, mapItems);
            return;
        }
    }
}

rttr::argument getArgument(std::string value, std::string type) {
    if (type == "std::string") {
        return value;
    } else if (type == "double") {
        return std::stod(value);
    } else if (type == "int") {
        return std::stoi(value);
    } else if (type == "float") {
        return std::stof(value);
    } else if (type == "long") {
        return std::stol(value);
    }
    return "";
}

rttr::variant extract_basic_types(std::string keyType, std::string keyValue) {
    if (keyType == "std::string") {
        return keyValue;
    } else if (keyType == "double") {
        return (std::stod(keyValue));
    } else if (keyType == "int") {
        return std::stoi(keyValue);
    } else if (keyType == "float") {
        return std::stof(keyValue);
    } else if (keyType == "long") {
        return std::stol(keyValue);
    }
    return "";
}

void
createMapItem(rttr::variant_associative_view &view, std::string keyType, std::string keyValue, std::string valueType,
              std::string valueValue) {
//    rttr::argument key;
//    if (keyType == "std::string") {
//        key = keyValue;
//    } else if (keyType == "double") {
//        key = (std::stod(keyValue));
//    } else if (keyType == "int") {
//        key = std::stoi(keyValue);
//    } else if (keyType == "float") {
//        key = std::stof(keyValue);
//    } else if (keyType == "long") {
//        key = std::stol(keyValue);
//    }
//    if (valueType == "std::string") {
//        view.insert(key, valueValue);
//        return;
//    } else if (valueType == "double") {
//        view.insert(key, std::stod(valueValue));
//        return;
//    } else if (valueType == "int") {
//        view.insert(key, std::stoi(valueValue));
//        return;
//    } else if (valueType == "float") {
//        view.insert(key, std::stof(valueValue));
//        return;
//    } else if (valueType == "long") {
//        view.insert(key, std::stol(valueValue));
//        return;
//    }

}

void parseInstance(xercesc::DOMNode *node, rttr::instance obj2) {
    rttr::instance obj = obj2.get_type().get_raw_type().is_wrapper() ? obj2.get_wrapped_instance() : obj2;
    auto prop_list = obj.get_type().get_properties();
    for (auto prop:prop_list) {
        auto propertyName = prop.get_name();
        rttr::type propType = rttr::type::get_by_name(propertyName);
        if (prop.get_type().is_sequential_container()) {
            auto value = prop.get_value(obj);
            auto view = value.create_sequential_view();
            std::vector<xercesc::DOMNode *> propNodes;
            std::vector<xercesc::DOMNode *> listElements = getListItemsByName(propertyName.data(), node);
            if (listElements.size() > 0) {
                view.set_size(listElements.size());
                for (size_t index = 0; index < listElements.size(); index++) {
                    auto element = listElements.at(index);
                    rttr::type elementType = rttr::type::get_by_name(toStr(element->getNodeName()));
                    std::string value = attributeValue(element->getAttributes(), "value");
                    auto elementTypeName = elementType.get_name();
                    if (elementType.get_name() == "std::string" || elementType.is_arithmetic()) {
                        view.set_value(index, extract_basic_types(elementType.get_name().data(), value));
                    } else {
                        rttr::variant variant = elementType.create();
                        parseInstance(element, variant);
                        view.set_value(index, variant);
                    }
                }
                prop.set_value(obj, value);
            }
        } else if (prop.get_type().is_associative_container()) {
            auto value = prop.get_value(obj);
            auto view = value.create_associative_view();
            std::vector<xercesc::DOMNode *> mapItems;
            std::string keyType, valueType;
            getMapItemsByName(propertyName.data(), node, mapItems, keyType, valueType);
            if (mapItems.size() > 0) {
                for (auto item:mapItems) {
                    std::vector<xercesc::DOMNode *> keyNodes;
                    std::vector<xercesc::DOMNode *> valueNodes;
                    getTagsByName("key", item, keyNodes);
                    getTagsByName("value", item, valueNodes);
                    LOG(INFO) << toStr(item->getParentNode()->getNodeName()) << "   "
                              << attributeValue(item->getParentNode()->getAttributes(), "name") << "   "
                              << attributeValue(item->getParentNode()->getAttributes(), "keyType") << "   "
                              << attributeValue(item->getParentNode()->getAttributes(), "valueType");
                    if (keyNodes.size() == 1 && valueNodes.size() == 1) {
                        rttr::variant key, value;
                        std::string keyType = attributeValue(item->getParentNode()->getAttributes(), "keyType");
                        std::string keyValue = attributeValue(keyNodes[0]->getAttributes(), "value");
                        if (view.get_key_type().get_name() == "std::string" || view.get_key_type().is_arithmetic()) {
                            key = extract_basic_types(keyType, keyValue);
                        } else {
                            const rttr::type ktype = rttr::type::get_by_name(keyType);
                            key = ktype.create();
                            parseInstance(keyNodes[0], key);
                        }
                        std::string valueType = attributeValue(item->getParentNode()->getAttributes(), "valueType");
                        std::string valueValue = attributeValue(valueNodes[0]->getAttributes(), "value");
                        if (view.get_value_type().get_name() == "std::string" ||
                            view.get_value_type().is_arithmetic()) {
                            value = extract_basic_types(valueType, valueValue);
                        } else {
                            const rttr::type vtype = rttr::type::get_by_name(valueType);
                            value = vtype.create();
                            parseInstance(valueNodes[0], value);
                        }
                        view.insert(key, value);
                    } else {
                        LOG(ERROR) << " item key error";
                    }
                }
                prop.set_value(obj, value);
            }
        } else if (prop.get_name() == "value") {
            prop.set_value(obj, toStr(node->getTextContent()));
            //字符串或者数字类型直接设置
        } else if (prop.get_type().is_enumeration()) {
            std::string valueText = attributeValue(node->getAttributes(), "alignment");
            prop.set_value(obj, prop.get_enumeration().name_to_value(valueText));
        } else if (prop.get_type().get_raw_type().get_name() == "std::string" || prop.get_type().is_arithmetic()) {
            auto typeName = prop.get_type().get_raw_type().get_name();
            xercesc::DOMNamedNodeMap *nodeMap = node->getAttributes();
            for (auto index = 0; index < nodeMap->getLength(); index++) {
                std::string nodeName = toStr(nodeMap->item(index)->getNodeName());
                if (nodeName == propertyName) {
                    std::string value = toStr(nodeMap->item(index)->getNodeValue());
                    if (typeName == "std::string") {
                        prop.set_value(obj, value);
                    } else if (typeName == "double") {
                        prop.set_value(obj, std::stod(value));
                    } else if (typeName == "int") {
                        prop.set_value(obj, std::stoi(value));
                    } else if (typeName == "float") {
                        prop.set_value(obj, std::stof(value));
                    } else if (typeName == "long") {
                        prop.set_value(obj, std::stol(value));
                    }

                }
            }
        } else {
            std::vector<xercesc::DOMNode *> propNodes;
            getTagsByName(propertyName.data(), node, propNodes);
            if (propNodes.size() > 0) {
                if (propNodes.size() != 1) {
                    LOG(ERROR) << propertyName << " only have one ";
                } else {
                    rttr::variant variant = propType.create();
                    parseInstance(propNodes[0], variant);
                    prop.set_value(obj, variant);
                }
            }
        }
    }

}

std::vector<rttr::variant> parseDocument(xercesc::DOMDocument *document) {
    std::vector<rttr::variant> variants;
    if (document) {
        auto nodes = document->getChildNodes();
        for (auto nodeIndex = 0; nodeIndex < nodes->getLength(); nodeIndex++) {
            std::string nodeName = toStr(nodes->item(nodeIndex)->getNodeName());
            rttr::type nodeType = rttr::type::get_by_name(nodeName);
            if (nodeType.is_valid()) {
                rttr::variant variant = nodeType.create();
                parseInstance(nodes->item(nodeIndex), variant);
                variants.emplace_back(variant);
            } else {
                LOG(ERROR) << "invalid xml node " << toStr(nodes->item(nodeIndex)->getNodeName());
            }
        }
    }
    return variants;
}

rttr::instance XML::parseXMLFile(const std::string &fileName) {
    try {
        xercesc::XMLPlatformUtils::Initialize();
        xercesc::XercesDOMParser xercesDOMParser;
        xercesDOMParser.parse(fileName.data());
        auto vars = parseDocument(xercesDOMParser.getDocument());
        return vars;
    } catch (...) {
        LOG(INFO) << "xml parse fail " << fileName;
    }
}

std::vector<rttr::variant> XML::parseXML(const std::string &xml) {
    xercesc::XMLPlatformUtils::Initialize();
    xercesc::XercesDOMParser xercesDOMParser;
    std::shared_ptr<xercesc::MemBufInputSource> memBufIS = std::shared_ptr<xercesc::MemBufInputSource>(
            new xercesc::MemBufInputSource((const XMLByte *) xml.data(), xml.size(), ""));
    xercesDOMParser.parse(*memBufIS);
    auto vars = parseDocument(xercesDOMParser.getDocument());
//            xercesc::XMLPlatformUtils::Terminate();
    return vars;
}

void createSequentialContainerElement(rttr::variant_sequential_view &view, xercesc::DOMElement *parent,
                                      xercesc::DOMDocument *document) {
    if (view.get_size() > 0) {
        auto listElement = document->createElement(XStr("list"));
        listElement->setAttribute(XStr("type"), XStr(view.get_value(0).get_type().get_name().data()));
    }

}

void createElement(rttr::instance obj2, xercesc::DOMElement *domElement, xercesc::DOMDocument *document) {
    rttr::instance variant = obj2.get_type().get_raw_type().is_wrapper() ? obj2.get_wrapped_instance() : obj2;
    auto props = variant.get_type().get_properties();
    for (auto prop:props) {
        auto propName = prop.get_name();
        if (prop.get_type().is_sequential_container()) {
            auto vars = prop.get_value(variant);
            auto view = vars.create_sequential_view();
            if (view.get_size() > 0) {
                auto listElement = document->createElement(XStr("list"));
                listElement->setAttribute(XStr("type"),
                                          XStr(view.get_value(0).extract_wrapped_value().get_type().get_name().data()));
                listElement->setAttribute(XStr("name"), XStr(prop.get_name().data()));
                domElement->appendChild(listElement);
                for (auto index = 0; index < view.get_size(); index++) {
                    auto var = view.get_value(index);
                    if (var.operator!=(var.get_type().create())) {
                        auto element = document->createElement(
                                XStr(view.get_value(0).extract_wrapped_value().get_type().get_name().data()));
                        if (var.get_type().get_wrapped_type().get_name() == "std::string" ||
                            var.get_type().get_wrapped_type().is_arithmetic()) {
                            element->setAttribute(XStr("value"), XStr(var.to_string().data()));
                        } else {
                            createElement(var, element, document);
                        }
                        listElement->appendChild(element);
                    }
                }
            }
        } else if (prop.get_type().is_associative_container()) {
            auto vars = prop.get_value(variant);
            auto view = vars.create_associative_view();
            if (view.get_size() > 0) {
                auto mapElement = document->createElement(XStr("map"));
                mapElement->setAttribute(XStr("name"), XStr(prop.get_name().data()));
                auto it = view.begin();
                mapElement->setAttribute(XStr("keyType"),
                                         XStr(it.get_key().extract_wrapped_value().get_type().get_name().data()));
                mapElement->setAttribute(XStr("valueType"),
                                         XStr(it.get_value().extract_wrapped_value().get_type().get_name().data()));
                domElement->appendChild(mapElement);
                for (auto item:view) {
//                    LOG(INFO) << prop.get_name() << "  " << item.first.extract_wrapped_value().get_type().get_name()
//                              << "  " << item.first.to_string() << "  "
//                              << item.second.extract_wrapped_value().get_type().get_name() << "  "
//                              << item.second.to_string();
                    auto itemElement = document->createElement(XStr("item"));
                    auto keyElement = document->createElement(XStr("key"));
                    if (item.first.extract_wrapped_value().get_type().is_arithmetic() ||
                        item.first.extract_wrapped_value().get_type() == rttr::type::get<std::string>()) {
                        keyElement->setAttribute(XStr("type"),
                                                 XStr(item.first.extract_wrapped_value().get_type().get_name().data()));
                        keyElement->setAttribute(XStr("value"), XStr(item.first.to_string().data()));
                    } else {
                        createElement(item.first, keyElement, document);
                    }

                    auto valueElement = document->createElement(XStr("value"));
                    if (item.second.extract_wrapped_value().get_type().is_arithmetic() ||
                        item.second.extract_wrapped_value().get_type() == rttr::type::get<std::string>()) {
                        valueElement->setAttribute(XStr("type"),
                                                   XStr(item.second.extract_wrapped_value().get_type().get_name().data()));
                        valueElement->setAttribute(XStr("value"), XStr(item.second.to_string().data()));
                    } else {
                        createElement(item.second, valueElement, document);
                    }
                    itemElement->appendChild(keyElement);
                    itemElement->appendChild(valueElement);
                    mapElement->appendChild(itemElement);
                }
            }
        } else if (prop.get_name() == "value") {
            std::string string = prop.get_value(variant).to_string();
            if (!string.empty())
                domElement->setTextContent(XStr(prop.get_value(variant).to_string().data()));
        } else if (prop.get_type().get_raw_type().get_name() == "std::string" || prop.get_type().is_arithmetic() ||
                   prop.get_type().is_enumeration()) {
            auto value = prop.get_value(variant).to_string();
            if (!value.empty())
                domElement->setAttribute(XStr(prop.get_name().data()),
                                         XStr(value.data()));
        } else {
            auto var = prop.get_value(variant);
            if (var.operator!=(var.get_type().create())) {
                auto element = document->createElement(XStr(var.get_type().get_name().data()));
                domElement->appendChild(element);
                createElement(var, element, document);
            }
        }
    }
}

std::string XML::toXMLString(rttr::instance variant) {
    xercesc::XMLPlatformUtils::Initialize();
    xercesc::DOMImplementation *domImplementation =
            xercesc::DOMImplementationRegistry::getDOMImplementation(
                    XStr("Core"));
    std::shared_ptr<xercesc::DOMLSSerializer> serializer = std::shared_ptr<xercesc::DOMLSSerializer>(
            domImplementation->createLSSerializer());
    auto config = serializer->getDomConfig();
    config->setParameter(xercesc::XMLUni::fgDOMWRTFormatPrettyPrint, true);
    auto out = domImplementation->createLSOutput();
    std::shared_ptr<xercesc::MemBufFormatTarget> formatTarget = std::shared_ptr<xercesc::MemBufFormatTarget>(
            new xercesc::MemBufFormatTarget());
    out->setByteStream(formatTarget.get());
    LOG(INFO) << variant.get_type().get_name();
    std::shared_ptr<xercesc::DOMDocument> document = std::shared_ptr<xercesc::DOMDocument>(
            domImplementation->createDocument(0, XStr(
                    variant.get_type().get_name().data()), 0));
    auto robotElem = document->getDocumentElement();
    createElement(variant, robotElem, document.get());
    document->normalizeDocument();
    serializer->write(document.get(), out);
    return std::string(reinterpret_cast<const char *>(formatTarget->getRawBuffer()));
}
