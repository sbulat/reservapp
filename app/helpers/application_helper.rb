module ApplicationHelper
  def glyph(text, glyph, small = false)
    text = ' ' + text if text.present?
    small_class = small ? ' small' : ''
    "<i class='glyphicon glyphicon-#{glyph}#{small_class}'></i>#{text}".html_safe
  end
end
