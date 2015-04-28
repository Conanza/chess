class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
    boss.underlings << self if boss
  end

  def bonus(multiplier)
    @salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :underlings

  def initialize(name, title, salary, boss)
    super
    @underlings = []
  end

  def bonus(multiplier)
    total_salary = 0
    underlings.each do |employee|
      total_salary += employee.salary * multiplier if employee.class == Manager
      total_salary += employee.bonus(multiplier)
      # employee_salary = employee.salary
      # if employee.is_a?(Manager)
      #   total_salary += employee_salary + employeed.bonus(multiplier)
      # else
      #   total_salary += employee_salary
      # end
    end
    total_salary
    #bonus = underlings.inject(0) {|sum, underling| sum + underling.salary}
  end

  
end

# boss = Manager.new("Rob Robber", "The Chief", 10000000, nil)
# p boss.underlings

ned = Manager.new("Ned", "Founder", 1000000, nil)
darren = Manager.new("Darren", "TA Manager", 78000, ned)
shawna = Employee.new("Shawna", "TA", 12000, darren)
david = Employee.new("David", "TA", 10000, darren)

p ned.bonus(5)
p darren.bonus(4)
p david.bonus(3)
