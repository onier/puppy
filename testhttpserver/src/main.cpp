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

#include "TestAPI.h"
#include "Context.h"
#include "httplib.h"
#include "JSON.h"
#include <boost/filesystem.hpp>
#include <boost/range/iterator_range.hpp>
#include <iostream>

using namespace boost::filesystem;

void initWebServer(std::vector<rttr::type> types, httplib::Server &svr) {
    for (int i = 0; i < types.size(); ++i) {
        if (types[i].get_metadata("API_TYPE") == "WEB") {
            std::string version = types[i].get_metadata("API_VERSION").to_string();
            auto obj2 = types[i].create();
            auto ms = types[i].get_methods();
            for (auto m:ms) {
                std::string methodName = m.get_name().data();
                std::string url = "/" + version + "/" + methodName;
                LOG(INFO) << url;
                rttr::array_range<rttr::parameter_info> infos = m.get_parameter_infos();
                if (infos.size() > 1) {
                    LOG(ERROR) << "web api only support one json object";
                    continue;
                }
                svr.Post(url.data(), [infos, obj2, m](const httplib::Request &req, httplib::Response &res) {
                    if (infos.size() == 1) {
                        rttr::variant var = infos.begin()->get_type().create();
                        LOG(INFO) << infos.begin()->get_type().get_name();
                        std::string text = req.body;
                        puppy::common::JSON::parseJSON(text, var);//请参照官方代码的jsondemo
                        std::vector<rttr::argument> args{var};
                        rttr::variant result = m.invoke_variadic(obj2, args);
                        //请参照官方代码的转为json的demo
                        LOG(INFO) << result.get_type().get_name();
                        res.set_content(puppy::common::JSON::toJSONString(result), "application/json");
                    } else {
                        rttr::instance result = m.invoke(obj2);
                        res.set_content(puppy::common::JSON::toJSONString(result), "application/json");
                    }

                });
            }
        }
    }
}

int main(int argc, char *argv[]) {
    httplib::Server svr;
    Context context;
    path p(argv[0]);
    p = p.parent_path();
    path lib(p.parent_path().string() + "/lib");
    LOG(INFO)<<lib.string();
    if (is_directory(lib)) {
        for (auto &entry : boost::make_iterator_range(directory_iterator(lib), {})) {
            LOG(INFO)<<entry<<" "<<entry.path().extension();
            if (entry.path().extension() == ".so") {
                LOG(INFO) << "load library " << entry;
                context.loadLibrary(entry.path().string());
            }
        }
    }
    initWebServer(context.getAllType(), svr);

    svr.set_error_handler([](const httplib::Request & /*req*/, httplib::Response &res) {
        const char *fmt = "<p>Error Status: <span style='color:red;'>%d</span></p>";
        char buf[BUFSIZ];
        snprintf(buf, sizeof(buf), fmt, res.status);
        res.set_content(buf, "text/html");
    });

    svr.listen("0.0.0.0", 8080);

    return 0;
}