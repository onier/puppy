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
#include "QRTTRTableModel.h"
#include "vector"
#include "glog/logging.h"
#include "QComboBox"

using namespace puppy::common;

QRTTRTableModel::~QRTTRTableModel() {

}

std::vector<rttr::property> QRTTRTableModel::getProperties() const {
    std::vector<rttr::property> result;
    if (_variant) {
        if (_variant.get_type().is_wrapper()) {
            auto properties = _variant.get_type().get_wrapped_type().get_properties();
            for (auto property: properties) {
                result.push_back(property);
            }
        } else {
            auto properties = _variant.get_type().get_properties();
            for (auto property: properties) {
                result.push_back(property);
            }
        }
    }
    return result;
}

std::vector<std::string> QRTTRTableModel::getTypeNames() const {
    std::vector<std::string> result;
    auto properties = getProperties();
    for (auto property: properties) {
        result.push_back(property.get_name().data());
    }
    return result;
}

rttr::variant QRTTRTableModel::getVariantValue(int row, int col) {
    return getProperties().at(row).get_value(_variant);
}

void QRTTRTableModel::setVariant(rttr::variant &variant) {
    beginResetModel();
    _variant = variant;
    LOG(INFO) << variant.is_valid() << "  " << variant.get_type().get_name() << "  " << variant.get_type().is_wrapper()
            << "  " << variant.get_type().get_wrapped_type().get_name()
              << "  " << variant.get_type().get_wrapped_type().get_properties().size();
    endResetModel();
}

int QRTTRTableModel::rowCount(const QModelIndex &parent) const {
    return getTypeNames().size();
}

int QRTTRTableModel::columnCount(const QModelIndex &parent) const {
    return 2;
}

void QRTTRTableModel::addValueChangeEvents(ValueChangeEvent valueChangeEvent) {
    _valueChangeEvents.push_back(valueChangeEvent);
}

void QRTTRTableModel::notfyValueChange(int r, int c) {
    for (auto ace: _valueChangeEvents) {
        ace(r, c);
    }
}

QVariant QRTTRTableModel::data(const QModelIndex &index, int role) const {
    if (role == Qt::DisplayRole) {
        auto properties = getProperties();
        int col = index.column();
        int row = index.row();
        if (col == 0) {
            return properties[row].get_name().data();
        }
        std::string keyType = properties[row].get_type().get_name().data();
        if (keyType == "std::string") {
            return properties[row].get_value(_variant).to_string().data();
        } else if (keyType == "double") {
            return properties[row].get_value(_variant).to_double();
        } else if (keyType == "int") {
            return properties[row].get_value(_variant).to_int();
        } else if (keyType == "float") {
            return properties[row].get_value(_variant).to_float();
        } else if (keyType == "long") {
            return properties[row].get_value(_variant).to_int();
        } else if (keyType == "bool") {
            return properties[row].get_value(_variant).to_bool();
        } else if (properties[row].is_enumeration()) {
            return properties[row].get_enumeration().value_to_name(properties[row].get_value(_variant)).data();
        }

    }
    return QVariant();
}

bool QRTTRTableModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (role == Qt::EditRole) {
        auto properties = getProperties();
        auto type = properties[index.row()].get_type();
        std::string keyType = type.get_name().data();
        if (keyType == "std::string") {
            properties[index.row()].set_value(_variant, value.toString().toStdString());
        } else if (keyType == "double") {
            properties[index.row()].set_value(_variant, value.toDouble());
        } else if (keyType == "int") {
            properties[index.row()].set_value(_variant, value.toInt());
        } else if (keyType == "float") {
            properties[index.row()].set_value(_variant, value.toFloat());
        } else if (keyType == "long") {
            properties[index.row()].set_value(_variant, value.toLongLong());
        } else if (keyType == "bool") {
            properties[index.row()].set_value(_variant, value.toBool());
        } else if (properties[index.row()].is_enumeration()) {
            auto var = properties[index.row()].get_enumeration().name_to_value(value.toString().toStdString().data());
            auto ret = properties[index.row()].set_value(_variant, var);
        }
        notfyValueChange(index.row(), index.column());
    }
    return QAbstractItemModel::setData(index, value, role);
}

