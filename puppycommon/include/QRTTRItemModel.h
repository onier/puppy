//
// Created by dev on 2020/3/16.
//

#ifndef PUPPY_QRTTRITEMMODEL_H
#define PUPPY_QRTTRITEMMODEL_H


#include <QStandardItemModel>
#include <rttr/registration.h>

class QRTTRItemModel : public QStandardItemModel {
Q_OBJECT
public:
    QRTTRItemModel(rttr::instance instance, QObject *parent = nullptr) : _instance(instance),
                                                                         QStandardItemModel(parent) {};

private:
    rttr::instance _instance;
};


#endif //PUPPY_QRTTRITEMMODEL_H
