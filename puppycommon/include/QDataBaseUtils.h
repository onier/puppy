//
// Created by xuzhenhai on 2020/4/14.
//
#pragma once

#include <QSqlDatabase>
#include "rttr/type.h"

namespace puppy {
    namespace common {
        class QDataBaseUtils {
        public:
            static QSqlDatabase
            createMysqlDatabase(std::string host, std::string userName, std::string password, std::string database,
                                std::string connectionName);

            static QSqlDatabase
            createQqliteDatabase(std::string name, std::string connectionName);

            static bool checkDataBaseExist(std::string host, std::string userName, std::string password,
                                           std::string database, std::string connectionName);

        };

    }
}
