// this will actually restart the loading bar a lot, making multiple loading bars is an exercise to the reader... for now.
// for a set of possible events, see https://github.com/citizenfx/fivem/blob/master/code/components/loading-screens-five/src/LoadingScreens.cpp
var count = 0;
var thisCount = 0;

//Set the loadscreen audio volume
var vid = document.getElementById("space-jazz");
vid.volume = 0.1;

const emoji = {
    INIT_BEFORE_MAP_LOADED: ['🍉'],
    INIT_AFTER_MAP_LOADED: ['🍋', '🍊'],
    INIT_SESSION: ['🍐', '🍅', '🍆'],
};

const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;

        document.querySelector('.letni h3').innerHTML += emoji[data.type][data.order - 1] || '';
    },

    initFunctionInvoking(data) {
        document.querySelector('.thingy').style.left = '0%';
        document.querySelector('.thingy').style.width = ((data.idx / count) * 100) + '%';
    },

    startDataFileEntries(data) {
        count = data.count;

        document.querySelector('.letni h3').innerHTML += "\u{1f358}";
    },

    performMapLoadFunction(data) {
        ++thisCount;

        document.querySelector('.thingy').style.left = '0%';
        document.querySelector('.thingy').style.width = ((thisCount / count) * 100) + '%';
    },

    onLogLine(data) {
        document.querySelector('.letni p').innerHTML = data.message + "..!";
    }
};

window.addEventListener('message', function (e) {
    (handlers[e.data.eventName] || function () { })(e.data);
});