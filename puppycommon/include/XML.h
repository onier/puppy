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
#include <xercesc/util/XMLString.hpp>
#include "rttr/registration.h"

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

            static std::string toXMLString(rttr::instance obj);

            static std::string toStr(const XMLCh *xmlch);

            static void parseInstance(xercesc::DOMNode *node, rttr::instance obj2);

        };
    }
}

#endif //PUPPY_XML_H
