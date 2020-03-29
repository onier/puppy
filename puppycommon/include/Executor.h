//
// Created by dev on 2020/3/25.
//
#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>
#include <boost/thread.hpp>
#include <boost/bind.hpp>
#include <boost/asio.hpp>
#include <iostream>
#include <unistd.h>
#include <boost/function.hpp>
#include <vector>

#ifndef PUPPY_EXECUTOR_H
#define PUPPY_EXECUTOR_H

namespace puppy {
    namespace common {
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

            void postTimerTaskSecond(boost::function<void()> function, int second = 3);

            void postTimerTaskMilliSecond(boost::function<void()> function, int microsecond = 3);

        public:
            boost::shared_ptr<boost::asio::io_service> _io_service;
            boost::shared_ptr<boost::asio::io_service::work> _work;
            std::vector<boost::shared_ptr<boost::thread >> _threads;
        };
    }
}

#endif //PUPPY_EXECUTOR_H
