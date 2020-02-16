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

#include <string>
#include <vector>
#include <rttr/registration.h>
#include <rttr/library.h>
#include <map>
#include "glog/logging.h"

class Context {
public:
    Context() {};

    template<typename T>
    const std::shared_ptr<T> create(std::string vendor) {
        for (auto pair:_typeMap) {
            for (auto t: pair.second) {
                if (t.is_derived_from<T>()) {
                    if (t.get_metadata("API_VENDOR").to_string() == vendor) {
                        const rttr::variant &var = t.create();
                        return var.get_value<std::shared_ptr<T>>();
                    }
                }
            }
        }
        throw std::invalid_argument("can not find api for " + vendor);
    };

    void loadLibrary(std::string libPath) {
        std::shared_ptr<rttr::library> lib = std::shared_ptr<rttr::library>(new rttr::library(libPath));

        if (!lib->load()) {
            LOG(ERROR) << "load library error " << lib->get_error_string();
        }
        {
            std::vector<rttr::type> temp;
            for (auto t : lib->get_types()) {
                if (t.is_class() && !t.is_wrapper()) {
                    LOG(INFO) << "find class " << t.get_name();
                    temp.push_back(t);
                    _types.push_back(t);
                }
            }
            _typeMap.insert({lib, temp});
        }
    };

    std::vector<rttr::type> getAllType() {
        return _types;
    }

private:
    std::map<std::shared_ptr<rttr::library>, std::vector<rttr::type>> _typeMap;
    std::vector<rttr::type> _types;
};