//
// Created by xuzhenhai on 2020/4/14.
//

#include "QDataBaseUtils.h"
#include <QSqlError>
#include <stdexcept>
#include <glog/logging.h>
#include <QSqlQuery>

bool puppy::common::QDataBaseUtils::checkDataBaseExist(std::string host, std::string userName, std::string password,
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

QSqlDatabase
puppy::common::QDataBaseUtils::createMysqlDatabase(std::string host, std::string userName, std::string password,
                                                   std::string database,std::string connectionName) {
    if (checkDataBaseExist(host, userName, password, database)) {
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL",connectionName.data());
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

QSqlDatabase puppy::common::QDataBaseUtils::createQqliteDatabase(std::string name,std::string connectionName) {
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE",connectionName.data());
    db.setDatabaseName(name.data());
    if (!db.open()) {
        QString error = db.lastError().text();
        return {};
    }
    return db;
}
