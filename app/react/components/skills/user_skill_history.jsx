import React from 'react';
import UserSkillHistoryFilter from './user_skill_history_filter';
import UserSkillHistoryTimeline from './user_skill_history_timeline';
import Moment from 'moment';
import { getModel, getModel2, getModel3, getModel4 } from './mock';

export default class UserSkillHistory extends React.Component {
  cssNamespace = 'user-skill-history'
  dateFormat = 'Y-MM-DD'

  state = {
    activeCategory: 0,
    skillCategories: [
      {
        name: 'backend',
        isActive: true
      },
      {
        name: 'devops',
        isActive: false
      },
      {
        name: 'ios',
        isActive: false
      },
      {
        name: 'frontend',
        isActive: false
      },
      {
        name: 'design',
        isActive: false
      },
      {
        name: 'android',
        isActive: false
      },
    ],
    fromDate: null,
    toDate: null,
    containerWidth: null
  }

  constructor(props) {
    super(props);
    const fromDate = Moment().subtract(12, 'months').format(this.dateFormat);
    const toDate = Moment().format(this.dateFormat);

    this.state.fromDate = fromDate;
    this.state.toDate = toDate;
    this.state.containerWidth = $('#main-container > div.container').width();
    this.setModel(this.getActiveCategory(), fromDate, toDate, true);
  }

  render() {
    return (
      <div className={this.cssNamespace}>
        <UserSkillHistoryFilter
          cssNamespace={`${this.cssNamespace}-filter`}
          listPrimaryText='Skill categories:'
          listItems={this.state.skillCategories}
          fromDate={this.state.fromDate}
          toDate={this.state.toDate}
          onItemClick={this.setActiveCategory.bind(this)}
          onDateChange={this.onDateChange.bind(this)}
          setDateRange={this.setDateRange.bind(this)}
        />
        <UserSkillHistoryTimeline
          cssNamespace={`${this.cssNamespace}-timeline`}
          model={this.state.model}
          containerWidth={this.state.containerWidth}
        />
      </div>
    );
  }

  getActiveCategory() {
    return this.state.skillCategories[this.state.activeCategory].name;
  }

  setDateRange(months) {
    const fromDate = Moment().subtract(months, 'months').format(this.dateFormat);
    const toDate = Moment().format(this.dateFormat);

    this.setState({ fromDate, toDate });
    this.setModel(this.getActiveCategory(), fromDate, toDate);
  }

  setModel(category, fromDate, toDate, firstSet) {
    let model;

    if (category === 'backend') model = getModel();
    if (category === 'devops') model = getModel2();
    if (category === 'ios') model = getModel3();
    if (category === 'frontend') model = getModel4();

    if (firstSet) {
      this.state.model = model;
    } else {
      this.setState({ model });
    }
  }

  setActiveCategory(index) {
    const skillCategories = [].concat(this.state.skillCategories);

    skillCategories[this.state.activeCategory].isActive = false;
    skillCategories[index].isActive = true;

    this.setState({ skillCategories, activeCategory: index });
    this.setModel(skillCategories[index].name, this.state.fromDate, this.state.toDate);
  }

  onDateChange(dateInput, date) {
    const fromDate = dateInput === 'fromDate' ? date : this.state.fromDate;
    const toDate = dateInput === 'toDate' ? date : this.state.toDate;

    this.setState({ [dateInput]: date });
    this.setModel(this.getActiveCategory(), fromDate, toDate);
  }
}
