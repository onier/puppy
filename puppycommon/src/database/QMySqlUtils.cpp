//
// Created by dev on 2020/4/11.
//

#include "QMySqlUtils.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <glog/logging.h>
#include <JSON.h>


bool puppy::common::QMySqlUtils::checkDataBaseExist(std::string host, std::string userName, std::string password,
                                                    std::string database) {
    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName(host.data());
    db.setUserName(userName.data());
    db.setDatabaseName(database.data());
    db.setPassword(password.data());
    if (!db.open()) {
        QString error = db.lastError().text();
        return false;
    }
    db.close();
    return true;
}

QSqlDatabase puppy::common::QMySqlUtils::createDatabase(std::string host, std::string userName, std::string password,
                                                        std::string database) {
    if (checkDataBaseExist(host, userName, password, database)) {
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        db.setHostName(host.data());
        db.setUserName(userName.data());
        db.setDatabaseName(database.data());
        db.setPassword(password.data());
        if (!db.open()) {
            throw std::runtime_error("database open fail");
        }
        return db;
    } else {
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        db.setHostName(host.data());
        db.setUserName(userName.data());
        db.setPassword(password.data());
        if (!db.open()) {
            QString error = db.lastError().text();
            LOG(ERROR) << error.toStdString();
            throw std::runtime_error("database open fail");
        }

        QSqlQuery query(db);
        auto ret = query.exec("create database test");
        if (ret) {
            LOG(INFO) << "database create sucess";
        } else {
            db.close();
            throw std::runtime_error("database create fail");
        }
        return db;
    }
}

std::map<std::string, std::string> extract_basic_types(rttr::type type, rttr::instance obj) {
    auto properties = type.get_properties();
    std::map<std::string, std::string> result;
    for (auto prop:properties) {
        std::string typeName = prop.get_type().get_raw_type().get_name().data();
//    LOG(INFO)<<type.get_name()<<"   "<<typeName;
        if (typeName == "std::string") {
            result.insert({prop.get_name().data(), prop.get_value(obj).to_string()});
        } else if (typeName == "double") {
            result.insert({prop.get_name().data(), std::to_string(prop.get_value(obj).to_double())});
        } else if (typeName == "int") {
            result.insert({prop.get_name().data(), std::to_string(prop.get_value(obj).to_int())});
        } else if (typeName == "float") {
            result.insert({prop.get_name().data(), std::to_string(prop.get_value(obj).to_float())});
        } else if (typeName == "longint") {
            result.insert({prop.get_name().data(), std::to_string(prop.get_value(obj).to_int64())});
        }
    }
    return result;
}


QSqlQuery puppy::common::QMySqlUtils::createAddQuery(rttr::instance type) {
    std::string queryKey = "add_";
    queryKey = queryKey + type.get_type().get_name().data();
    if (_queryMap.find(queryKey) != _queryMap.end()) {
        return _queryMap.find(queryKey)->second;
    }
    auto properties = type.get_type().get_properties();
    std::string tableName = type.get_type().get_name().data();
    std::string sql = "INSERT INTO ";
    std::string value = "VALUES (";
    sql = sql + tableName + "(";
    for (auto it = properties.begin(); it != properties.end(); it++) {
        sql.append(it->get_name().data()).append(",");
        value.append("?").append(",");
    }
    sql = sql.substr(0, sql.size() - 1);
    sql.append(")\n");
    value = value.substr(0, value.size() - 1);
    value.append(")\n");
    sql.append(value);
    LOG(INFO) << sql;
    QSqlQuery query(_dataBase);
    query.prepare(QString::fromStdString(sql));
    _queryMap.insert({queryKey, query});
    return query;
}

#include <QDebug>

void puppy::common::QMySqlUtils::listInstance(rttr::instance obj, rttr::array_range<rttr::property> &properties,
                                              QMap<QString, std::shared_ptr<QVariantList>> &vars) {
    for (auto prop:properties) {
        std::string propertyName = prop.get_name().data();
        std::shared_ptr<QVariantList> list = std::make_shared<QVariantList>();
        if (vars.find(propertyName.data()) == vars.end()) {
            vars.insert(QString::fromStdString(propertyName.data()), list);
        } else {
            list = vars[QString::fromStdString(propertyName.data())];
        }
        std::string typeName = prop.get_type().get_raw_type().get_name().data();
        if (typeName == "std::string") {
            QString str(prop.get_value(obj).to_string().data());
            list->push_back(str);
        } else if (typeName == "double") {
            list->push_back(prop.get_value(obj).to_double());
        } else if (typeName == "int") {
            list->push_back(prop.get_value(obj).to_int());
        } else if (typeName == "float") {
            list->push_back(prop.get_value(obj).to_float());
        } else if (typeName == "longint") {
            qint64 v = prop.get_value(obj).to_int64();;
            list->push_back(v);
        }
    }

}

#include <QSqlError>

bool puppy::common::QMySqlUtils::execQuery(QSqlQuery query, QMap<QString, std::shared_ptr<QVariantList>> vars,
                                           rttr::array_range<rttr::property> &properties) {
    LOG(INFO) << vars.size();
    for (auto prop:properties) {
        std::shared_ptr<QVariantList> list = vars[QString::fromStdString(prop.get_name().data())];
        query.addBindValue(*list);
    }
    if (!query.execBatch())
        LOG(INFO) << query.lastError().text().toStdString();
}