QVariant QRTTRTableModel::headerData(int section, Qt::Orientation orientation, int role) const {
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        switch (section) {
            case 0:
                return QString("Name");
            case 1:
                return QString("Value");
        }
    }
    return QVariant();
}

Qt::ItemFlags QRTTRTableModel::flags(const QModelIndex &index) const {
    if (index.column() == 1) {
        int row = index.row();
        int col = index.column();
        if (getProperties().at(row).get_type().is_sequential_container()) {
            return QAbstractTableModel::flags(index);
        }
        return Qt::ItemIsEditable | QAbstractTableModel::flags(index);
    } else
        return QAbstractTableModel::flags(index);
}

QWidget *
RTTRItemDelegate::createEditor(QWidget *parent, const QStyleOptionViewItem &option, const QModelIndex &index) const {
    auto properties = (_tableModel->getProperties());
    int row = index.row();
    int col = index.column();
    if (row < properties.size() && col == 1) {
        std::string typeName = properties[index.row()].get_type().get_name().data();
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
        } else if (properties[index.row()].is_enumeration()) {
            QComboBox *comboBox = new QComboBox(parent);
            auto names = properties[index.row()].get_enumeration().get_names();
            for (auto name: names) {
                comboBox->addItem(name.data());
            }
            return comboBox;
        }
    }
    return new QPlainTextEdit(parent);
}

void RTTRItemDelegate::setEditorData(QWidget *editor, const QModelIndex &index) const {
    auto properties = _tableModel->getProperties();
    int row = index.row();
    int col = index.column();
    if (row < properties.size() && col == 1) {
        auto value = _tableModel->getVariantValue(row, col);
        std::string typeName = properties[index.row()].get_type().get_name().data();
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
                    boolEditor->setCurrentText("true");
                else
                    boolEditor->setCurrentText("false");
        } else if (properties[index.row()].is_enumeration()) {
            QComboBox *enumEditor = dynamic_cast<QComboBox *>(editor);
            if (enumEditor) {
                enumEditor->setCurrentText(value.to_string().data());
            }
        }
    }
}

void RTTRItemDelegate::setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const {
    auto properties = _tableModel->getProperties();
    int row = index.row();
    int col = index.column();
    QVariant variant;
    if (row < properties.size() && col == 1) {
        auto value = _tableModel->getVariantValue(row, col);
        std::string typeName = properties[index.row()].get_type().get_name().data();
        if (typeName == "std::string") {
            QPlainTextEdit *textEditor = dynamic_cast<QPlainTextEdit *>(editor);
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

        } else if (properties[index.row()].is_enumeration()) {
            QComboBox *enumEditor = dynamic_cast<QComboBox *>(editor);
            variant = enumEditor->currentText();

        }
    }
    model->setData(index, variant, Qt::EditRole);
}

void RTTRItemDelegate::updateEditorGeometry(QWidget *editor, const QStyleOptionViewItem &option,
                                            const QModelIndex &index) const {
    editor->setGeometry(option.rect);
}

void RTTRItemDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const {
    auto properties = _tableModel->getProperties();
    auto type = properties[index.row()].get_type();
    std::string keyType = type.get_name().data();
    if (index.column() == 1) {
        auto value = _tableModel->getVariantValue(index.row(), index.column());
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
        } else if (properties[index.row()].is_enumeration()) {
            QComboBox comboBox;
            comboBox.setStyleSheet("QComboBox { border: 0px solid red; } QFrame { border: 0px solid blue; }");
            auto names = properties[index.row()].get_enumeration().get_names();
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
