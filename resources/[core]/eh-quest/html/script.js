$(document).ready(function () {
    window.addEventListener('message', function (event) {
        let data = event.data;
        if (data.action == 'start') {
            document.getElementById("checkbox").style.display = "flex";
        }
        else if (data.action == 'check') {
            AddItem(data.value);
            document.getElementById("test").checked = true;
        }
        else if (data.action == 'title') {
            SetTitle(data.value);
        }
        else if (data.action == 'add') {
            AddItem(data.value);
        }
    });
});

//TODO figure out a way to keep track of created items for reference later

function SetTitle(_title) {
    var title = document.getElementById("checkboxtitle");

    title.innerText = _title;
}

function AddItem(content) {
    const checkBox = document.getElementById("checkbox");

    //create input element
    var inputElement = document.createElement("input");
    inputElement.setAttribute("id", "test");
    inputElement.setAttribute("type", "checkbox");

    //create the label for the input element
    var labelElement = document.createElement("label");
    labelElement.setAttribute("for", "test");
    labelElement.setAttribute("type", "checkbox");
    labelElement.innerHTML =
    `
        <span></span>
        ${content}
        <ins><i>${content}</i></ins>
    `;

    checkBox.appendChild(inputElement);
    checkBox.appendChild(labelElement);
}