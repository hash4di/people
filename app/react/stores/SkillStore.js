import alt from '../alt';

class SkillStore {
  constructor() {
    this.skills = [];
  }

  static setInitialState(skills) {
    this.state.skills = skills;
  }
}

export default alt.createStore(SkillStore);
