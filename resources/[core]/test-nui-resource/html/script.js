$(
    function () {
        function display(bool) {
            // Uses jquery to hide show element
            if (bool) {
                $("#container").show()
            }
            else {
                $("#container").hide()
            }
        }

        display(false)

        window.addEventListener('message', function(event) {
            var item = event.data;
            if (item.type === "ui") {
                if (item.status == true) {
                    display(true)
                }
                else {
                    display(false)
                }
            }
        });

        // if user hits the Escape key, close the nui
        document.onkeyup = function (data) {
            //https://developer.mozilla.org/en-US/docs/Web/API/UI_Events/Keyboard_event_key_values
            if (data.key === "Escape") {
                $.post('https://test-nui-resource/exit', JSON.stringify({}));
                return;
            }
        };

        // if the user clicks the exit button, close nui
        $("#close").click(function () {
            $.post('https://test-nui-resource/exit', JSON.stringify({}));
        });

        $("#submit").click(function () {
            /*
                CrBrowserMain/ Mixed Content: The page at 'https://cfx-nui-test-nui-resource/html/index.html' was loaded over HTTPS, but requested an insecure XMLHttpRequest endpoint 'http://test-nui-resource/main'. This request has been blocked; the content must be served over HTTPS. (@game/ui/jquery.js:8623)
                fix: jquery is accessed with http, posts are done with https
            */

            let inputValue = $("#input").val()
            if (inputValue.length >= 100) {
                $.post("https://test-nui-resource/error", JSON.stringify({
                    error: "Input was greater than 100 characters."
                }));
                return;
            }
            else if (!inputValue) {
                $.post("https://test-nui-resource/error", JSON.stringify({
                    error: "No input was supplied."
                }));
                return;
            }

            $.post("https://test-nui-resource/main", JSON.stringify({
                text: inputValue
            }));
            return;
        })
    }
)