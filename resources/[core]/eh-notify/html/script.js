const $TYPES = {
    ["success"]: {
        ["icon"]: "bi bi-check2-circle",
    },
    ["error"]: {
        ["icon"]: "bi bi-exclamation-circle",
    },
    ["info"]: {
        ["icon"]: "bi bi-bell",
    },
    ["bag"]: {
        ["icon"]: "bi bi-bag",
    },
    ["message"]: {
        ["icon"]: "bi bi-chat-square-text",
    },
    ["phone"]: {
        ["icon"]: "bi bi-telephone-inbound",
    },
};

const COLOR_CODES = {
    "~g~": "green",
    "~r~": "red",
    "~y~": "yellow",
    "~b~": "blue",
    "~lb~": "lightblue",
    "~lg~": "lightgreen",
    "~w~": "white",
};

const REPLACE_COLORCODES = (string, obj) => {
    let stringToReplace = string;

    for (let id in obj) {
        stringToReplace = stringToReplace.replace(new RegExp(id, "g"), obj[id]);
    }

    return stringToReplace;
};

$NOTIFICATION = function (_type, _message) {
    let id = $(`.notification`).length + 1;
    let message = _message;
    let type = _type;


    for (color in COLOR_CODES) {
        if (message.includes(color)) {
            let objArray = {};
            objArray[color] = `<span style="color: ${COLOR_CODES[color]}">`;
            objArray["~s~"] = `</span>`;

            let newString = REPLACE_COLORCODES(message, objArray);

            message = newString;
        }
    }

    let $notification = $(
        `<div class="notification unfold" id="${id}">
            <div class="type">
            <i class="${$TYPES[type]["icon"]}"></i>
            </div>

            <div class="message"><small style="font-size: 12px;">New notification</small><br>${message}
            </div>
        </div>`
    ).appendTo(`.main`);

    setTimeout(() => {
        $notification.addClass("fold").fadeOut(700);
    }, 10000);

    return $notification;
};

window.addEventListener("message", function (event) {
    let item = event.data;

    $NOTIFICATION(item.type, item.message);
});