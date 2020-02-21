#include "Bean.h"
#include "DataObject.h"
#include "JSON.h"
#include "XML.h"
#include "glog/logging.h"

void testJson() {
    DataObject parameter;
    parameter.name = "testName";
    parameter.age = 123;
    DataObject p1;
    p1.name = "p1name";
    p1.age = 1;
    DataObject p2;
    p2.name = "p2name";
    p2.age = 2;
    DataObject p3;
    p3.name = "p3name";
    p3.age = 3;
//    parameter.ps.push_back(p1);
//    parameter.ps.push_back(p2);
//    parameter.ps.push_back(p3);
    Bean b1;
    b1.a = 1;
    b1.b = 1.1;
    b1.name = "b1";
    b1.c = 1.0;
    b1.d = 1;

    Bean b2;
    b2.a = 2;
    b2.b = 1.1;
    b2.name = "b2";
    b2.c = 1.0;
    b2.d = 1;

    Bean b3;
    b3.a = 3;
    b3.b = 1.1;
    b3.name = "b3";
    b3.c = 1.0;
    b3.d = 1;

    parameter.rs.push_back(b1);
    parameter.rs.push_back(b2);
    parameter.rs.push_back(b3);

    parameter.map1.insert({"v1", 1.0});
    parameter.map1.insert({"v2", 2.0});
    parameter.map1.insert({"v3", 3.0});

    parameter.map2.insert({b1, b1});
    parameter.map2.insert({b2, b2});
    parameter.map2.insert({b3, b3});
    std::string text = puppy::common::JSON::toJSONString(parameter);
    DataObject parameter1;
    puppy::common::JSON::parseJSON(text, parameter1);
    text = puppy::common::JSON::toJSONString(parameter1);
    LOG(INFO) << text;
}

void testXML() {
    DataObject parameter;
    parameter.name = "testName";
    parameter.age = 123;
    DataObject p1;
    p1.name = "p1name";
    p1.age = 1;
    DataObject p2;
    p2.name = "p2name";
    p2.age = 2;
    DataObject p3;
    p3.name = "p3name";
    p3.age = 3;
    parameter.ps.push_back(p1);
    parameter.ps.push_back(p2);
    parameter.ps.push_back(p3);
    parameter.strs.push_back("str1");
    parameter.strs.push_back("str2");
    parameter.strs.push_back("str3");
    parameter.ints.push_back(11);
    parameter.ints.push_back(22);
    parameter.ints.push_back(23);
    Bean b1;
    b1.a = 1;
    b1.b = 1.1;
    b1.name = "b1";
    b1.c = 1.0;
    b1.d = 1;

    Bean b2;
    b2.a = 2;
    b2.b = 1.2;
    b2.name = "b2";
    b2.c = 1.0;
    b2.d = 1;

    Bean b3;
    b3.a = 3;
    b3.b = 1.3;
    b3.name = "b3";
    b3.c = 1.0;
    b3.d = 1;

    parameter.rs.push_back(b1);
    parameter.rs.push_back(b2);
    parameter.rs.push_back(b3);

    parameter.map1.insert({"v1", 1.0});
    parameter.map1.insert({"v2", 2.0});
    parameter.map1.insert({"v3", 3.0});

    parameter.map3.insert({"v1", "v1str"});
    parameter.map3.insert({"v2", "v2str"});
    parameter.map3.insert({"v3", "v3str"});

    parameter.map4.insert({1, "test1"});
    parameter.map4.insert({2, "test2"});
    parameter.map4.insert({3, "test3"});

    parameter.map2.insert({b1, b1});
    parameter.map2.insert({b2, b2});
    parameter.map2.insert({b3, b3});
    std::string text = puppy::common::XML::toXMLString(parameter);
    LOG(INFO) << text;
    auto result = puppy::common::XML::parseXML(text);
    auto p = result[0].get_value<DataObject>();
    text = puppy::common::XML::toXMLString(p);
    LOG(INFO) << text;
}

int main() {
    testXML();
}