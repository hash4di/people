import alt from '../alt';
import SchedulingFilterActions from '../actions/SchedulingFilterActions';

class SchedulingFilterStore {
  constructor() {
    this.bindActions(SchedulingFilterActions);
    this.userIds = [];
    this.roleIds = [];
    this.skillIds = [];
  }

  changeUserFilter(userIds) {
    this.setState({ userIds: userIds });
  }

  changeRoleFilter(roleIds) {
    this.setState({ roleIds: roleIds });
  }

  changeSkillFilter(skillIds) {
    this.setState({ skillIds: skillIds });
  }
}

export default alt.createStore(SchedulingFilterStore);
