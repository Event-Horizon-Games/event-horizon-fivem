window.addEventListener('message', (event) => {
    let item = event.data;

    //---------------- Carhud Section -------------------------------
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

    //------------------- Seatbelt Section ---------------------------
    if (item.type === 'seatbelt-toggle') {
        if (item.display === 'off') {
            $(".seatbelt-icon").css('background-color', 'red');
            $(".seatbelt-icon").css('text-decoration', 'line-through');
            $(".seatbelt-icon").css('text-decoration-color', 'red');
        }
        else if (item.display === 'on') {
            $(".seatbelt-icon").css('background-color', 'green');
            $(".seatbelt-icon").css('text-decoration', 'none');
        }
    }

    //----------------- Dashboard Section -------------------------------
    if (item.type === 'open-dashboard') {
        $(".dashboard-container").css('display', 'block');
    }

    if (item.type === 'close-dashboard') {
        $(".dashboard-container").css('display', 'none');
    }
});

// User presses escape
window.addEventListener('keyup', (event) => {
    if (event.key === 'Escape') {
        $.post(`https://${GetParentResourceName()}/close-dashboard-nui`);
        console.log('pressed escape.');
    }
});

$('#ignition').click(() => {
    $.post(`https://${GetParentResourceName()}/ignition`);
});