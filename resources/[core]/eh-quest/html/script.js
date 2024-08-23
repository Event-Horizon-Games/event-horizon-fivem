$(document).ready(function () {
    window.addEventListener('message', function (event) {
        let data = event.data
        if (data.action == 'check') {
            document.getElementById("one").checked = true;
        }
    });
});