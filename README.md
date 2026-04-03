# TaskFlow
Гем для управления процессами

## Установка
## Установка

Добавь в Gemfile:
```ruby
gem 'task_flow', git: 'https://github.com/Timofey-blip/task_flow.git'
затем: bundle install

---

### **3. Как использовать (по шагам)**
```markdown



---
### Машина состояний
require 'task_flow'

flow = TaskFlow.define :order do
  state :created
  state :paid
  state :shipped
  
  transition created: :paid, event: :pay
  transition paid: :shipped, event: :ship
end


##создание 

machine = TaskFlow::StateMachine.new(flow)

##выполнение переходов

machine.fire_event(:pay)   # → :paid
machine.fire_event(:ship)  # → :shipped

puts machine.state  # => :shipped

##описание
##fire_event(event) - выполнение переходов
##can_transition?(event) - проверка возможности перехода
##available_events - доступные события
##transitions_history - история переходов
##reset - сброс в начальное состояние

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
