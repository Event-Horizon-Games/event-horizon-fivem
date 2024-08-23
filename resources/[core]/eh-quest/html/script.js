$(document).ready(function () {
    window.addEventListener('message', function (event) {
        let data = event.data
        if (data.action == 'start') {
            document.getElementById("checkbox").style.display = "flex";
        }
        else if (data.action == 'check') {
            document.getElementById("one").checked = true;
        }
    });
});