require 'posterous'

module PaprikaMail

  class BlogService

    def initialize(cfg)
      ::Posterous.config = "#{PaprikaMail::CONFIG_PATH}/posterous.config"
      @site_id = cfg["site_id"]
    end

    def create(post)
      @site ||= ::Posterous::Site.find(@site_id)
      @site.posts.create(post)
    end

  end

end
