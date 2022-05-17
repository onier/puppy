//
// Created by xuzhenhai on 2020/3/25.
//

#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>
#include <boost/thread.hpp>
#include <boost/bind.hpp>
#include <boost/asio/deadline_timer.hpp>
#include <boost/asio/io_service.hpp>
#include <iostream>
#include <unistd.h>
#include <boost/function.hpp>
#include <vector>

#pragma once

namespace puppy {
    namespace common {
        struct Task {
            Task();

            bool isCancle();

            void cancle();

            void setTimer(boost::shared_ptr<boost::asio::deadline_timer> timer);

        private:
            boost::atomic_bool _flag;
            boost::shared_ptr<boost::asio::deadline_timer> _timer;
        };

        class Executor {
        public:
            Executor(int threadCount);

            ~Executor();

            template<class T>
            boost::shared_future<T> postTask(boost::function<T()> function) {
                boost::shared_ptr<boost::packaged_task<T>> task = boost::shared_ptr<boost::packaged_task<T >>(
                        new boost::packaged_task<T>(function));
                boost::shared_future<T> fut(task->get_future());
                _io_service->post(boost::bind(&boost::packaged_task<T>::operator(), task));
                return fut;
            }

            void postTask(boost::function<void()> function);

            boost::shared_ptr<puppy::common::Task> postTimerTaskSecond(boost::function<void()> function, int second = 3,
                                     boost::shared_ptr<Task> task = boost::make_shared<Task>());

            boost::shared_ptr<puppy::common::Task> postTimerTaskWithFixRate(boost::function<void()> function, int second = 3,
                                          boost::shared_ptr<Task> task = boost::make_shared<Task>());

            boost::shared_ptr<puppy::common::Task> postTimerTaskMilliSecond(boost::function<void()> function, int microsecond = 3,
                                          boost::shared_ptr<Task> task = boost::make_shared<Task>());

        public:
            boost::shared_ptr<boost::asio::io_service> _io_service;
            boost::shared_ptr<boost::asio::io_service::work> _work;
            std::vector<boost::shared_ptr<boost::thread >> _threads;
        };
    }
}

