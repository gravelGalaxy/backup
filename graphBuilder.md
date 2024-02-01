# mainwindow
- cornerRadius: 全局设置圆角的大小，统一界面。
## 在new时指定父控件
- 指定父控件即可在最后父控件析构时，自动析构子控件。
## 通过QTimer延迟初始化
在MainWindow构造函数中，通过QTimer延迟界面的初始化。
```
ui->mainWidget->rect();
```
需要在mainWidget的父对象mainWidget构造完成后才能获取对的rect。

## QLineEdit与QLabel
- 使用QLineEdit能够使用校验器？

## 设置QLineEdit的最小高度为字体高度
```
QFont titleFont = QFont("Corbel Light", 24);
// 通过QFontMetrics可以计算在该字体下字符的高度等。
QFontMetrics titleFm(titleFont);
title->setMinimumHeight(titleFm.height());
```

## 文本输入时文本框展开动画
- 使用QParallelAnimationGroup做平行动画一起播放。
- 修改indicator的长度。
- 修改渐变，从0 - 0.99
- 修改indicatpr的位置。
```
void textInputItem::enterEditEffect(){
    editor->setCursorPosition(editor->text().length());
    editor->setStyleSheet("color:#1c1c1c;background-color:#00000000;border-style:none;");
    QParallelAnimationGroup *group = new QParallelAnimationGroup(this);
    QPropertyAnimation *longer = new QPropertyAnimation(indicator, "geometry", this);
    longer->setStartValue(indicator->geometry());
    longer->setEndValue(QRectF(this->width() * 0.3, this->height() - 7, this->width() * 0.7 - margin, 4));
    longer->setDuration(500);
    longer->setEasingCurve(QEasingCurve::InOutExpo);
    QPropertyAnimation *fade = new QPropertyAnimation(opac, "opacity", this);
    fade->setStartValue(opac->opacity());
    fade->setEndValue(0.99);
    fade->setDuration(150);
    QPropertyAnimation *move = new QPropertyAnimation(editor, "geometry", this);
    move->setStartValue(editor->geometry());
    move->setEndValue(QRectF(this->width() * 0.3, this->height() / 2 - editor->height() / 2 - 2, this->width() * 0.7 - margin, editor->height()));
    move->setDuration(500);
    move->setEasingCurve(QEasingCurve::InOutExpo);
    group->addAnimation(longer);
    group->addAnimation(fade);
    group->addAnimation(move);
    group->start();
}
```
# MyGraphicsLineItem
- 继承自QGraphicsLineItem, QObject
- 在每个LineItem里包含两个QGraphicsLineItem，用来显示两种状态。
## 箭头
- 保存线段的angle,根据线段的端点，用path绘制两个与箭深夹角为30度的线段即可。
### 动效
- 每次帧改变的时候，就设置length比例，改变箭头的位置（线段终点）。
```
connect(visitEffect, &QTimeLine::frameChanged, this, [=](int frame){
            this->curPen.setColor(visitColor);
            qreal curProgress = curve.valueForProgress(frame / 200.0);
            setLengthRate(curProgress);
            drawLine();
        });
```
- 改变位置时，注意箭头只要指到点的边界就行，不需要指向圆的圆心，所以起始点和终止点统一向起始点偏移。
```
void MyGraphicsLineItem::setLengthRate(qreal r){
    sP = startVex->scenePos() + startVex->rect().center();
    eP = endVex->scenePos() + endVex->rect().center();
    dP = eP - sP;
    angle = atan2(dP.y(), dP.x());
    eP -= QPointF(endVex->getRadius() * cos(angle), endVex->getRadius() * sin(angle));
    sP += QPointF(endVex->getRadius() * cos(angle), endVex->getRadius() * sin(angle));
    dP = (eP - sP) * r;
    eP = sP + dP;
}
```

## line1 line2

# MyGraphicsVexItem
- 继承自QGraphicsEllipseItem
- 使用QEasingCurve来做in、out动画，根据进度调整圆的半径。例如in动画在`radius`的基础上根据进度增加`0.3 * radius * curProgress`的半径，out动画在`1.3 * radius`的基础上根据进度按照`0.3 * radius * curProgress`缩减。
```
QTimeLine *visitEffect = new QTimeLine;
visitEffect->setDuration(1000);
visitEffect->setFrameRange(0, 200);
QEasingCurve curveIn = QEasingCurve::InElastic;
QEasingCurve curveOut = QEasingCurve::OutBounce;
connect(visitEffect, &QTimeLine::frameChanged, this, [=](int frame){
    if(frame > 100){
        this->setBrush(visitedBrush);
        if(tag)
            tag->setBrush(visitedBrush);
    }
    if(frame < 100){
        qreal curProgress = curveIn.valueForProgress(frame / 100.0);
        qreal curRadius = radius + 0.3 * radius * curProgress;
        this->setRect(QRectF(center.x() - curRadius, center.y() - curRadius, curRadius * 2, curRadius * 2));
    }
    else{
        qreal curProgress = curveOut.valueForProgress((frame - 100.0) / 100.0);
        qreal curRadius = 1.3 * radius - 0.3 * radius * curProgress;
        this->setRect(QRectF(center.x() - curRadius, center.y() - curRadius, curRadius * 2, curRadius * 2));
    }
});
connect(visitEffect, &QTimeLine::stateChanged, this, [=](){
    if(visitEffect->state() == QTimeLine::Running){
        itemShow();
        this->state |= ON_VISIT;
        emit logAdded(new viewLog("[Vex] | \""+nameText+"\" set visited"));
    }
});
```
- 在每个VexItem里包含所有与之相关的线的数组。数组保存两个，一个是该点作为起点的线的数组，另一个是该点作为终点的线的数组。
## 通过点进行连线

# ScrollAreaCustom
### mouseMoveEvent
- 如果此时鼠标处于pressed状态，可以产生回弹效果。

## 通过ScrollAreaCustom和继承QLabel来写log
- 使用自己写的可以滚动的组件和重写QLabel样式的组件来展示log。
- 不要吝啬于QWidget的创建。

# singleSelectGroup 选择列表


# bigIcon 大图标类

# 问题
## 在快速创建点时，log文字会叠在一起，停止创建后才疏散开。
这是因为程序是单线程的，创建点的时候动画没有播放完，就要同时播放下一个动画，所以视觉上会叠到一起？

# 其他
## 效果
### QEasingCurve
- InOutExpo
### QGraphicsDropShadowEffect
### QGraphicsOpacityEffect

## 进制的前缀
- 0B：二进制前缀。0B00000001表示1
- 0O：八进制前缀。
- 0x：十六进制前缀。

 
# ui
- 把widget看成一个一个容器。
- 每个窗体下面放布局，窗体应该有自身的布局。
