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