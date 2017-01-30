export default class Filters {
  static selectUsers(users, store) {
    return users.filter(user => store.userIds.indexOf(user.id) > -1);
  }

  static selectRoles(users, store) {
    return users
      .filter(user => store.roleIds.indexOf(user.primary_role.id) > -1);
  }

  static selectSkills(users, store) {
    return users.filter(user => {
      let filteredUserSkills = user
        .skill_ids
        .filter(id => store.skillIds.indexOf(id) > -1);
      return filteredUserSkills.length > 0;
    });
  }
}
