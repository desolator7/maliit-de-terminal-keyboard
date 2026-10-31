#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQuickItem>
#include <QTest>
#include <QTimer>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include <QJSValue>
#include <QHash>
#include <cstdio>
static void logger(QtMsgType,const QMessageLogContext&,const QString&s) {
 if (!s.contains("Gettext is not defined") && !s.contains("module identifier directive"))
  fprintf(stderr,"QML: %s\n",s.toUtf8().constData());
}
int main(int argc,char**argv) {
 QGuiApplication app(argc,argv); qInstallMessageHandler(logger);
 QFile input(argv[2]); if(!input.open(QIODevice::ReadOnly)) return 2;
 auto cases=QJsonDocument::fromJson(input.readAll()).array();
 QQmlApplicationEngine engine; engine.load(QUrl::fromLocalFile(argv[1]));
 if(engine.rootObjects().isEmpty()) return 3;
 auto *w=qobject_cast<QQuickWindow*>(engine.rootObjects().first()); if(!w) return 4;
 QTimer::singleShot(500,[&]{
  bool ok=true; int checks=0;
  const QString wanted=QString::fromUtf8("1234567890ß´+#<,.-");
  const QHash<QString,QString> spacing={{"acute","´"},{"grave","`"},{"cedilla","¸"},{"ogonek","˛"},{"diaeresis","¨"},{"abovering","˚"},{"belowdot","̣"},{"abovedot","˙"},{"doubleacute","˝"},{"circumflex","^"},{"caron","ˇ"},{"breve","˘"},{"belowmacron","̱"}};
  auto show=[&](QString x){return x.startsWith("dead:")?spacing.value(x.mid(5)):x;};
  for(auto entry:cases) {
   auto row=entry.toArray(); QString label=row[0].toString(); if(!wanted.contains(label)) continue;
   auto *key=w->findChild<QObject*>("terminal-"+label);
   if(!key) {fprintf(stderr,"Missing key: %s\n",label.toUtf8().constData());ok=false;continue;}
   auto expected=row[1].toArray(); QStringList want={show(expected[1].toString()),show(expected[2].toString())};
   for(const char *property:{"extended","extendedShifted"}) {
    QVariant value=key->property(property);
    QStringList got=value.value<QJSValue>().toVariant().toStringList();
    if(got!=want) {fprintf(stderr,"Long-press choices %s/%s: [%s] instead of [%s]\n",label.toUtf8().constData(),property,got.join(",").toUtf8().constData(),want.join(",").toUtf8().constData());ok=false;}
    checks++;
   }
  }
  auto hold=[&](QString label,QString choice,bool swipe) {
   w->setProperty("events",QStringList{});
   auto *key=w->findChild<QQuickItem*>("terminal-"+label);
   auto *selector=w->findChild<QObject*>("test-selector");
   if(!key||!selector) {ok=false;return;}
   QPoint origin=key->mapToScene(QPointF(key->width()/2,key->height()/2)).toPoint();
   QTest::mousePress(w,Qt::LeftButton,Qt::NoModifier,origin,1);
   QTest::qWait(swipe?1200:450);
   if(!selector->property("enabled").toBool()) {fprintf(stderr,"Popup did not open for %s\n",label.toUtf8().constData());ok=false;QTest::mouseRelease(w,Qt::LeftButton,Qt::NoModifier,origin,1);return;}
   QPoint release=origin;
   if(swipe) {
    QVariant result;
    QMetaObject::invokeMethod(w,"popupPoint",Q_RETURN_ARG(QVariant,result),Q_ARG(QVariant,QVariant(choice)));
    auto map=result.toMap(); release=QPoint(map.value("x").toInt(),map.value("y").toInt());
    if(release.x()<0 || release.y()<0) {fprintf(stderr,"Popup choice not found: %s\n",choice.toUtf8().constData());ok=false;}
    QTest::mouseMove(w,release,10); QTest::qWait(30);
   }
   QTest::mouseRelease(w,Qt::LeftButton,Qt::NoModifier,release,1); QTest::qWait(40);
   auto got=w->property("events").toStringList();
   if(got!=QStringList({":"+choice})) {fprintf(stderr,"Long-press %s expected %s got %s\n",label.toUtf8().constData(),choice.toUtf8().constData(),got.join(",").toUtf8().constData());ok=false;}
   checks++;
  };
  hold("7","/",false); hold("´","`",false);
  hold("7","{",true); hold("+","~",true); hold("<","|",true); hold("´","¸",true);
  fprintf(stderr,"LONG PRESS: %d checks %s\n",checks,ok?"PASS":"FAIL");
  app.exit(ok?0:1);
 }); return app.exec();
}
