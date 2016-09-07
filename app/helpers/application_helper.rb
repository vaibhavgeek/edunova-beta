module ApplicationHelper
def markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML , autolink: true , filter_html: true , tables: true  )
  return markdown.render(text).html_safe
end
end
