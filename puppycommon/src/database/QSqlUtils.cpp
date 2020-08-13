//
// Created by xuzhenhai on 2020/4/11.
//

#include "QSqlUtils.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <glog/logging.h>
#include <JSON.h>

puppy::common::QSqlUtils::QSqlUtils(std::string host, std::string database, std::string name, std::string password,
                                    int count) {
    _host = host;
    _name = name;
    _database = database;
    _password = password;
    _index = 0;
    _executor = boost::make_shared<puppy::common::Executor>(count);
}

QSqlQuery puppy::common::QSqlUtils::createDeleteQuery(rttr::instance obj, std::string &primary_key) {
//    boost::lock_guard<boost::mutex> guard{_mutex};
    std::string queryKey = "delete_";
    primary_key = obj.get_type().get_metadata("PRIMARY_KEY").to_string();
    queryKey = queryKey + obj.get_type().get_name().data();
    if (_queryMap.find(queryKey) != _queryMap.end()) {
        return _queryMap.find(queryKey)->second;
    }
    std::string tableName = obj.get_type().get_name().data();
    std::string sql = "delete from ";
    sql.append(tableName).append(" where ").append(" ").append(primary_key).append("=?");
    QSqlQuery query(_localDataBase);
    query.prepare(QString::fromStdString(sql));
    _queryMap.insert({queryKey, query});
    LOG(INFO) << sql;
    return query;
}

QSqlQuery puppy::common::QSqlUtils::createUpdateQuery(rttr::instance obj, bool &b, std::string &primary_key) {
//    boost::lock_guard<boost::mutex> guard{_mutex};
    std::string queryKey = "update_";
    primary_key = obj.get_type().get_metadata("PRIMARY_KEY").to_string();
    queryKey = queryKey + obj.get_type().get_name().data();
    if (_queryMap.find(queryKey) != _queryMap.end()) {
        return _queryMap.find(queryKey)->second;
    }
    auto properties = obj.get_type().get_properties();
    if (primary_key.empty()) {
        b = false;
        LOG(ERROR) << " priamry key not found ";
        return QSqlQuery();
    }
    std::string tableName = obj.get_type().get_name().data();
    std::string sql = "update " + tableName + " set ";
    for (auto it = properties.begin(); it != properties.end(); it++) {
        if (it->get_name() != primary_key) {
            sql.append(it->get_name().data()).append("=? ,");
        }
    }
    sql = sql.substr(0, sql.size() - 1);
    sql.append(" where ").append(primary_key).append("=?");
    LOG(INFO) << sql;
    QSqlQuery query(_localDataBase);
    query.prepare(QString::fromStdString(sql));
    _queryMap.insert({queryKey, query});
    b = true;
    return query;
}

QSqlQuery
puppy::common::QSqlUtils::createAddQuery(rttr::instance type, std::string &primaryKey, bool &isAUTOINCREMENT) {
//    boost::lock_guard<boost::mutex> guard{_mutex};
    primaryKey = type.get_type().get_metadata("PRIMARY_KEY").to_string();
    isAUTOINCREMENT = type.get_type().get_metadata("AUTO_INCREMENT").to_string() == "true";
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
        if (isAUTOINCREMENT && it->get_name().to_string() == primaryKey) {
            continue;
        }
        sql.append(it->get_name().data()).append(",");
        value.append("?").append(",");
    }
    sql = sql.substr(0, sql.size() - 1);
    sql.append(")\n");
    value = value.substr(0, value.size() - 1);
    value.append(")\n");
    sql.append(value);
    LOG(INFO) << sql;
    QSqlQuery query(_localDataBase);
    query.prepare(QString::fromStdString(sql));
    _queryMap.insert({queryKey, query});
    return query;
}

#include <QDebug>

void puppy::common::QSqlUtils::listInstance(rttr::instance obj, rttr::array_range<rttr::property> &properties,
                                            QMap<QString, std::shared_ptr<QVariantList>> &vars) {
    std::string primaryKey = obj.get_type().get_metadata("PRIMARY_KEY").to_string();
    bool isAUTOINCREMENT = obj.get_type().get_metadata("AUTO_INCREMENT").to_string() == "true";
    for (auto prop:properties) {
        std::string propertyName = prop.get_name().data();
        if (isAUTOINCREMENT && primaryKey == propertyName) {
            continue;
        }
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
    for (auto prop:properties) {
        std::string propertyName = prop.get_name().data();
        if (isAUTOINCREMENT && primaryKey == propertyName) {
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
}

#include <QSqlError>
#include <QDataBaseUtils.h>

bool puppy::common::QSqlUtils::execAddQuery(QSqlQuery query, QMap<QString, std::shared_ptr<QVariantList>> vars,
                                            rttr::array_range<rttr::property> &properties, std::string &primaryKey,
                                            bool &isAUTOINCREMENT) {
    for (auto prop:properties) {
        if (prop.get_name() == primaryKey && isAUTOINCREMENT) {
            continue;
        }
        std::shared_ptr<QVariantList> list = vars[QString::fromStdString(prop.get_name().data())];
        query.addBindValue(*list);
    }
    bool b = query.execBatch();
    if (!b) {
        LOG(INFO) << query.lastError().text().toStdString();
    }
    return b;
}

bool puppy::common::QSqlUtils::execDeleteQuery(QSqlQuery query, QVariantList &ids) {
    query.addBindValue(ids);
    bool b = query.execBatch();
    if (!b) {
        LOG(INFO) << query.lastError().text().toStdString();
    }
    return b;
}

bool puppy::common::QSqlUtils::execUpdateQuery(QSqlQuery query, QMap<QString, std::shared_ptr<QVariantList>> vars,
                                               rttr::array_range<rttr::property> &properties,
                                               std::string &primary_key) {
    std::shared_ptr<QVariantList> ids;
    for (auto prop:properties) {
        std::shared_ptr<QVariantList> list = vars[QString::fromStdString(prop.get_name().data())];
        if (prop.get_name() != primary_key) {
            query.addBindValue(*list);
        } else {
            ids = list;
        }
    }
    query.addBindValue(*ids);
    bool b = query.execBatch();
    if (!b) {
        LOG(INFO) << query.lastError().text().toStdString();
    }
    return b;
}

QSqlQuery puppy::common::QSqlUtils::listAllQuery(std::string typeName) {
//    boost::lock_guard<boost::mutex> guard{_mutex};
    std::string key = "listALL" + typeName;
    if (_queryMap.find(key) != _queryMap.end()) {
        return _queryMap.find(key)->second;
    }
    std::string sql = "select * from ";
    sql.append(typeName);//.append(" where PTID<100");
    QSqlQuery query(_localDataBase);
    query.prepare(sql.data());
    _queryMap.insert({key, query});
    return query;
}

void puppy::common::QSqlUtils::checkLocalDataBase() {
    if (!_localDataBase.isOpen() || !_localDataBase.isValid()) {
        _queryMap.clear();
        std::string name = "mysql" + std::to_string(_index++);
        _localDataBase = puppy::common::QDataBaseUtils::createMysqlDatabase(_host, _name, _password, _database, name);
    }
}

bool puppy::common::QSqlUtils::update(std::string sql, std::vector<QVariant> vars) {
    auto vbs = _executor->postTask<bool>([&, sql, vars]() {
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
            return false;
        }
        return true;
    });
    return vbs.get();
}

bool puppy::common::QSqlUtils::execSql(boost::function<bool(QSqlDatabase)> sqlFunction) {
    auto fb = _executor->postTask<bool>([&, sqlFunction]() {
        return sqlFunction(_localDataBase);
    });
    return fb.get();
}
