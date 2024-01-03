window.addEventListener('message', (event) => {
	let data = event.data;

    if (data.type === 'show-target') {
        showTarget(data.picture);
    }
    else if (data.type === 'close-target') {
        closeall();
    }
})


function showTarget(picture) {
    console.log(picture);
    const pictureURL = `https://nui-img/${picture}/${picture}?v=${Date.now()}`;

    $('body').css('display', 'block')

    $('.all').append(`
    <div class="item">
        <div class="polaroid">
            <div class="header">Your Target</div>
            <img src="${pictureURL}">
            <div class="caption">
                <p>Name:</p>
                <p>Habits: Smoker</p>
            </div>
        </div>
    </div>`);
}

function closeall() {
    $.post("https://eh-bountyboard:close-headshot");
    $('.all').empty()
    $('body').css('display', 'none')
}