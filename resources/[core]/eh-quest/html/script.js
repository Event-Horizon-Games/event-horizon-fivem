$(document).ready(function () {
    window.addEventListener('message', function (event) {
        let data = event.data;
        if (data.action == 'start') {
            document.getElementById("checkbox").style.display = "flex";
        }
        else if (data.action == 'complete') {
            CompleteItem(data.itemId);
        }
        else if (data.action == 'title') {
            SetTitle(data.value);
        }
        else if (data.action == 'add') {
            AddItem(data.id, data.content);
        }
        else if (data.action == 'close') {

        }
    });
});

function SetTitle(_title) {
    var title = document.getElementById("checkboxtitle");

    title.innerText = _title;
}

function AddItem(id, content) {
    const checkBox = document.getElementById("checkbox");

    //create input element
    var inputElement = document.createElement("input");
    inputElement.setAttribute("id", `input-${id}`);
    inputElement.setAttribute("type", "checkbox");

    //create the label for the input element
    var labelElement = document.createElement("label");
    labelElement.setAttribute("id", `label-${id}`);
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

function CompleteItem(itemId) {
    document.getElementById(`input-${itemId}`).checked = true;
}

function Close() {
    const check = document.getElementById(`checkbox`);
    check.remove();
}