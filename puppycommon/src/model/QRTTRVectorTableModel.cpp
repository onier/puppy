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

#include "QStyle"
#include "QApplication"
#include "QPainter"
#include <QtWidgets/QPlainTextEdit>
#include <QtWidgets/QDoubleSpinBox>
#include <QtWidgets/QRadioButton>
#include "QRTTRVectorTableModel.h"
#include "vector"
#include "glog/logging.h"
#include "QComboBox"

using namespace puppy::common;

int QRTTRVectorTableModel::rowCount(const QModelIndex &parent) const {
    return _view.get_size();
}

int QRTTRVectorTableModel::columnCount(const QModelIndex &parent) const {
    return _valueType->get_properties().size();
}

void QRTTRVectorTableModel::addValueChangeEvents(ValueChangeEvent valueChangeEvent) {
    _valueChangeEvents.push_back(valueChangeEvent);
}

void QRTTRVectorTableModel::notfyValueChange(int r, int c) {
    for (auto ace: _valueChangeEvents) {
        ace(r, c);
    }
}

QVariant QRTTRVectorTableModel::getData(rttr::property type, rttr::variant variant) const {
    if (type.is_valid() && variant.is_valid()) {
        std::string keyType = type.get_type().get_name().data();
        if (keyType == "std::string") {
            return type.get_value(variant).to_string().data();
        } else if (keyType == "double") {
            return type.get_value(variant).to_double();
        } else if (keyType == "int") {
            return type.get_value(variant).to_int();
        } else if (keyType == "float") {
            return type.get_value(variant).to_float();
        } else if (keyType == "long") {
            return type.get_value(variant).to_int();
        } else if (keyType == "bool") {
            return type.get_value(variant).to_bool();
        } else if (type.is_enumeration()) {
            return type.get_enumeration().value_to_name(type.get_value(variant)).data();
        }
    }
    return "";
}

rttr::property QRTTRVectorTableModel::getProperty(int row, int col) const {
    auto properties = _view.get_value(row).get_type().get_wrapped_type().get_properties();
//    LOG(INFO) << row << " " << col << "  _view " << _view.get_size() << "  "
//              << _view.get_value(row).get_type().get_wrapped_type().get_name() << "  "
//              << _view.get_value(row).get_type().get_wrapped_type().get_properties().size();
    int n = 0;
    for (auto &p: properties) {
        if (n == col) {
            return p;
        }
        n++;
    }
}

rttr::variant QRTTRVectorTableModel::getVariant(int row, int col) const {
    return _variants[row];
}

QVariant QRTTRVectorTableModel::data(const QModelIndex &index, int role) const {
    if (role == Qt::DisplayRole) {
        int col = index.column();
        int row = index.row();
        auto prop = getProperty(row, col);
        auto var = getVariant(row, col);
        if(col==1){
            LOG(INFO)<<prop.get_name();
        }
        if (prop.is_valid() && var.is_valid()) {
            auto r = getData(prop, var);

            return r;
        }
    }
    return QVariant();
}

bool QRTTRVectorTableModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (role == Qt::EditRole) {
        int col = index.column();
        int row = index.row();
        auto prop = getProperty(row, col);
        auto var = getVariant(row, col);
        if (prop.is_valid() && var.is_valid()) {
            auto type = prop.get_type();
            std::string keyType = type.get_name().data();
            if (keyType == "std::string") {
                LOG(INFO) << value.toString().toStdString() << " " << prop.get_name() << " "
                          << prop.set_value(var, value.toString().toStdString());;
            } else if (keyType == "double") {
                prop.set_value(var, value.toDouble());
            } else if (keyType == "int") {
                prop.set_value(var, value.toInt());
            } else if (keyType == "float") {
                prop.set_value(var, value.toFloat());
            } else if (keyType == "long") {
                prop.set_value(var, value.toLongLong());
            } else if (keyType == "bool") {
                LOG(INFO) << var.get_type().get_name() << " " << value.toBool();
                prop.set_value(var, value.toBool());
            } else if (prop.is_enumeration()) {
                auto eunmValue = prop.get_enumeration().name_to_value(value.toString().toStdString().data());
                prop.set_value(var, eunmValue);
            }
            notfyValueChange(index.row(), index.column());
        }
    }
    return QAbstractItemModel::setData(index, value, role);
}

void QRTTRVectorTableModel::setType(rttr::type type) {
    _type = std::make_shared<rttr::type>(type);
}

QVariant QRTTRVectorTableModel::headerData(int section, Qt::Orientation orientation, int role) const {
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return _headers[section].data();
    }
    return QVariant();
}

Qt::ItemFlags QRTTRVectorTableModel::flags(const QModelIndex &index) const {
//    if (index.column() == 1)
//        return Qt::ItemIsEditable | QAbstractTableModel::flags(index);
//    else
//        return QAbstractTableModel::flags(index);
    return Qt::ItemIsEditable | QAbstractTableModel::flags(index);
}

