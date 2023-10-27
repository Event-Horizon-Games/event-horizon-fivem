window.addEventListener("message", (event) => {
    switch (event.data.type) {
        case "show-options":
            ShowOptions();
            break;
        case "close-options":
            CloseOptions();
            break;
    }
});

$(document).keyup(function(e) {
    if (e.key === "Escape") {
        //close on escape press
        CloseOptions();
    }
});

function ShowOptions() {
    $('#main-container').css('display', 'block');
}

function CloseOptions() {
    $('#main-container').css('display', 'none');
    $.post(`https://${GetParentResourceName()}/close-options`);
}

function guideToVinewoodSign() {
    CloseOptions();
    $.post(`https://${GetParentResourceName()}/guide-vinewood-sign`);
}

function guideToBoilingbroke() {
    CloseOptions();
    $.post(`https://${GetParentResourceName()}/guide-boilingbroke`);
}

function guideToDiamondCasino() {
    CloseOptions();
    $.post(`https://${GetParentResourceName()}/guide-diamond-casino`);
}

function guideToPillbox() {
    CloseOptions();
    $.post(`https://${GetParentResourceName()}/guide-pillbox`);
}

function guideToAltaApartments() {
    CloseOptions();
    $.post(`https://${GetParentResourceName()}/guide-alta-apartments`);
}