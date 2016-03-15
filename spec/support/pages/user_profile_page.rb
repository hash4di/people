class UserProfilePage < SitePrism::Page
  set_url '/users{/user_id}'

  elements :primary_role_sliders, '.primary-slider'
end
