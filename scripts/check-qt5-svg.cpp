#include <QColor>
#include <QDir>
#include <QFile>
#include <QGuiApplication>
#include <QIcon>
#include <QImage>
#include <QTemporaryDir>
#include <cstdio>

static bool writeFile(const QString &path, const QByteArray &data)
{
    QFile file(path);
    return file.open(QIODevice::WriteOnly) && file.write(data) == data.size();
}

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);
    QTemporaryDir temp;
    if (!temp.isValid()) {
        std::fputs("Temporäres Verzeichnis konnte nicht angelegt werden.\n", stderr);
        return 2;
    }
    QDir root(temp.path());
    if (!root.mkpath("svg-probe/64x64/actions")) return 2;
    const QByteArray svg = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"64\" height=\"64\">"
                           "<rect x=\"0\" y=\"0\" width=\"64\" height=\"64\" fill=\"#e03040\"/></svg>";
    const QString svgPath = root.filePath("svg-probe/64x64/actions/maliit-svg-probe.svg");
    const QByteArray index = "[Icon Theme]\nName=SVG Probe\nDirectories=64x64/actions\n"
                             "[64x64/actions]\nSize=64\nType=Fixed\nContext=Actions\n";
    if (!writeFile(svgPath, svg) || !writeFile(root.filePath("svg-probe/index.theme"), index)) return 2;

    const QImage image(svgPath);
    const bool imageOk = !image.isNull() && image.pixelColor(image.width()/2, image.height()/2).alpha() > 0;
    QIcon::setThemeSearchPaths(QStringList() << temp.path());
    QIcon::setThemeName(QStringLiteral("svg-probe"));
    const QImage icon = QIcon::fromTheme(QStringLiteral("maliit-svg-probe")).pixmap(64, 64).toImage();
    const bool iconOk = !icon.isNull() && icon.pixelColor(icon.width()/2, icon.height()/2).alpha() > 0;
    std::printf("Qt-5-SVG-Bildformat: %s\nQt-5-SVG-Themensymbole: %s\n",
                imageOk ? "OK" : "FEHLT", iconOk ? "OK" : "FEHLT");
    return imageOk && iconOk ? 0 : 1;
}
