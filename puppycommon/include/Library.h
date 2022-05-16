//
// Created by xuzhenhai on 2022/4/2.
//

#ifndef PUPPY_LIBRARY_H
#define PUPPY_LIBRARY_H

#include "string"
#include "memory"
#include "rttr/registration.h"
#include "glog/logging.h"

namespace puppy {
    namespace common {
        namespace library {
            void loadDefaultLibrary();

            template<class T>
            std::vector<std::shared_ptr<T>> get(std::string key, std::string name = "") {
                std::vector<std::shared_ptr<T>> values;
                auto types = rttr::type::get_types();
                for (auto &t: types) {
                    if (t.get_metadata("key").to_string() == key) {
                        if (name.empty()) {
                            LOG(INFO) << t.get_name();
                            const rttr::variant &var = t.create();
                            values.push_back(var.get_value<std::shared_ptr<T>>());
                        } else if (t.get_metadata("name").to_string() == name) {
                            const rttr::variant &var = t.create();
                            values.push_back(var.get_value<std::shared_ptr<T>>());
                        }
                    }
                }
                return values;
            }

            std::vector<rttr::variant> getVarinat(std::string key, std::string name = "");

            void loadLibrary(std::string path);
        }
    }
}


#endif //PUPPY_LIBRARY_H
