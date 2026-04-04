# TaskFlow
Гем для управления процессами

## Установка
#№Callbacks. Как работают и для чего они нужны
Callbacks является механизмом, который позволяет выполнять пользовательский код автоматически до или после перехода между состояниями рабочего процесса.
#Фукция before_transition регестрирует блок кода, который должен выполниться до перехода между состояниями. 
Функция after_transition регистрирует блок кода, который должен выполниться после успешного перехода между состояниями.
Функця callbacks возвращает хэш-хранилище для всех колбэков класса. Если хранилище ещё не создано - создаёт его с пустыми массивами.
Функция run_before_callbacks запускает все before колбэки, которые подходят для перехода из состояния from в состояние to.
Функция run_after_callbacks запускает все after колбэки, которые подходят для перехода из состояния from в состояние to.
Функция should_run_callback? проверяет, должен ли конкретный колбэк быть выполнен для данного перехода.

Добавь в Gemfile:
```ruby
gem 'task_flow', git: 'https://github.com/Timofey-blip/task_flow.git'
затем: bundle install

---

### **3. Как использовать (по шагам)**
```markdown
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

создай машину состояний
machine = TaskFlow::StateMachine.new(flow)
выполняй переходы
machine.fire_event(:pay)   # → :paid
machine.fire_event(:ship)  # → :shipped

puts machine.state  # => :shipped


---

### **4. Примеры**
```markdown
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

Задача в трекере
task_flow = TaskFlow.define :task do
  state :todo
  state :done
  
  transition todo: :done, event: :finish
end


## Тесты
```bash
bundle install
rake test

## Лицензия
MIT License
