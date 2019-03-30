class Media

  def self.samantha_says(message)
    `say -v Samantha "#{message}"`
  end

  def self.amelie_says(message)
    `say -v Amelie "#{message}"`
  end

  def self.spinner(message, length)
    spinner = TTY::Spinner.new("[:spinner] #{message}", format: :pulse_2)
    spinner.auto_spin
    sleep(length)
    spinner.stop("")
  end


end
