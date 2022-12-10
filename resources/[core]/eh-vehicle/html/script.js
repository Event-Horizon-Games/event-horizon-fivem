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
})

// --------------- User presses escape while nui is focused --------------
window.addEventListener('keyup', (event) => {
    if (event.key === 'Escape' && $('.dashboard-container').css('display') === 'block') {
        $.post(`https://${GetParentResourceName()}/close-dashboard-nui`);
    }
})

// ----------------------- Dashboard click events ----------------------------
$(() => {
    $("#ignition").click(function() {
        $.post(`https://${GetParentResourceName()}/ignition`);
    });

    $('#hood').click(() => {
        $.post(`https://${GetParentResourceName()}/door-control`, JSON.stringify({
            door: 4
        }));
    });

    $('#trunk').click(() => {
        $.post(`https://${GetParentResourceName()}/door-control`, JSON.stringify({
            door: 5
        }));
    });

    $('#interiorLight').click(() => {
        $.post(`https://${GetParentResourceName()}/interior-lights`);
    });

    $('#windowFrontLeft').click(() => {
        $.post(`https://${GetParentResourceName()}/window-control`, JSON.stringify({
            window: 0,
            door: 0
        }));
    });

    $('#doorFrontLeft').click(() => {
        $.post(`https://${GetParentResourceName()}/door-control`, JSON.stringify({
            door: 0
        }));
    });

    $('#seatFrontLeft').click(() => {
        $.post(`https://${GetParentResourceName()}/seat-control`, JSON.stringify({
            seat: -1
        }));
    });

    $('#windowFrontRight').click(() => {
        $.post(`https://${GetParentResourceName()}/window-control`, JSON.stringify({
            window: 2,
            door: 2
        }));
    });

    $('#doorFrontRight').click(() => {
        $.post(`https://${GetParentResourceName()}/door-control`, JSON.stringify({
            door: 1
        }));
    });

    $('#seatFrontRight').click(() => {
        $.post(`https://${GetParentResourceName()}/seat-control`, JSON.stringify({
            seat: 0
        }));
    });

    $('#windowRearLeft').click(() => {
        $.post(`https://${GetParentResourceName()}/window-control`, JSON.stringify({
            window: 2,
            door: 2
        }));
    });

    $('#doorRearLeft').click(() => {
        $.post(`https://${GetParentResourceName()}/door-control`, JSON.stringify({
            door: 2
        }));
    });

    $('#seatRearLeft').click(() => {
        $.post(`https://${GetParentResourceName()}/seat-control`, JSON.stringify({
            seat: 1
        }));
    });

    $('#windowRearRight').click(() => {
        $.post(`https://${GetParentResourceName()}/window-control`, JSON.stringify({
            window: 3,
            door: 3
        }));
    });

    $('#doorRearRight').click(() => {
        $.post(`https://${GetParentResourceName()}/door-control`, JSON.stringify({
            door: 3
        }));
    });

    $('#seatRearRight').click(() => {
        $.post(`https://${GetParentResourceName()}/seat-control`, JSON.stringify({
            seat: 2
        }));
    });
});