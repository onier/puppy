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
#ifndef PUPPY_XML_H
#define PUPPY_XML_H

#include <xercesc/dom/DOMDocument.hpp>
#include <xercesc/dom/DOMElement.hpp>
#include <xercesc/util/XMLString.hpp>
#include "rttr/registration.h"
#include "glog/logging.h"

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

namespace puppy {
    namespace common {

        class XML {
        public:
            static rttr::instance parseXMLFile(const std::string &xml);

            static std::vector<rttr::variant> parseXML(const std::string &xml);

            static std::string toXMLString(rttr::variant &obj);

            static std::string toStr(const XMLCh *xmlch);

            static void parseInstance(xercesc::DOMNode *node, rttr::instance obj2);

            static void
            createElement(rttr::variant variant, xercesc::DOMElement *domElement, xercesc::DOMDocument *document);

            template<class T>
            static void
            createElement(rttr::variant variant, xercesc::DOMElement *parent, xercesc::DOMDocument *document,
                          std::shared_ptr<T> tPtr) {
                //    rttr::instance variant = obj2.get_type().get_raw_type().is_wrapper() ? obj2.get_wrapped_instance() : obj2;
                LOG(INFO) << tPtr->get_type().get_name();
                auto domElement = document->createElement(XStr(tPtr->get_type().get_name().data()));
                parent->appendChild(domElement);
                for (auto prop:tPtr->get_type().get_properties()) {
                    auto propName = prop.get_name();
                    if (prop.get_type().is_sequential_container()) {
                        auto vars = prop.get_value(variant);
                        auto view = vars.create_sequential_view();
                        if (view.get_size() > 0) {
                            auto listElement = document->createElement(XStr("list"));
                            listElement->setAttribute(XStr("type"),
                                                      XStr(view.get_value(
                                                              0).extract_wrapped_value().get_type().get_name().data()));
                            listElement->setAttribute(XStr("name"), XStr(prop.get_name().data()));
                            domElement->appendChild(listElement);
                            for (auto index = 0; index < view.get_size(); index++) {
                                auto var = view.get_value(index);
                                if (var.operator!=(var.get_type().create())) {
                                    auto element = document->createElement(
                                            XStr(view.get_value(
                                                    0).extract_wrapped_value().get_type().get_name().data()));
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
                    } else if (prop.get_type().get_raw_type().get_name() == "std::string" ||
                               prop.get_type().is_arithmetic() ||
                               prop.get_type().is_enumeration()) {
                        auto value = prop.get_value(variant).to_string();
                        if (!value.empty())
                            domElement->setAttribute(XStr(prop.get_name().data()),
                                                     XStr(value.data()));
                    } else {
                        auto var = prop.get_value(variant);
                        if (var.operator!=(var.get_type().create())) {
                            LOG(INFO) << " create sub element " << var.get_type().get_name();
                            LOG(INFO) << " create sub element " << propName;
                            auto element = document->createElement(XStr(propName.data()));
                            domElement->appendChild(element);
                            createElement(var, element, document);
                        }
                    }
                }
            };
        };
    }
}

#endif //PUPPY_XML_H
