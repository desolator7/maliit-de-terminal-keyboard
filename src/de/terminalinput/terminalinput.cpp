#include <QObject>
#include <QQmlExtensionPlugin>
#include <qqml.h>
#include <linux/uinput.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <cstring>

class NativeInput : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool available READ available CONSTANT)
    int fd = -1;
    bool emitKey(int code, int value) {
        input_event ev{}; ev.type = EV_KEY; ev.code = code; ev.value = value;
        return ::write(fd, &ev, sizeof(ev)) == sizeof(ev);
    }
    void sync() { input_event ev{}; ev.type = EV_SYN; ev.code = SYN_REPORT; ::write(fd, &ev, sizeof(ev)); }
public:
    explicit NativeInput(QObject *parent = nullptr) : QObject(parent) {
        fd = ::open("/dev/uinput", O_WRONLY | O_NONBLOCK | O_CLOEXEC);
        if (fd < 0) return;
        bool ok = ioctl(fd, UI_SET_EVBIT, EV_KEY) == 0;
        for (int key : {KEY_DELETE, KEY_LEFTCTRL, KEY_LEFTALT, KEY_LEFTSHIFT})
            ok = (ioctl(fd, UI_SET_KEYBIT, key) == 0) && ok;
        uinput_setup setup{}; setup.id.bustype = BUS_VIRTUAL; setup.id.vendor = 0x1; setup.id.product = 0x1;
        std::strncpy(setup.name, "Maliit Q16 Delete Key", UINPUT_MAX_NAME_SIZE - 1);
        ok = (ioctl(fd, UI_DEV_SETUP, &setup) == 0) && ok;
        ok = (ioctl(fd, UI_DEV_CREATE) == 0) && ok;
        if (!ok) { ::close(fd); fd = -1; }
    }
    ~NativeInput() override { if (fd >= 0) { ioctl(fd, UI_DEV_DESTROY); ::close(fd); } }
    bool available() const { return fd >= 0; }
    Q_INVOKABLE void deleteForward(bool ctrl, bool alt, bool shift) {
        if (fd < 0) return;
        if (ctrl) emitKey(KEY_LEFTCTRL, 1);
        if (alt) emitKey(KEY_LEFTALT, 1);
        if (shift) emitKey(KEY_LEFTSHIFT, 1);
        sync(); emitKey(KEY_DELETE, 1); sync(); emitKey(KEY_DELETE, 0); sync();
        if (shift) emitKey(KEY_LEFTSHIFT, 0);
        if (alt) emitKey(KEY_LEFTALT, 0);
        if (ctrl) emitKey(KEY_LEFTCTRL, 0);
        sync();
    }
};
class TerminalInputPlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri) override { qmlRegisterType<NativeInput>(uri, 1, 0, "NativeInput"); }
};
#include "terminalinput.moc"
