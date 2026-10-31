#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQuickItem>
#include <QTest>
#include <QTimer>
#include <cstdio>
static void logger(QtMsgType,const QMessageLogContext&,const QString&s){if(!s.contains("Gettext is not defined")&&!s.contains("module identifier directive"))fprintf(stderr,"QML: %s\n",s.toUtf8().constData());}
int main(int argc,char**argv){QGuiApplication app(argc,argv);qInstallMessageHandler(logger);QQmlApplicationEngine engine;engine.load(QUrl::fromLocalFile(argv[1]));if(engine.rootObjects().isEmpty())return 2;auto *w=qobject_cast<QQuickWindow*>(engine.rootObjects().first());if(!w)return 3;
QTimer::singleShot(500,[&]{bool ok=true;int checks=0;
 for (const char *name : {"terminal-shift", "terminal-shift-right"}) {
  auto *key=w->findChild<QObject*>(name);
  auto *icon=key ? key->findChild<QQuickItem*>("terminal-shift-icon") : nullptr;
  if (!icon || icon->width() < 60 || icon->property("status").toInt() != 1) { fprintf(stderr, "%s has missing or small icon\n",name); ok=false; }
  checks++;
 }
 auto click=[&](QString name){auto *item=w->findChild<QQuickItem*>(name);if(!item){fprintf(stderr,"Missing %s\n",name.toUtf8().constData());ok=false;return;}auto pt=item->mapToScene(QPointF(item->width()/2,item->height()/2)).toPoint();QTest::mouseClick(w,Qt::LeftButton,Qt::NoModifier,pt,1);QTest::qWait(5);};
 auto expect=[&](QString name,QStringList values){auto got=w->property("events").toStringList();if(got!=values){fprintf(stderr,"%s expected [%s] got [%s]\n",name.toUtf8().constData(),values.join(",").toUtf8().constData(),got.join(",").toUtf8().constData());ok=false;}checks++;w->setProperty("events",QStringList{});};
 struct Nav{const char *label,*value;}; Nav nav[]={{"Esc","Esc"},{"⇥","Tab"},{"Ende","End"},{"Bild ↑","PgUp"},{"Bild ↓","PgDown"},{"↑","Up"},{"←","Left"},{"↓","Down"},{"→","Right"}};
 for(auto n:nav){click(QString("terminal-")+QString::fromUtf8(n.label));expect(n.label,{"commit:",QString("keysequence:")+n.value});}
 click("terminal-backspace");expect("Backspace",{"backspace:"});
 click("terminal-return-upper");expect("Return upper",{"return:"});
 click("terminal-return-lower");expect("Return lower",{"return:"});
 click("terminal-space");expect("Space",{"space:"});
 click("terminal-shift-right");click("terminal-a");expect("Shift right",{":A"});
 click("terminal-caps");click("terminal-a");click("terminal-b");click("terminal-1");click("terminal-+");expect("Caps enabled",{":A",":B",":1",":+"});click("terminal-caps");click("terminal-a");expect("Caps disabled",{":a"});
 click("terminal-Strg-right");click("terminal-c");expect("Ctrl right",{"commit:","keysequence:Ctrl+C"});
 click("terminal-Strg");click("terminal-Alt");click("terminal-←");expect("Ctrl Alt Left",{"commit:","keysequence:Ctrl+Alt+Left"});
 click("terminal-´");click("terminal-space");expect("Dead acute space",{":´"});
 click("terminal-´");click("terminal-backspace");click("terminal-a");expect("Cancel dead",{":a"});
 click("terminal-delete");expect("Delete",{"commit:"});
 click("terminal-Strg");click("terminal-delete");expect("Ctrl Delete",{"commit:"});
 click("terminal-Alt");click("terminal-delete");expect("Alt Delete",{"commit:"});
 click("terminal-shift");click("terminal-delete");expect("Shift Delete",{"commit:"});
 click("terminal-symbols");auto *panel=w->findChild<QObject*>("test-panel");if(!panel||panel->property("state").toString()!="SYMBOLS")ok=false;checks++;
 click("terminal-emoji");auto *keypad=w->findChild<QObject*>("test-keypad");if(!keypad||keypad->property("state").toString()!="EMOJI")ok=false;checks++;
 fprintf(stderr,"SPECIAL KEYS: %d checks %s\n",checks,ok?"PASS":"FAIL");app.exit(ok?0:1);});return app.exec();}
