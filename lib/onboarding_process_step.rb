class OnboardingProcessStep
  def initialize(name, link, current=false, css_class="inactive-step")
    @name = name
    @link = link
    @current = current
  end

  def name
    @name
  end

  def current?
    @current
  end

  def css_class
    @css_class
  end

  def css_class!(css_class)
    @css_class = css_class
  end

  def link
    @link
  end

  def next_link
    @next_link
  end

  def next_link!(link)
    @next_link = link
  end

  def current!
    @current = true
  end

  def ==(step)
    self.name == step.name
  end
end
