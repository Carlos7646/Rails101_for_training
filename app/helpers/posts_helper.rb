module PostsHelper
  def render_simple_format_post_content(post)
  	simple_format(post.content)
  end
end
