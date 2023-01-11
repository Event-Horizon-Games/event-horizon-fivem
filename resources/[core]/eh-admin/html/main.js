$(() => {
    window.addEventListener('message', (event) => {
        let item = event.data

        if (item.type == "open") {
            const { x, y, z } = item.Pos;
            const heading = item.Heading;

            $('body').css('display', 'block')

            $('.all').append(` 
                <div class="coords"> <span id="copy"><i class="fa-solid fa-copy"></i></span> <span id="text" > vector3(${x.toFixed(2)}, ${y.toFixed(2)}, ${z.toFixed(2)}) </span> </div>
                <div class="coords">  <span id="copy"><i class="fa-solid fa-copy"></i></span> <span id="text" > vector4(${x.toFixed(2)}, ${y.toFixed(2)}, ${z.toFixed(2)}, ${heading.toFixed(2)}) </span>  </div>
                <div class="coords">  <span id="copy"><i class="fa-solid fa-copy"></i></span> <span id="text" > x = ${x.toFixed(2)}, y = ${y.toFixed(2)}, z = ${z.toFixed(2)} </span>  </div>
                <div class="coords">  <span id="copy"><i class="fa-solid fa-copy"></i></span> <span id="text" > x = ${x.toFixed(2)}, y = ${y.toFixed(2)}, z = ${z.toFixed(2)}, h = ${heading.toFixed(2)} </span>  </div>
                <div class="coords">  <span id="copy"><i class="fa-solid fa-copy"></i></span> <span id="text" > vec3(${x.toFixed(2)}, ${y.toFixed(2)}, ${z.toFixed(2)}) </span>  </div>
                <div class="coords">  <span id="copy"><i class="fa-solid fa-copy"></i></span> <span id="text" > vec4(${x.toFixed(2)}, ${y.toFixed(2)}, ${z.toFixed(2)}, ${heading.toFixed(2)}) </span>  </div>
                <button id="close-button">CLOSE</button>
                `)
        }

        let copy = str => {
            const copytx = document.createElement('textarea');
            copytx.value = str;
            document.body.appendChild(copytx);
            copytx.select();
            document.execCommand('copy');
            document.body.removeChild(copytx);
        };

        $('.coords').click(function () {
            let text = $(this).find('#text').text()
            copy(text)
            console.log(text)
        })

        $('#close-button').click(() => {
            closeall()
        })

        document.onkeydown = function (e) {
            if ((e.which == 27)) {
                closeall()
            }
        }

        function closeall() {
            $.post("https://eh-admin/eh-admin:close");
            $('.all').empty()
            $('body').css('display', 'none')
        }
    })
})
