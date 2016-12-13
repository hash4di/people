export default class UserSkillRateSource {
  static update(params) {
    return $.ajax({
      url: Routes.user_skill_rate_path(params.id),
      type: "PATCH",
      dataType: 'json',
      data: {
        user_skill_rate: params
      }
    });
  }
}
