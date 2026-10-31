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
 struct IconPair { const char *first; const char *second; };
 for (const IconPair &pair : {IconPair{"terminal-backspace", "terminal-backspace-icon"}, {"terminal-return-upper", "terminal-return-icon"}, {"terminal-return-lower", "terminal-return-icon"}, {"terminal-caps", "terminal-caps-icon"}}) {
  auto *key=w->findChild<QObject*>(pair.first); auto *icon=key ? key->findChild<QQuickItem*>(pair.second) : nullptr;
  if (!icon || icon->width() < 60 || icon->property("status").toInt() != 1) { fprintf(stderr, "%s: icon missing or too small\n",pair.first); ok=false; }
  if (icon && QString::fromUtf8(pair.first)=="terminal-caps" && icon->rotation()!=180) { fprintf(stderr,"Caps icon is not rotated\n"); ok=false; }
  checks++;
 }
 auto *returnKey=w->findChild<QObject*>("terminal-return-upper");
 auto *returnIcon=returnKey ? returnKey->findChild<QQuickItem*>("terminal-return-icon") : nullptr;
 QMetaObject::invokeMethod(w,"setActionOverride",Q_ARG(QVariant,QVariant("Senden")),Q_ARG(QVariant,QVariant(""))); QTest::qWait(10);
 if (!returnKey || !returnIcon || returnIcon->isVisible() || returnKey->property("label").toString() != "Senden") { fprintf(stderr,"Return label override failed\n"); ok=false; } checks++;
 QMetaObject::invokeMethod(w,"setActionOverride",Q_ARG(QVariant,QVariant("")),Q_ARG(QVariant,QVariant("go-next-symbolic"))); QTest::qWait(10);
 if (!returnKey || !returnIcon || returnIcon->isVisible() || returnKey->property("iconNormal").toString() != "go-next-symbolic") { fprintf(stderr,"Return icon override failed\n"); ok=false; } checks++;
 QMetaObject::invokeMethod(w,"clearActionOverride"); QTest::qWait(10);
 if (!returnIcon || !returnIcon->isVisible()) { fprintf(stderr,"Default return icon failed to reappear\n"); ok=false; } checks++;
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
