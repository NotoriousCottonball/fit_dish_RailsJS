class RecipesController < ApplicationController

  before_action :require_login

  def show
    set_recipe
    find_user_by_id
  end

  def new
    @recipe = Recipe.new
    12.times { @recipe.recipe_ingredients.build.build_ingredient }
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      flash[:primary] = "Recipe Created!"
      redirect_to user_recipe_path(current_user, @recipe)
    else
      flash.now[:danger] = "Failed to Create Recipe!"
    # 12.times { @recipe.recipe_ingredients.build.build_ingredient }
      render :new
    end
  end

  def destroy
    set_recipe
    @recipe.destroy
    flash[:primary] = "Recipe Deleted!"
    redirect_to user_recipes_path(current_user)
  end

  private

      def set_recipe
        @recipe = Recipe.find(params[:id])
      end

      def recipe_params
        params.require(:recipe).permit(:name, :description, :instructions,
         recipe_ingredients_attributes: [:quantity,
         ingredient_attributes: [:name]])
      end
end
