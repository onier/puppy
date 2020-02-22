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

#ifndef PUPPY_DATAOBJECT_H
#define PUPPY_DATAOBJECT_H

#include "Bean.h"
#include "vector"
#include "map"

enum class Alignment {
    AlignLeft = 0x0001,
    AlignRight = 0x0002,
    AlignHCenter = 0x0004,
    AlignJustify = 0x0008
};

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
    std::map<std::string, std::string> map3;
    std::map<int, std::string> map4;
    std::map<Bean, Bean> map2;
    Alignment alignment;

    DataObject();

RTTR_ENABLE()
};

#endif //PUPPY_DATAOBJECT_H
