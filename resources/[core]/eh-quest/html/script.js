var itemCount = 1;
var itemStack = [];

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        let data = event.data;
        if (data.action == 'start') {
            document.getElementById("checkbox").style.display = "flex";
        }
        else if (data.action == 'complete') {
            CompleteQuest();
        }
        else if (data.action == 'title') {
            SetTitle(data.value);
        }
        else if (data.action == 'add') {
            AddItem(data.id, data.content);
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

    StoreQuest(thisId);
    itemCount++;
}

function StoreQuest(_id) {
    itemStack.push(_id);
}

function CompleteQuest() {
    const htmlId = itemStack.shift();

    document.getElementById(`input-${htmlId}`).checked = true;
}