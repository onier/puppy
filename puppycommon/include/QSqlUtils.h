//
// Created by xuzhenhai on 2020/4/11.
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
#include <QSqlError>
#include "Executor.h"

namespace puppy {
    namespace common {

        thread_local QSqlDatabase _localDataBase;
        thread_local std::map<std::string, QSqlQuery> _queryMap;

        class QSqlUtils {
        public:
            QSqlUtils(std::string host, std::string database, std::string name, std::string password, int count = 8);

            bool update(std::string sql, std::vector<QVariant> vars);

            template<class Bean>
            void query(std::string sql, std::vector<QVariant> vars, std::vector<Bean> &values) {
                auto vbs = _executor->postTask<std::vector<Bean>>([&, sql, vars]() {
                    std::vector<Bean> result;
                    checkLocalDataBase();
                    QSqlQuery query;
                    if (_queryMap.count(sql) > 0) {
                        query = _queryMap[sql];
                    } else {
                        query = QSqlQuery(_localDataBase);
                        query.prepare(sql.data());
                        _queryMap.insert({sql, query});
                    }
                    for (auto var:vars) {
                        query.addBindValue(var);
                    }
                    if (!query.exec()) {
                        LOG(ERROR) << "update " << query.lastError().text().toStdString();
                        _localDataBase.close();
                        _queryMap.clear();
                        return result;
                    }
                    rttr::type t = rttr::type::get<Bean>();
                    auto properties = t.get_properties();
                    while (query.next()) {
                        auto v = t.create();
                        for (auto &prop:properties) {
                            std::string typeName = prop.get_type().get_raw_type().get_name().data();
                            auto propName = prop.get_name().data();
                            if (typeName == "std::string") {
                                prop.set_value(v, query.value(propName).toString().toStdString());
                            } else if (typeName == "double") {
                                prop.set_value(v, query.value(propName).toDouble());
                            } else if (typeName == "int") {
                                prop.set_value(v, query.value(propName).toInt());
                            } else if (typeName == "float") {
                                prop.set_value(v, query.value(propName).toFloat());
                            } else if (typeName == "longint") {
                                long lvalue = query.value(propName).toLongLong();
                                prop.set_value(v, lvalue);
                            }
                        }
                        result.push_back(v.get_value<Bean>());
                    }
                    return result;
                });
                auto beans = vbs.get();
                values.insert(values.end(), beans.begin(), beans.end());
            }

            template<class Bean>
            void findAll(std::vector<Bean> &values) {
                auto vbs = _executor->postTask<std::vector<Bean>>([&]() {
                    std::vector<Bean> result;
                    checkLocalDataBase();
                    auto begin = std::chrono::high_resolution_clock::now();
                    rttr::type t = rttr::type::get<Bean>();
                    if (t.is_valid()) {
                        auto properties = t.get_properties();
                        QSqlQuery query = listAllQuery(t.get_name().data());
                        if (!query.exec()) {
                            LOG(ERROR) << "update " << query.lastError().text().toStdString();
                            _localDataBase.close();
                            _queryMap.clear();
                            return result;
                        }
                        while (query.next()) {
                            auto v = t.create();
                            for (auto &prop:properties) {
                                std::string typeName = prop.get_type().get_raw_type().get_name().data();
                                auto propName = prop.get_name().data();
                                if (typeName == "std::string") {
                                    prop.set_value(v, query.value(propName).toString().toStdString());
                                } else if (typeName == "double") {
                                    prop.set_value(v, query.value(propName).toDouble());
                                } else if (typeName == "int") {
                                    prop.set_value(v, query.value(propName).toInt());
                                } else if (typeName == "float") {
                                    prop.set_value(v, query.value(propName).toFloat());
                                } else if (typeName == "longint") {
                                    long lvalue = query.value(propName).toLongLong();
                                    prop.set_value(v, lvalue);
                                }
                            }
                            result.push_back(v.get_value<Bean>());
                        }
                    }
                    auto end = std::chrono::high_resolution_clock::now();
                    LOG(INFO) << "findAll spend time(ms) "
                              << std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count()
                              << std::endl;
                    return result;
                });
                auto beans = vbs.get();
                values.insert(values.end(), beans.begin(), beans.end());
            }

