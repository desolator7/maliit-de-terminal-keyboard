import QtQuick 2.4
QtObject {
    id: root
    objectName: "terminal-state"
    property bool ctrl: false
    property bool alt: false
    property bool altgr: false
    property string pendingDead: ""
    readonly property bool active: ctrl || alt || altgr || pendingDead !== ""

    readonly property var levels: {
        "1": [
                "¹",
                "¡"
        ],
        "2": [
                "²",
                "⅛"
        ],
        "3": [
                "³",
                "£"
        ],
        "4": [
                "¼",
                "¤"
        ],
        "5": [
                "½",
                "⅜"
        ],
        "6": [
                "¬",
                "⅝"
        ],
        "7": [
                "{",
                "⅞"
        ],
        "8": [
                "[",
                "™"
        ],
        "9": [
                "]",
                "±"
        ],
        "0": [
                "}",
                "°"
        ],
        "ß": [
                "\\",
                "¿"
        ],
        "´": [
                "dead:cedilla",
                "dead:ogonek"
        ],
        "q": [
                "@",
                "Ω"
        ],
        "w": [
                "ſ",
                "§"
        ],
        "e": [
                "€",
                "€"
        ],
        "r": [
                "¶",
                "®"
        ],
        "t": [
                "ŧ",
                "Ŧ"
        ],
        "z": [
                "←",
                "¥"
        ],
        "u": [
                "↓",
                "↑"
        ],
        "i": [
                "→",
                "ı"
        ],
        "o": [
                "ø",
                "Ø"
        ],
        "p": [
                "þ",
                "Þ"
        ],
        "ü": [
                "dead:diaeresis",
                "dead:abovering"
        ],
        "+": [
                "~",
                "¯"
        ],
        "a": [
                "æ",
                "Æ"
        ],
        "s": [
                "ſ",
                "ẞ"
        ],
        "d": [
                "ð",
                "Ð"
        ],
        "f": [
                "đ",
                "ª"
        ],
        "g": [
                "ŋ",
                "Ŋ"
        ],
        "h": [
                "ħ",
                "Ħ"
        ],
        "j": [
                "dead:belowdot",
                "dead:abovedot"
        ],
        "k": [
                "ĸ",
                "&"
        ],
        "l": [
                "ł",
                "Ł"
        ],
        "ö": [
                "dead:doubleacute",
                "dead:belowdot"
        ],
        "ä": [
                "dead:circumflex",
                "dead:caron"
        ],
        "#": [
                "’",
                "dead:breve"
        ],
        "<": [
                "|",
                "dead:belowmacron"
        ],
        "y": [
                "»",
                "›"
        ],
        "x": [
                "«",
                "‹"
        ],
        "c": [
                "¢",
                "©"
        ],
        "v": [
                "„",
                "‚"
        ],
        "b": [
                "“",
                "‘"
        ],
        "n": [
                "”",
                "’"
        ],
        "m": [
                "µ",
                "º"
        ],
        ",": [
                "·",
                "×"
        ],
        ".": [
                "…",
                "÷"
        ],
        "-": [
                "–",
                "—"
        ]
}
    readonly property var deadKeys: ({
        "acute": ["´", "\u0301"], "grave": ["`", "\u0300"],
        "cedilla": ["¸", "\u0327"], "ogonek": ["˛", "\u0328"],
        "diaeresis": ["¨", "\u0308"], "abovering": ["˚", "\u030a"],
        "belowdot": ["̣", "\u0323"], "abovedot": ["˙", "\u0307"],
        "doubleacute": ["˝", "\u030b"], "circumflex": ["^", "\u0302"],
        "caron": ["ˇ", "\u030c"], "breve": ["˘", "\u0306"],
        "belowmacron": ["̱", "\u0331"]
    })
    function altGrCharacter(key) {
        var values = levels[key.toLowerCase()]
        if (!values || !values[0]) return ""
        var value = values[0]
        return value.indexOf("dead:") === 0 ? deadKeys[value.substring(5)][0] : value
    }
    function clearLater() {
        Qt.callLater(function() {
            root.ctrl = false; root.alt = false; root.altgr = false
            if (panel.activeKeypadState === "SHIFTED") panel.activeKeypadState = "NORMAL"
        })
    }
    function commitCharacter(text) {
        if (pendingDead) {
            var dead = deadKeys[pendingDead]
            text = text === " " ? dead[0] : (text + dead[1]).normalize("NFC")
            Qt.callLater(function() { root.pendingDead = "" })
        }
        event_handler.onKeyReleased(text, "")
    }
    function selectDead(name) {
        if (pendingDead) {
            var old = pendingDead
            event_handler.onKeyReleased(deadKeys[old][0], "")
            pendingDead = old === name ? "" : name
        } else pendingDead = name
    }
    function send(key) {
        if (pendingDead) { event_handler.onKeyReleased(deadKeys[pendingDead][0], ""); Qt.callLater(function() { root.pendingDead = "" }) }
        var sequence = (ctrl ? "Ctrl+" : "") + (alt ? "Alt+" : "")
        if (panel.activeKeypadState === "SHIFTED") sequence += "Shift+"
        sequence += key.length === 1 ? key.toUpperCase() : key
        event_handler.onKeyReleased("", "commit")
        event_handler.onKeyReleased(sequence, "keysequence")
        clearLater()
    }
    function sendCharacter(text, baseKey) {
        if (ctrl || alt) { send(text); return }
        var upper = panel.activeKeypadState === "SHIFTED" ||
                    (panel.activeKeypadState === "CAPSLOCK" && /[a-zäöü]/.test(baseKey))
        var value = text
        if (altgr) {
            var entry = levels[baseKey.toLowerCase()]
            value = entry ? entry[upper ? 1 : 0] : ""
        } else if (baseKey === "´") value = upper ? "dead:grave" : "dead:acute"
        if (value.indexOf("dead:") === 0) selectDead(value.substring(5))
        else if (value) commitCharacter(value)
        clearLater()
    }
}
