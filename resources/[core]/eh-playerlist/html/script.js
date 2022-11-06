window.addEventListener('message', function(event) {
    var item = event.data;
    var buf = $('#wrap');
    buf.find('table').append("<tr class=\"heading\"><th>ID</th><th>Name</th><th>Steam ID</th</tr>");

    // section hides the table if the close is passed
    if (item.meta && item.meta == 'close')
    {
        document.getElementById("ptbl").innerHTML = "";
        $('#wrap').hide();
        return;
    }

    // section displays the table
    buf.find('table').append(item.text);
    $('#wrap').show();
}, false);