            template<class Bean>
            bool saveObject(std::vector<Bean> values) {
                auto fb = _executor->postTask<bool>([&, values]() {
                    checkLocalDataBase();
                    if (values.size() > 0) {
                        std::string primaryKey = "";
                        bool isAUTOINCREMENT = false;
                        QSqlQuery query = createAddQuery(values[0], primaryKey, isAUTOINCREMENT);

                        QMap<QString, std::shared_ptr<QVariantList>> vars;
                        rttr::type type = values[0].get_type();
                        auto properties = type.get_properties();
                        for (auto b : values) {
                            listInstance(b, properties, vars);
                        }

//                    _dataBase.transaction();
                        auto begin = std::chrono::high_resolution_clock::now();
                        bool b = execAddQuery(query, vars, properties, primaryKey, isAUTOINCREMENT);
                        auto end = std::chrono::high_resolution_clock::now();
                        LOG(INFO) << std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count()
                                  << std::endl;
//                    _dataBase.commit();
                        return b;
                    } else {
                        LOG(ERROR) << "empty values";
                    }
                    return false;
                });
                return fb.get();
            }

            template<class Bean>
            bool updateObject(std::vector<Bean> values) {
                auto fb = _executor->postTask<bool>([&, values]() {
                    checkLocalDataBase();
                    if (values.size() > 0) {
                        bool b = false;
                        std::string primary_key;
                        QSqlQuery query = createUpdateQuery(values[0], b, primary_key);
//                    if (!b) {
//                        return false;
//                    }
                        QMap<QString, std::shared_ptr<QVariantList>> vars;
                        rttr::type type = values[0].get_type();
                        auto properties = type.get_properties();
                        for (auto b : values) {
                            listInstance(b, properties, vars);
                        }

//                    _dataBase.transaction();
                        auto begin = std::chrono::high_resolution_clock::now();
                        b = execUpdateQuery(query, vars, properties, primary_key);
                        if (!b) {
                            LOG(ERROR) << _localDataBase.lastError().text().toStdString();
                        }
                        auto end = std::chrono::high_resolution_clock::now();
                        LOG(INFO) << std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count()
                                  << std::endl;
//                    _dataBase.commit();
                        return b;
                    } else {
                        LOG(ERROR) << "empty values";
                    }
                    return false;
                });
                return fb.get();
            }

            template<class Bean>
            bool deleteObject(std::vector<Bean> values) {
                auto fb = _executor->postTask<bool>([&, values]() {
                    checkLocalDataBase();
                    if (values.size() > 0) {
                        auto begin = std::chrono::high_resolution_clock::now();
                        std::string primary_key;
                        QSqlQuery query = createDeleteQuery(values[0], primary_key);
                        QVariantList vars;
                        rttr::type type = values[0].get_type();
                        auto key = type.get_property(primary_key);
                        for (auto b : values) {
                            qint64 lvalue = key.get_value(b).to_int64();
                            vars << lvalue;
                        }
//                    _dataBase.transaction();
                        bool b = execDeleteQuery(query, vars);
                        auto end = std::chrono::high_resolution_clock::now();
                        LOG(INFO) << std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count()
                                  << std::endl;
//                    _dataBase.commit();
                        return b;
                    } else {
                        LOG(ERROR) << "empty values";
                    }
                    return false;
                });
                return fb.get();
            }

        private:

            QSqlQuery createAddQuery(rttr::instance obj, std::string &primaryKey, bool &isAUTOINCREMENT);

            QSqlQuery createUpdateQuery(rttr::instance obj, bool &b, std::string &primary_key);

            QSqlQuery createDeleteQuery(rttr::instance obj, std::string &primary_key);

            QSqlQuery listAllQuery(std::string typeName);

            void listInstance(rttr::instance obj, rttr::array_range<rttr::property> &properties,
                              QMap<QString, std::shared_ptr<QVariantList>> &vars);

            bool
            execAddQuery(QSqlQuery query, QMap<QString, std::shared_ptr<QVariantList>> vars,
                         rttr::array_range<rttr::property> &properties, std::string &primaryKey,
                         bool &isAUTOINCREMENT);

            bool
            execUpdateQuery(QSqlQuery query, QMap<QString, std::shared_ptr<QVariantList>> vars,
                            rttr::array_range<rttr::property> &properties, std::string &primary_key);

            bool execDeleteQuery(QSqlQuery query, QVariantList &ids);

            void checkLocalDataBase();

        private:
            boost::shared_ptr<puppy::common::Executor> _executor;
            std::string _host = "192.168.10.236";
            std::string _name = "root";
            std::string _password = "cobot";
            std::string _database = "drug_db";
            boost::atomic_int _index;
        };
    }
}

