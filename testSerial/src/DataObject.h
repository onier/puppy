//
// Created by dev on 2020/2/21.
//

#ifndef PUPPY_DATAOBJECT_H
#define PUPPY_DATAOBJECT_H

#include "Bean.h"
#include "vector"
#include "map"

class DataObject {
public:
    std::string name;
    int age;
    std::vector<DataObject> ps;
    std::vector<std::string> strs;
    std::vector<int> ints;
    Bean bean;
    std::vector<Bean> rs;
    std::map<std::string, double> map1;
    std::map<std::string, std::string > map3;
    std::map<int, std::string > map4;
    std::map<Bean, Bean> map2;

    DataObject();

RTTR_ENABLE()
};


#endif //PUPPY_DATAOBJECT_H
