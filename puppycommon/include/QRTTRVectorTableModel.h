/*Copyright (c) 2020 - 2022 xuzhenhai <282052309@qq.com>

This file is part of puppy builder
   License: MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */


#pragma once

#include <QAbstractTableModel>
#include <QStyledItemDelegate>
#include "rttr/registration.h"
#include "glog/logging.h"
namespace puppy {
    namespace common {
        typedef std::function<void(int, int)> ValueChangeEvent;

        class QRTTRVectorTableModel : public QAbstractTableModel {
        public:

            QRTTRVectorTableModel(std::shared_ptr<rttr::variant> variant, std::shared_ptr<rttr::type> type,
                                  QObject *parent = nullptr) : _variant(variant), _type(type),
                                                               QAbstractTableModel(parent) {
                _view = variant->create_sequential_view();
                for (auto v:_view) {
                    _variants.push_back(v);
                }
                _valueType = std::make_shared<rttr::type>(_view.get_value_type());
                LOG(INFO)<<type->get_name() <<"   "<< variant->get_type().get_name() << "  "<<_view.get_value_type().get_name();

                for(auto & p : _view.get_value_type().get_properties()){
                    _headers.push_back(p.get_name().data());
                }
            };

            QRTTRVectorTableModel(QObject *parent = nullptr) : QAbstractTableModel(parent) {};

            void addValueChangeEvents(ValueChangeEvent valueChangeEvent);

            int rowCount(const QModelIndex &parent) const override;

            int columnCount(const QModelIndex &parent) const override;

            QVariant data(const QModelIndex &index, int role) const override;

            bool setData(const QModelIndex &index, const QVariant &value, int role) override;

            QVariant headerData(int section, Qt::Orientation orientation, int role) const override;

            Qt::ItemFlags flags(const QModelIndex &index) const override;

            void setType(rttr::type type);

            rttr::property getProperty(int row, int col) const;

            rttr::variant getVariant(int row, int col) const;

        protected:
            void notfyValueChange(int r, int c);

            QVariant getData(rttr::property type, rttr::variant variant) const;

        public:
            std::shared_ptr<rttr::variant> _variant;
            std::shared_ptr<rttr::type> _type;
            std::shared_ptr<rttr::type> _valueType;
            std::vector<ValueChangeEvent> _valueChangeEvents;
            rttr::variant_sequential_view _view;
            std::vector<rttr::variant> _variants;
            std::vector<std::string> _headers;
            friend class RTTRVectorItemDelegate;
        };

        class RTTRVectorItemDelegate : public QStyledItemDelegate {
        public:
            RTTRVectorItemDelegate(QRTTRVectorTableModel *tableModel) : _tableModel(tableModel),
                                                                        QStyledItemDelegate(tableModel) {};

            QWidget *
            createEditor(QWidget *parent, const QStyleOptionViewItem &option, const QModelIndex &index) const override;

            void setEditorData(QWidget *editor, const QModelIndex &index) const override;

            void setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const override;

            void updateEditorGeometry(QWidget *editor, const QStyleOptionViewItem &option,
                                      const QModelIndex &index) const override;

            void paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const override;

        private:
            QRTTRVectorTableModel *_tableModel;
        };
    }
}

