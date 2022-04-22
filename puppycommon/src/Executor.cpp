//
// Created by xuzhenhai on 2020/3/25.
//

#include <Executor.h>

#include "Executor.h"
#include "glog/logging.h"

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

boost::shared_ptr<puppy::common::Task>
puppy::common::Executor::postTimerTaskSecond(boost::function<void()> function, int second,
                                             boost::shared_ptr<Task> task) {
    boost::posix_time::seconds interval(second);
    boost::shared_ptr<boost::asio::deadline_timer> timer = boost::shared_ptr<boost::asio::deadline_timer>(
            new boost::asio::deadline_timer(*(_io_service), interval));
    task->setTimer(timer);
    timer->async_wait([function, task, timer](const boost::system::error_code &) {
        if (task->isCancle()) {
            LOG(INFO) << "task was cancle";
        } else {
            function();
        }
    });
    return task;
}

boost::shared_ptr<puppy::common::Task>
puppy::common::Executor::postTimerTaskMilliSecond(boost::function<void()> function, int microsecond,
                                                  boost::shared_ptr<Task> task) {
    boost::posix_time::millisec interval(microsecond);
    boost::shared_ptr<boost::asio::deadline_timer> timer = boost::shared_ptr<boost::asio::deadline_timer>(
            new boost::asio::deadline_timer(*(_io_service), interval));
    task->setTimer(timer);
    timer->async_wait([function, task, timer](const boost::system::error_code &) {
        if (task->isCancle()) {
            LOG(INFO) << "task was cancle";
        } else {
            function();
        }
    });
    return task;
}

boost::shared_ptr<puppy::common::Task>
puppy::common::Executor::postTimerTaskWithFixRate(boost::function<void()> function, int second,
                                                  boost::shared_ptr<Task> task) {
    boost::posix_time::seconds interval(second);
    boost::shared_ptr<boost::asio::deadline_timer> timer = boost::shared_ptr<boost::asio::deadline_timer>(
            new boost::asio::deadline_timer(*(_io_service), interval));
    task->setTimer(timer);
    timer->async_wait([&, function, timer, task, second](const boost::system::error_code &) {
        if (!task->isCancle()) {
            function();
            postTimerTaskWithFixRate(function, second, task);
        } else {
            LOG(INFO) << "fix rate task is cancle";
        }
    });
    return task;
}

puppy::common::Task::Task() {
    _flag = false;
}

bool puppy::common::Task::isCancle() {
    return _flag;
}

void puppy::common::Task::cancle() {
    if (_timer) {
        _timer->cancel();
    }
    _flag = true;
}

void puppy::common::Task::setTimer(boost::shared_ptr<boost::asio::deadline_timer> timer) {
    _timer = timer;
}
