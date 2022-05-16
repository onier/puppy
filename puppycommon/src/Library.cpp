//
// Created by xuzhenhai on 2022/4/2.
//

#include "Library.h"
#include "glog/logging.h"
#include <iostream>
#include "boost/filesystem.hpp"
#include "rttr/library.h"
#include "boost/algorithm/string.hpp"

using namespace std;
using namespace boost::filesystem;
std::vector<std::shared_ptr<rttr::library>> libraries;

void puppy::common::library::loadDefaultLibrary() {
    char tmp[256];
    getcwd(tmp, 256);
    std::string defaultPath(tmp);
    path p(defaultPath + "/../lib");
    directory_iterator end_itr;
    for (directory_iterator itr(p); itr != end_itr; ++itr) {
        if (is_regular_file(itr->path())) {
            string current_file = itr->path().string();
            if (boost::ends_with(current_file, ".so")) {
                auto lib = std::make_shared<rttr::library>(current_file);
                if (!lib->load()) {
                    LOG(ERROR) << lib->get_error_string();
                }
                libraries.push_back(lib);

//                LOG(INFO) << "load library " << current_file;
//                auto types = lib->get_types();
//                for(auto& t:types){
//                    LOG(INFO)<<t.get_name();
//                }
            }
        }
    }
}

void puppy::common::library::loadLibrary(std::string path) {
    libraries.push_back(std::make_shared<rttr::library>(path));
}

std::vector<rttr::variant> puppy::common::library::getVarinat(std::string key, std::string name) {
    std::vector<rttr::variant> values;
    auto types = rttr::type::get_types();
    for (auto &t: types) {
        if (t.get_metadata("key").to_string() == key) {
            if (name.empty()) {
                LOG(INFO) << t.get_name();
                auto var = t.create();
                values.push_back(var);
            } else if (t.get_metadata("name").to_string() == name) {
                 rttr::variant var = t.create();
                values.push_back(var);
            }
        }
    }
    return values;
}
