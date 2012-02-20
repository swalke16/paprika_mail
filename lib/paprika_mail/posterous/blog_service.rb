require 'posterous'

module PaprikaMail

  class BlogService

    def initialize(cfg)
      ::Posterous.config = cfg
      @site = ::Posterous::Site.find(cfg["site_id"])
    end

    def create(obj)
      create_meal_plan_post(obj) if obj.is_a?(PaprikaMail::Models::MealPlan)
      create_grocery_list_post(obj) if obj.is_a?(PaprikaMail::Models::GroceryList)
      create_recipe_post(obj) if obj.is_a?(PaprikaMail::Models::Recipe)
    end

    private

    def create_meal_plan_post(meal_plan)
      make_post :title => "Meal Plan: #{meal_plan.start_date.strftime("%m/%d/%Y")} - #{meal_plan.end_date.strftime("%m/%d/%Y")}",
                :body => PaprikaMail::Renderer.render(meal_plan),
                :tags => "meal plan"
    end

    def create_grocery_list_post(grocery_list)
      make_post :title => "Grocery List: #{grocery_list.start_date.strftime("%m/%d/%Y")} - #{grocery_list.end_date.strftime("%m/%d/%Y")}",
                :body => PaprikaMail::Renderer.render(grocery_list),
                :tags => "grocery list"
    end

    def create_recipe_post(recipe)
      make_post :title => recipe.name,
                :body => PaprikaMail::Renderer.render(recipe),
                :tags => "recipe"
    end

    def make_post(attrs)
      attrs = attrs.merge({ :display_date => Time.now.to_s,
                            :autopost => true.to_s,
                            :is_private => false.to_s})

      delete_if_existing(attrs)
      @site.posts.create(attrs)
    end

    private

    def delete_if_existing(attrs)
      post = @site.posts.detect {|p| p.title == attrs[:title]}
      post.destroy if post
    end

  end

end
