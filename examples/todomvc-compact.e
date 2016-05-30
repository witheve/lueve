routing
  [#url segment: [ix: 1, value]]
  update
    [@app filter: value]

handle insert
  [#keydown element: [@new-todo value] key: "enter"]
  update history
    [#todo body: value, completed: false, editing: false]

handle edit
  (todo, body, editing, completed) =
    if [#double-click element: [#todo-item todo]] then (todo, todo.body, true, todo.completed)
    else if [#keydown element: [#todo-editor todo] key: "escape"] then (todo, todo.body, false, todo.completed)
    else if [#keydown element: [#todo-editor todo value] key: "enter", value] then (todo, value, false, false)
    else if [#blur element: [#todo-editor todo value]] then (todo, todo.body, false, todo.completed)
    else if [#click element: [#todo-checkbox todo]] then (todo, todo.body, false, toggle(todo.completed))
    else if [#click element: [@toggle-all checked]] then ([#todo editing, body], body, editing, checked)
  update history
    todo := [editing, body, completed]

handle removes
  todo = if [#click element: [#remove-todo todo]] then todo
         else if [#click element: [@clear-completed]] then [#todo completed: true]
  update history
    todo := none

draw todomvc
  [@app filter]
  (todo, body, completed, editing) =
    if filter = "completed" then ([#todo, body, completed: true, editing], body, true, editing)
    else if filter = "active" then ([#todo, body, completed: false, editing], body, false, editing)
    else ([#todo, body, completed, editing], body, completed, editing)
  all-checked = if not([#todo completed: false]) then true
                else false
  count = count(given [#todo completed: false])
  [#pluralize number: count, singular: "item left", plural: "items left" text: count-text]
  hide-clear-completed = count(given [#todo completed: true]) == 0

  update
    [#div @todoapp children:
      [#header children:
        [#h1 text: "todos"]
        [#input @new-todo, autofocus: true, placeholder: "What needs to be done?"]]
      [#div @main children:
        [#input @toggle-all, type: "checkbox", checked: all-checked]
        [#ul @todo-list children:
          [#li, class: [todo: true, completed, editing], todo, children:
            [#input #todo-check, class: "toggle", type: "checkbox", checked: completed]
            [#label #todo-item, text: body, todo]
            [#button #remove-todo todo]
            [#input #todo-editor, style: [display: editing], todo, value: body]]]]
      [#footer children:
        [#span @todo-count children: [#strong text: count] [#span text: count-text]]
        [#ul @filters
          [#li children: [#a href: "#/all" class: [selected: filter == "all"] text: "all"]]
          [#li children: [#a href: "#/active" class: [selected: filter == "active"] text: "active"]]
          [#li children: [#a href: "#/completed" class: [selected: filter == "completed"] text: "completed"]]]
        [#button @clear-completed, style: [display: toggle(hide-clear-completed)] text: "Clear completed"]]]
