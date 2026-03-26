TaskFlow.define :order do
  state :created
  state :paid

  transition created: :paid, event: :pay
end