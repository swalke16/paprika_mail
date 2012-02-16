require 'posterous'

module PaprikaMail::Posters

  class Posterous

    def initialize(site_id)
      ::Posterous.config = "#{PaprikaMail::CONFIG_PATH}/posterous.config"
      @site_id = site_id
    end

    def create(post)
      @site ||= ::Posterous::Site.find(@site_id)
      @site.posts.create(post)
    end

  end

end
