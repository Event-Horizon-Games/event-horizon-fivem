window.addEventListener('message', (event) => {
	let data = event.data;

    if (data.type === 'show-target') {
        showTarget(data.picture);
    }
})


function showTarget(picture) {
    console.log(picture);
    const pictureURL = `https://nui-img/${picture}/${picture}?v=${Date.now()}`;

    $('body').css('display', 'block')

    $('.all').append(`<img src="${pictureURL}">`);
}