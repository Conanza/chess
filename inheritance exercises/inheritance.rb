class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
    boss.employees << self if boss
  end

  def bonus(multiplier)
    @salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees

  def initialize(name, title, salary, boss)
    super
    @employees = []
  end

  def bonus(multiplier)
    sub_employees_salaries * multiplier
  end

  def sub_employees_salaries
    total_salary = 0
    return 0 if employees.empty?

    employees.each do |employee|
      if employee.is_a?(Manager)
        sub_salary = employee.sub_employees_salaries
        total_salary += employee.salary + sub_salary
      else
        total_salary += employee.salary
      end
    end

    total_salary
  end
end


ned = Manager.new("Ned", "Founder", 1000000, nil)
darren = Manager.new("Darren", "TA Manager", 78000, ned)
shawna = Employee.new("Shawna", "TA", 12000, darren)
david = Employee.new("David", "TA", 10000, darren)

p ned.bonus(5) == 500000
p darren.bonus(4) == 88000
p david.bonus(3) == 30000
p ned.sub_employees_salaries