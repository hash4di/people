import {Component} from 'react';
import UserSkillHistoryFilter from './user_skill_history_filter';
import UserSkillHistoryTimeline from './user_skill_history_timeline';
import Moment from 'moment';
import {LONG_DATE} from '../../constants/date_formats'

export default class UserSkillHistory extends Component {
  cssNamespace = 'user-skill-history'

  constructor(props) {
    super(props);
    const activeCategory = 0;

    this.state = {
      containerWidth: null,
      loadingState: true,
      model: [],
      startDate: Moment().subtract(12, 'months').format(LONG_DATE),
      endDate: Moment().format(LONG_DATE),
      skillCategories: this.getSkillCategories(props.skill_categories, activeCategory),
      activeCategory
    };
  }

  componentDidMount() {
    this.setModel(this.getActiveCategory(), this.state.startDate, this.state.endDate);
    this.setContainerWidth();
  }

  render() {
    return (
      <div className={this.cssNamespace}>
        <UserSkillHistoryFilter
          cssNamespace={`${this.cssNamespace}-filter`}
          listPrimaryText='Skill categories:'
          listItems={this.state.skillCategories}
          startDate={this.state.startDate}
          endDate={this.state.endDate}
          onItemClick={this.setActiveCategory.bind(this)}
          onDateChange={this.onDateChange.bind(this)}
          setDateRange={this.setDateRange.bind(this)}
        />
        {this.getLoadingState()}
        <UserSkillHistoryTimeline
          cssNamespace={`${this.cssNamespace}-timeline`}
          model={this.state.model}
          containerWidth={this.state.containerWidth}
          loadingState={this.state.loadingState}
          startDate={this.state.startDate}
          endDate={this.state.endDate}
        />
      </div>
    );
  }

  getSkillCategories(skillCategories, activeCategory) {
    return skillCategories.reduce((acc, {name}, index) => {
      acc.push({
        name,
        isActive: index === activeCategory
      });
      return acc;
    }, []);
  }

  getLoadingState() {
    if (this.state.loadingState) {
      return (
        <div className={`progress-bar progress-bar-striped active ${this.cssNamespace}-loading-state`}>
          Loading, please wait...
        </div>
      );
    }
  }

  getActiveCategory() {
    return this.state.skillCategories[this.state.activeCategory].name;
  }

  setDateRange(months) {
    const startDate = Moment().subtract(months, 'months').format(LONG_DATE);
    const endDate = Moment().format(LONG_DATE);

    this.setState({ startDate, endDate });
    this.setModel(this.getActiveCategory(), startDate, endDate);
  }

  setModel(category, startDate, endDate) {
    this.setState({ loadingState: true });

    $.ajax({
      url: Routes.api_v3_user_skill_rates_path(),
      dataType: 'json',
      data: {
        category,
        token: 'miamiamia',
        user_id: this.props.user_id,
        start_date: Moment(startDate).format(),
        end_date: Moment(endDate).format()
      }
    }).done((data) => {
      const model = this.getModel(data, startDate, endDate);
      this.setState({ model, loadingState: false });
    });
  }

  getModel(data, startDate, endDate) {
    const daysInRange = Moment(endDate).diff(startDate, 'days');

    return data.reduce((model, item) => {
      const points = this.getPointsTable(item, endDate);
      const totalDays = this.getTotalDays(points);

      model.push({
        skillName: item.name,
        maxRate: item.rate_type === 'range' ? 3 : 1,
        daysOffset: daysInRange - totalDays,
        points,
        totalDays
      });

      return model;
    }, []);
  }

  getTotalDays(points) {
    return points.reduce((acc, point) => acc + point.days, 0);
  }

  getPointsTable(item, endDate) {
    const result = [];
    let pointsTable = [];
    let datePointer = null;

    if (item.first_change_before_data_range) pointsTable.push(item.first_change_before_data_range);
    if (item.history) pointsTable = pointsTable.concat(item.history);
    if (pointsTable[0]) datePointer = Moment(pointsTable[0].created_at);

    pointsTable.forEach((item, index, pointsTable) => {
      const nextDate = Moment(pointsTable[index + 1] ? pointsTable[index + 1].created_at : endDate);

      result.push({
        days: nextDate.diff(datePointer, 'days'),
        favorite: item.favorite,
        note: item.note,
        rate: item.rate
      });

      datePointer = nextDate;
    });

    return result;
  }

  setContainerWidth() {
    this.setState({containerWidth: $('#main-container > div.container').width()});
  }

  setActiveCategory(index) {
    const skillCategories = [].concat(this.state.skillCategories);

    skillCategories[this.state.activeCategory].isActive = false;
    skillCategories[index].isActive = true;

    this.setState({ skillCategories, activeCategory: index });
    this.setModel(skillCategories[index].name, this.state.startDate, this.state.endDate);
    this.setContainerWidth();
  }

  onDateChange(dateInput, date) {
    const startDate = dateInput === 'startDate' ? date : this.state.startDate;
    const endDate = dateInput === 'endDate' ? date : this.state.endDate;

    this.setState({ [dateInput]: date });
    this.setModel(this.getActiveCategory(), startDate, endDate);
    this.setContainerWidth();
  }
}
