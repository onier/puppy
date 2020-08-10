//
// Created by xuzhenhai on 2020/3/25.
//

#include "Executor.h"

puppy::common::Executor::Executor(int threadCount) {
    _io_service = boost::make_shared<boost::asio::io_service>();
    _work = boost::make_shared<boost::asio::io_service::work>(*_io_service);
    for (int i = 0; i < threadCount; ++i) {
        boost::shared_ptr<boost::thread> thread = boost::shared_ptr<boost::thread>(
                new boost::thread(boost::bind(&boost::asio::io_service::run, _io_service)));
        _threads.push_back(thread);
    }
}

puppy::common::Executor::~Executor() {
    _io_service->stop();
}

void puppy::common::Executor::postTask(boost::function<void()> function) {
    _io_service->post(function);
}

void puppy::common::Executor::postTimerTaskSecond(boost::function<void()> function, int second) {
    boost::posix_time::seconds interval(second);
    boost::shared_ptr<boost::asio::deadline_timer> timer = boost::shared_ptr<boost::asio::deadline_timer>(
            new boost::asio::deadline_timer(*(_io_service), interval));
    timer->async_wait([function, timer](const boost::system::error_code &) {
        function();
    });
}

void puppy::common::Executor::postTimerTaskMilliSecond(boost::function<void()> function, int microsecond) {
    boost::posix_time::millisec interval(microsecond);
    boost::shared_ptr<boost::asio::deadline_timer> timer = boost::shared_ptr<boost::asio::deadline_timer>(
            new boost::asio::deadline_timer(*(_io_service), interval));
    timer->async_wait([function, timer](const boost::system::error_code &) {
        function();
    });
}

void puppy::common::Executor::postTimerTaskWithFixRate(boost::function<void()> function, int second) {
    boost::posix_time::seconds interval(second);
    boost::shared_ptr<boost::asio::deadline_timer> timer = boost::shared_ptr<boost::asio::deadline_timer>(
            new boost::asio::deadline_timer(*(_io_service), interval));
    timer->async_wait([&, function, timer,second](const boost::system::error_code &) {
        function();
        postTimerTaskWithFixRate(function, second);
    });
}
