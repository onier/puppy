//
// Created by dev on 2020/2/21.
//

#ifndef PUPPY_BEAN_H
#define PUPPY_BEAN_H

#include "rttr/registration.h"
#include "string"

class Bean {
public:
    std::string name;
    int a;
    float b;
    double c;
    bool d;

    bool operator<(const Bean &cmp) const {
        return a < cmp.a;
    }

    Bean();

RTTR_ENABLE()
};


#endif //PUPPY_BEAN_H
