class OnboardingProcessSteps

  include Rails.application.routes.url_helpers

  def initialize(steps)
    @steps = steps
    self.add_step_css_classes
    self.add_step_next_links
  end

  def steps
    @steps
  end

  def current_step
    c_step = nil
    steps.each do |step|
      c_step = step if step.current?
    end
    c_step
  end

  def by_name(step_name)
    res = nil
    steps.each do |step|
      res = step if step.name == step_name
    end
    res
  end

  def add(step)
    @steps << step
  end

  def add_step_css_classes
    steps.each do |step|
      if step.current?
        step.css_class! "active-step"
      elsif steps.index(step) < steps.index(current_step)
        step.css_class! "completed-step"
      end
    end
  end

  def add_step_next_links
    steps.each_with_index do |step, i|
      next_index = i+1
      if next_index < steps.size
        step.next_link!(steps.fetch(next_index).link)
      else
        step.next_link!(root_path(take_tour: 1))
      end
    end
  end

end