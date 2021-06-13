const addForm = document.querySelector('.add');
const list = document.querySelector('.todos');
const url = 'http://localhost:5000/todos';

const generateTemplate = () => {
  list.innerHTML = ""

  fetch(url)
      .then(response => response.json())
      .then(json => {

        json.sort(function(a,b) {
          return a.id - b.id;
        });

        for(let i = 0; i < json.length; i++) {
          let id = json[i].id;
          let todo = json[i].content;
          let done = json[i].done;
          let todo_class = ""
          let checked = "";
          if(done) {
            todo_class = "done-todo";
            checked = "checked";
          }

          let html = `
          <li class="list-group-item d-flex justify-content-between align-items-center">
            <input type="checkbox" class="checkbox" ${checked}>
            <span class="${todo_class}" id="${id}">${todo}</span>
            <i class="far fa-trash-alt delete"></i>
          </li>
          `;

          list.innerHTML += html;
        }
      });
};


async function sendRequest(url = '', method = '', data = {}) {
  const response = await fetch(url, {
    method: method,
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data) 
  });

  return response;
}


list.addEventListener('click', e => {
  if(e.target.classList.contains('delete')) {
    let todo_id = e.target.previousElementSibling.id;
    deleteTodo(todo_id);
  } else if (e.target.classList.contains('checkbox')) {
    let todo_id = e.target.nextElementSibling.id;
    let done = !e.target.checked;
    markTodoAsDone(todo_id, done);
  }
}); 
  

function deleteTodo(todo_id) {
  let delete_url = url + "/" + todo_id;

  sendRequest(delete_url, 'DELETE', {})
    .then(response => response.status)
    .then(status => {
      if(status == 200) {
        generateTemplate();
      } else {
        alert('Błąd. Wybrany elemen został już usunięty. Odśwież stronę');
      }
    })
}


// add todos event
addForm.addEventListener('submit', e => {
  e.preventDefault();

  const todo = addForm.add.value.trim();
  let done = false;

  sendRequest(url, 'POST', { content: todo, done: done })
    .then(data => {
      generateTemplate();
      addForm.children[1].value = '';
  });
});


function markTodoAsDone(todo_id, done) {
  let put_url = url + "/done/" + todo_id;

  sendRequest(put_url, 'PUT', { current_state: done, done: !done })
    .then(response => response.status)
    .then(status => {
      if(status == 200) {
        generateTemplate();
      } else {
        alert('Błąd. Wybrany elemen został już zmodyfikowany. Odśwież stronę');
      }
    })
}

generateTemplate(); 