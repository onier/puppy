//
// Created by xuzhenhai on 2022/4/2.
//

#ifndef PUPPY_LIBRARY_H
#define PUPPY_LIBRARY_H

#include "string"
#include "memory"
#include "rttr/registration.h"

namespace puppy {
    namespace common {
        namespace library {
            void loadDefaultLibrary();

            template<class T>
            std::shared_ptr<T> get(std::string key) {
                auto types = rttr::type::get_types();
                for(auto &t:types)
                if (t.get_metadata("key").to_string() == key) {
                    const rttr::variant &var = t.create();
                    return var.get_value<std::shared_ptr<T>>();
                }
                return nullptr;
            }

            void loadLibrary(std::string path);
        }
    }
}


#endif //PUPPY_LIBRARY_H
