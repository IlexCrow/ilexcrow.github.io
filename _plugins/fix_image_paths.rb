module Jekyll
  class FixImagePaths < Generator
    safe true

    def generate(site)
      site.posts.docs.each do |post|
        post.content.gsub!(/\]\(assets\//, '](/assets/')
      end
    end
  end
end