QWidget *
RTTRVectorItemDelegate::createEditor(QWidget *parent, const QStyleOptionViewItem &option,
                                     const QModelIndex &index) const {
    int col = index.column();
    int row = index.row();
    auto prop = _tableModel->getProperty(row, col);
    auto value = _tableModel->getVariant(row, col);
    if (prop.is_valid() && value.is_valid()) {
        std::string typeName = prop.get_type().get_name().data();
        if (typeName == "std::string") {
            QPlainTextEdit *editor = new QPlainTextEdit(parent);
            return editor;
        } else if (typeName == "double" || typeName == "float") {
            QDoubleSpinBox *editor = new QDoubleSpinBox(parent);
            return editor;
        } else if (typeName == "int" || typeName == "long") {
            QSpinBox *editor = new QSpinBox(parent);
            return editor;
        } else if (typeName == "bool") {
            QComboBox *comboBox = new QComboBox(parent);
            comboBox->addItems({"true", "false"});
            return comboBox;
        } else if (prop.is_enumeration()) {
            QComboBox *comboBox = new QComboBox(parent);
            auto names = prop.get_enumeration().get_names();
            for (auto name: names) {
                comboBox->addItem(name.data());
            }
            return comboBox;
        }
    }
    return new QPlainTextEdit(parent);
}

void RTTRVectorItemDelegate::setEditorData(QWidget *editor, const QModelIndex &index) const {
    int col = index.column();
    int row = index.row();
    auto prop = _tableModel->getProperty(row, col);
    auto value = _tableModel->getVariant(row, col);
    if (prop.is_valid() && value.is_valid()) {
        std::string typeName = prop.get_type().get_name().data();
        if (typeName == "std::string") {
            QPlainTextEdit *textEditor = dynamic_cast<QPlainTextEdit *>(editor);
            if (textEditor)
                textEditor->setPlainText(value.to_string().data());
        } else if (typeName == "double") {
            QDoubleSpinBox *douibleEditor = dynamic_cast<QDoubleSpinBox *>(editor);
            if (douibleEditor)
                douibleEditor->setValue(value.to_double());
        } else if (typeName == "float") {
            QDoubleSpinBox *floatEditor = dynamic_cast<QDoubleSpinBox *>(editor);
            if (floatEditor)
                floatEditor->setValue(value.to_float());
        } else if (typeName == "int") {
            QSpinBox *intEditor = dynamic_cast<QSpinBox *>(editor);
            if (intEditor) {
                LOG(INFO) << value.to_int();
                intEditor->setValue(value.to_int());
            }
        } else if (typeName == "long") {
            QSpinBox *longEditor = dynamic_cast<QSpinBox *>(editor);
            if (longEditor) {
                longEditor->setValue(value.to_int());
            }
        } else if (typeName == "bool") {
            QComboBox *boolEditor = dynamic_cast<QComboBox *>(editor);
            if (boolEditor)
                if (value.to_bool())
                    boolEditor->setCurrentText("false");
                else
                    boolEditor->setCurrentText("true");
        } else if (prop.is_enumeration()) {
            QComboBox *enumEditor = dynamic_cast<QComboBox *>(editor);
            if (enumEditor) {
                enumEditor->setCurrentText(value.to_string().data());
            }
        }
    }
}

void RTTRVectorItemDelegate::setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const {
    int row = index.row();
    int col = index.column();
    auto property = _tableModel->getProperty(row, col);
    QVariant variant = _tableModel->data(index, Qt::DisplayRole);
    if (property.is_valid()) {
        std::string typeName = property.get_type().get_name().data();
        if (typeName == "std::string") {
            QPlainTextEdit *textEditor = dynamic_cast<QPlainTextEdit *>(editor);
            LOG(INFO) << textEditor->toPlainText().toStdString();
            if (textEditor)
                variant = textEditor->toPlainText();
        } else if (typeName == "double") {
            QDoubleSpinBox *doubleEditor = dynamic_cast<QDoubleSpinBox *>(editor);
            if (doubleEditor)
                variant = doubleEditor->value();
        } else if (typeName == "float") {
            QDoubleSpinBox *floatEditor = dynamic_cast<QDoubleSpinBox *>(editor);
            if (floatEditor)
                variant = floatEditor->value();
        } else if (typeName == "int") {
            QSpinBox *intEditor = dynamic_cast<QSpinBox *>(editor);
            if (intEditor) {
                variant = intEditor->value();
            }
        } else if (typeName == "long") {
            QSpinBox *longEditor = dynamic_cast<QSpinBox *>(editor);
            if (longEditor) {
                variant = longEditor->value();
            }
        } else if (typeName == "bool") {
            QComboBox *boolEditor = dynamic_cast<QComboBox *>(editor);
            if (boolEditor) {
                if (boolEditor->currentText() == "true") {
                    variant = true;
                } else {
                    variant = false;
                }
            }

        } else if (property.is_enumeration()) {
            QComboBox *enumEditor = dynamic_cast<QComboBox *>(editor);
            variant = enumEditor->currentText();

        }
    }
    model->setData(index, variant, Qt::EditRole);
}

