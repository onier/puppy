//
// Created by dev on 2020/3/16.
//

#pragma once


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


