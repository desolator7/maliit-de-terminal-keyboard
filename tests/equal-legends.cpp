#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQuickItem>
#include <QTest>
#include <QTimer>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include <QFont>
#include <QHash>
#include <cstdio>
static void logger(QtMsgType, const QMessageLogContext&, const QString &s) {
 if (!s.contains("Gettext is not defined") && !s.contains("module identifier directive")) fprintf(stderr,"QML: %s\n",s.toUtf8().constData());
}
int main(int argc, char **argv) {
 QGuiApplication app(argc, argv); qInstallMessageHandler(logger);
 QFile file(argv[2]); if(!file.open(QIODevice::ReadOnly)) return 2;
 const auto tests=QJsonDocument::fromJson(file.readAll()).array();
 QQmlApplicationEngine engine; engine.load(QUrl::fromLocalFile(argv[1]));
 if(engine.rootObjects().isEmpty()) return 3;
 auto *window=qobject_cast<QQuickWindow*>(engine.rootObjects().first()); if(!window) return 4;
 QTimer::singleShot(500,[&]{
  const QHash<QString,QString> marks={{"acute","\u0301"},{"grave","\u0300"},{"cedilla","\u0327"},{"ogonek","\u0328"},{"diaeresis","\u0308"},{"abovering","\u030a"},{"belowdot","\u0323"},{"abovedot","\u0307"},{"doubleacute","\u030b"},{"circumflex","\u0302"},{"caron","\u030c"},{"breve","\u0306"},{"belowmacron","\u0331"}};
  const QHash<QString,QString> spacing={{"acute","´"},{"grave","`"},{"cedilla","¸"},{"ogonek","˛"},{"diaeresis","¨"},{"abovering","˚"},{"belowdot","̣"},{"abovedot","˙"},{"doubleacute","˝"},{"circumflex","^"},{"caron","ˇ"},{"breve","˘"},{"belowmacron","̱"}};
  bool ok=true; int checks=0;
  auto click=[&](QString name){
   auto *item=window->findChild<QQuickItem*>(name);
   if(!item) { fprintf(stderr,"Missing %s\n",name.toUtf8().constData()); ok=false; return; }
   auto point=item->mapToScene(QPointF(item->width()/2,item->height()/2)).toPoint();
   QTest::mouseClick(window, Qt::LeftButton, Qt::NoModifier, point, 1); QTest::qWait(4);
  };
  for(auto test:tests) {
   auto tuple=test.toArray(); QString label=tuple[0].toString(); auto levels=tuple[1].toArray();
   auto *item=window->findChild<QObject*>("terminal-"+label);
   QString third=levels[2].toString(); QString annotation=third.startsWith("dead:")?spacing.value(third.mid(5)):third;
   if (!QStringList({"2","3","7","8","9","0","ß","q","e","+","<"}).contains(label)) annotation.clear();
   auto *altgrHint = item ? item->findChild<QObject*>("terminal-altgr-hint") : nullptr;
   bool a=altgrHint && altgrHint->property("text").toString()==annotation;
   if(!a){fprintf(stderr,"Annotation mismatch %s expected %s actual %s\n",label.toUtf8().constData(),annotation.toUtf8().constData(),item?item->property("__annotationLabelNormal").toString().toUtf8().constData():"missing");ok=false;}
   checks++;
   auto *hint = item ? item->findChild<QObject*>("terminal-shift-hint") : nullptr;
   QString shiftExpected = levels[1].toString();
   if (shiftExpected.startsWith("dead:")) shiftExpected = spacing.value(shiftExpected.mid(5));
   if (shiftExpected == label || (label.toLower() != label.toUpper() && shiftExpected == label.toUpper())) shiftExpected.clear();
   bool hintOK = hint && hint->property("text").toString() == shiftExpected;
   if (!hintOK) { fprintf(stderr, "Shift legend mismatch %s expected %s got %s\n", label.toUtf8().constData(), shiftExpected.toUtf8().constData(), hint ? hint->property("text").toString().toUtf8().constData() : "missing"); ok=false; }
   auto shiftFont = hint ? hint->property("font").value<QFont>().pixelSize() : -1;
   auto altgrFont = altgrHint ? altgrHint->property("font").value<QFont>().pixelSize() : -2;
   if (shiftFont != altgrFont || shiftFont < 8) { fprintf(stderr,"Font size mismatch %s: %d vs %d\n", label.toUtf8().constData(), shiftFont, altgrFont); ok=false; }
   checks += 2;
   for(int level=0;level<4;level++) {
    window->setProperty("events",QStringList{});
    if(level==1||level==3) click("terminal-shift");
    if(level>=2) click("terminal-AltGr");
    click("terminal-"+label);
    QString expected=levels[level].toString();
    if(expected.startsWith("dead:")) {
     if(!window->property("events").toStringList().isEmpty()) {fprintf(stderr,"Dead key emitted early %s/%d\n",label.toUtf8().constData(),level);ok=false;}
     QString mark=marks.value(expected.mid(5)); if(mark.isEmpty()){fprintf(stderr,"Unknown %s\n",expected.toUtf8().constData());ok=false;}
     click("terminal-e"); expected=(QString("e")+mark).normalized(QString::NormalizationForm_C);
    }
    QStringList got=window->property("events").toStringList();
    QStringList want={":"+expected};
    if(got!=want){fprintf(stderr,"Key mismatch %s/%d expected [%s], got [%s]\n",label.toUtf8().constData(),level,expected.toUtf8().constData(),got.join(",").toUtf8().constData());ok=false;}
    checks++;
   }
  }
  fprintf(stderr,"ALL KEYS: %d checks %s\n",checks,ok?"PASS":"FAIL"); app.exit(ok?0:1);
 }); return app.exec();
}
