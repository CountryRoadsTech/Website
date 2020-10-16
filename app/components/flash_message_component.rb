class FlashMessageComponent < ApplicationComponent
  def initialize(level:, message:)
    @level = level
    @message = prepare_message(message)
  end

  def before_render
    super

    @info_icon = helpers.icon('info-circle')
    @dismiss_icon = helpers.icon('x-circle')
  end

  private

  # Some built-in flash messages send their data as a String, not a Hash.
  # To ensure compatibility, this method converts the string to a simple hash.
  def prepare_message(message)
    case message
    when Hash
      message
    else
      {title: message}
    end
  end
end