void RTTRVectorItemDelegate::updateEditorGeometry(QWidget *editor, const QStyleOptionViewItem &option,
                                                  const QModelIndex &index) const {
    editor->setGeometry(option.rect);
}

void
RTTRVectorItemDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const {
    auto property = _tableModel->getProperty(index.row(), index.column());
    auto value = _tableModel->getVariant(index.row(), index.column());
    std::string keyType = property.get_type().get_name().data();
    if (index.column() == 1) {
        if (keyType == "std::string") {
            QTextEdit edit;
            edit.setFrameStyle(QFrame::NoFrame);
            edit.setPlainText(value.to_string().data());
            edit.setFixedWidth(option.rect.width());
            edit.setFixedHeight(option.rect.height());

            if (option.state & QStyle::State_Selected) {
                edit.setStyleSheet(
                        "QTextEdit { border: 0px solid red; background-color: rgba(48, 140, 198,255); } QFrame { border: 0px solid blue; } ");
            }
            QPixmap pixmap = edit.grab({0, 0, option.rect.width(), option.rect.height()});
            painter->drawPixmap(option.rect, pixmap);
        } else if (keyType == "double" || keyType == "float") {
            QDoubleSpinBox edit;
            edit.setValue(value.to_double());
            edit.setFixedWidth(option.rect.width());
            edit.setFixedHeight(option.rect.height());

            if (option.state & QStyle::State_Selected) {
                edit.setStyleSheet(
                        "QDoubleSpinBox { border: 0px solid red; background-color: rgba(48, 140, 198,255); } QFrame { border: 0px solid blue; } ");
            }
            QPixmap pixmap = edit.grab({0, 0, option.rect.width(), option.rect.height()});
            painter->drawPixmap(option.rect, pixmap);
        } else if (keyType == "int" || keyType == "long") {
            QSpinBox edit;
            edit.setValue(value.to_int());
            edit.setFixedWidth(option.rect.width());
            edit.setFixedHeight(option.rect.height());

            if (option.state & QStyle::State_Selected) {
                edit.setStyleSheet(
                        "QSpinBox { border: 0px solid red; background-color: rgba(48, 140, 198,255); } QFrame { border: 0px solid blue; } ");
            }
            QPixmap pixmap = edit.grab({0, 0, option.rect.width(), option.rect.height()});
            painter->drawPixmap(option.rect, pixmap);
        } else if (keyType == "bool") {
            QComboBox comboBox;
            comboBox.addItems({"true", "false"});
            if (value.to_bool()) {
                comboBox.setCurrentText("true");
            } else {
                comboBox.setCurrentText("false");
            }
            comboBox.setFixedWidth(option.rect.width());
            comboBox.setFixedHeight(option.rect.height());
            if (option.state & QStyle::State_Selected) {
                comboBox.setStyleSheet(
                        "QComboBox { border: 0px solid red; background-color: rgba(48, 140, 198,255); } QFrame { border: 0px solid blue; } ");
            } else {
                comboBox.setStyleSheet("QComboBox { border: 0px solid red; } QFrame { border: 0px solid blue; } ");
            }
            QPixmap pixmap = comboBox.grab({0, 0, option.rect.width(), option.rect.height()});
            painter->drawPixmap(option.rect, pixmap);
        } else if (property.is_enumeration()) {
            QComboBox comboBox;
            comboBox.setStyleSheet("QComboBox { border: 0px solid red; } QFrame { border: 0px solid blue; }");
            auto names = property.get_enumeration().get_names();
            for (auto name: names) {
                comboBox.addItem(name.data());
            }
            comboBox.setCurrentText(value.to_string().data());
            comboBox.setFixedWidth(option.rect.width());
            comboBox.setFixedHeight(option.rect.height());
            if (option.state & QStyle::State_Selected) {
                comboBox.setStyleSheet(
                        "QComboBox { border: 0px solid red; background-color: rgba(48, 140, 198,255); } QFrame { border: 0px solid blue; } ");
            } else {
                comboBox.setStyleSheet("QComboBox { border: 0px solid red; } QFrame { border: 0px solid blue; } ");
            }
            QPixmap pixmap = comboBox.grab({0, 0, option.rect.width(), option.rect.height()});
            painter->drawPixmap(option.rect, pixmap);
        }
    } else {
        QStyledItemDelegate::paint(painter, option, index);
    }
}
