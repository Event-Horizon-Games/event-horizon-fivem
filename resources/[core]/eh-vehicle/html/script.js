window.addEventListener('message', (event) => {
    let item = event.data;

    if (item.type === 'carhud-toggle') {
        if ($("#car-hud").css('display') === "none") {
            $("#car-hud").css('display', 'flex');
            $("#car-hud").css('left', item.posX + '%');
            $("#car-hud").css('bottom', item.posY + '%');
        } 
        else {
            $("#car-hud").css('display', 'none');
        }
    }

    if (item.type === 'carhud-update') {
        $('span.mph-gauge').text(item.mph);
        $('span.mph-gauge').css('color', item.color);
    }

    if (item.type === 'carhud-togglecruise') {
        if ($(".cruise-button").css('display') === "none") {
            $(".cruise-button").css('display', 'flex');
        } 
        else {
            $(".cruise-button").css('display', 'none');
        }
    }

    if (item.type === 'seatbelt-toggle') {
        if (item.display === 'true') {
            $(".seatbelt-icon").css('display', 'flex');
        }
        else {
            $(".seatbelt-icon").css('display', 'none');
        }
    }
})