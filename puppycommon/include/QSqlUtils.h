//
// Created by dev on 2020/4/11.
//

#pragma once


#include <string>
#include <QSqlDatabase>
#include <QStringList>
#include <rttr/registration.h>
#include <QMap>
#include <glog/logging.h>
#include <JSON.h>
#include <QVariantList>
#include <chrono>
#include <QtSql/QSqlQuery>

namespace puppy {
    namespace common {

        class QSqlUtils {
        public:
            QSqlUtils(QSqlDatabase database);

            template<class Bean>
            bool saveObject(std::vector<Bean> values) {
                if (values.size() > 0) {
                    QSqlQuery query = createAddQuery(values[0]);

                    QMap<QString, std::shared_ptr<QVariantList>> vars;
                    rttr::type type = values[0].get_type();
                    auto properties = type.get_properties();
                    for (auto b : values) {
                        listInstance(b, properties, vars);
                    }

                    _dataBase.transaction();
                    auto begin = std::chrono::high_resolution_clock::now();
                    execQuery(query, vars, properties);
                    auto end = std::chrono::high_resolution_clock::now();
                    LOG(INFO) << std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count()
                              << std::endl;
                    _dataBase.commit();
                } else {
                    LOG(ERROR) << "empty values";
                }
                return false;
            }

        private:

            QSqlQuery createAddQuery(rttr::instance obj);

            void listInstance(rttr::instance obj, rttr::array_range<rttr::property> &properties,
                              QMap<QString, std::shared_ptr<QVariantList>> &vars);

            bool
            execQuery(QSqlQuery query, QMap<QString, std::shared_ptr<QVariantList>> list,
                      rttr::array_range<rttr::property> &properties);

        private:
            QSqlDatabase _dataBase;
            std::map<std::string, QSqlQuery> _queryMap;

        };
    }
}

