let alreadyProgressing = false
let currID = 0
let activeBars = []

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        let data = event.data
        if (data.action == 'run') {
            data.id = currID
            progress(data)
        } else if (data.action == 'stop') {
            stopProgress()
        }
    });
});

function stopProgress(id) {
    if (id == undefined) {
        $('#progress').addClass('hidden');
        alreadyProgressing = false;
        $('#progress-value').css("animation", '');
        $('#progress').css("animation", '');
        var index = activeBars.indexOf(currID);
        if (index !== -1) {
            activeBars.splice(index, 1);
        }
        currID = currID + 1
    } else {
        if (activeBars.includes(id)) {
            var index = activeBars.indexOf(id);
            if (index !== -1) {
                activeBars.splice(index, 1);
            }
            $('#progress').addClass('hidden');
            alreadyProgressing = false;
            $('#progress-value').css("animation", '');
            $('#progress').css("animation", '');
            currID = currID + 1
        }
    }
}

function progress(data) {
    if (!alreadyProgressing) {
        activeBars.push(data.id);
        alreadyProgressing = true;
        $('#progress').removeClass('hidden');
        $('#progress-text').text(data.text);
        setTimeout(function () {
            stopProgress(data.id);
        }, data.time * 1000);
        $('#progress-value').css("animation", `load ${data.time}s normal forwards`);
        $('#progress').css("animation", `glow ${data.time}s normal forwards`);
        let bodyStyles = window.getComputedStyle(document.body);
        let mainColor = bodyStyles.getPropertyValue('--mainColor');
        document.body.style.setProperty('--mainColor', data.color);
        mainColor = bodyStyles.getPropertyValue('--mainColor');
    } else {
        $.post(`https://${GetParentResourceName()}/notif`, JSON.stringify({ text: "Already doing an action." }))
        return
    }
}