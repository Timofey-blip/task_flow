# TaskFlow
Гем для управления процессами

## Установка
Добавь в Gemfile:
```ruby
gem 'task_flow', git: 'https://github.com/Timofey-blip/task_flow.git'
```
Затем: 
```bash
bundle install
```

---

## Как использовать

### Шаг 1: Опиши процесс
```ruby
require 'task_flow'

flow = TaskFlow.define :order do
  state :created
  state :paid
  state :shipped
  
  transition created: :paid, event: :pay
  transition paid: :shipped, event: :ship
end
```

### Шаг 2: Создай машину состояний
```ruby
machine = TaskFlow::StateMachine.new(flow)
```

### Шаг 3: Выполняй переходы
```ruby
machine.fire_event(:pay)   # → :paid
machine.fire_event(:ship)  # → :shipped

puts machine.state  # => :shipped
```


---

## Примеры

### Заказ в магазине
```ruby
order_flow = TaskFlow.define :order do
  state :created
  state :paid
  state :delivered
  
  transition created: :paid, event: :pay
  transition paid: :delivered, event: :deliver
end
```

### Задача в трекере
```ruby
task_flow = TaskFlow.define :task do
  state :todo
  state :done
  
  transition todo: :done, event: :finish
end
```

---

## Callbacks. Как работают и для чего они нужны

Callbacks является механизмом, который позволяет выполнять пользовательский код автоматически до или после перехода между состояниями рабочего процесса.

### Функции 
* `before_transition`
  * регистрирует блок кода, который должен выполниться до перехода между состояниями

* `after_transition` 
  * регистрирует блок кода, который должен выполниться после успешного перехода между состояниями

* `callbacks` 
  * возвращает хэш-хранилище для всех колбэков класса (если хранилище ещё не создано - создаёт его с пустыми массивами)

* `run_before_callbacks` 
  * запускает все before колбэки, которые подходят для перехода из состояния from в состояние to

* `run_after_callbacks` 
  * запускает все after колбэки, которые подходят для перехода из состояния from в состояние to

* `should_run_callback?` 
  * проверяет, должен ли конкретный колбэк быть выполнен для данного перехода

---

## State_machine - описание

State_machine - описывает объект, находящийся в одном из состояний, и строго определённые переходы между этими самыми состояниями.

### Функции 
* `can_transition?`
  * для проверки возможности выполнения перехода по событию

* `available_events`
  * нужна, чтобы получить все доступные события для текущего состояния (возвращает массив символов событий)

* `state` 
  * для получения текущего состояния (имя), ниже(с параметром) - применяется для тестов

* `transitions_history` 
  * используется для получения истории всех переходов

* `reset` 
  * сбрасывает машину состояний до начального состояния

* `run_before_callbacks` 
  * запускает все before колбэки, которые подходят для перехода из состояния from в состояние to

---

## Тесты
В проекте используются тесты на базе Minitest.

### Структура тестов

```text
test/
├── test_definition.rb
├── test_helper.rb
├── test_state.rb
├── test_task_flow.rb
└── test_transition.rb
```

### Покрытие тестами
* `test_definition.rb`
  * создание workflow (внутренний уровень), регистрация состояний и переходов, получение доступных событий, поиск состояния по имени

* `test_helper.rb`
  * конфигурация тестов
    
* `test_state.rb`
  * создание состояний, хранение имени, сравнение состояний, строковое представление (to_s)

* `test_task_flow.rb`
  * наличие версии, создание workflow (внешний уровень), работа с блоком и без блока, алиас .build

* `test_transition.rb`
  * инициализация переходов между состояниями, поддержка объектов State и строковое представление to_s



### Запуск тестов

```bash
bundle install
rake test
```

---

## Лицензия
MIT License
