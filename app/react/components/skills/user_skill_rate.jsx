import React, {PropTypes} from 'react';
import UserSkillRateSource from '../../sources/UserSkillRateSource';
import RateScale from '../RateScale';
import _ from 'lodash';

export default class UserSkillRate extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      originalSkill: Object.assign({}, props.skill),
      skill: Object.assign({}, props.skill),
    };
    this.isDirty = this.isDirty.bind(this);
    this.onFavoriteChange = this.onFavoriteChange.bind(this);
    this.onNoteChange = this.onNoteChange.bind(this);
    this.onSubmit = this.onSubmit.bind(this);
    this.onRateChange = this.onRateChange.bind(this);
    this.userSkillRateSaved = this.userSkillRateSaved.bind(this);
    this.failedToSaveUserSkillRate = this.failedToSaveUserSkillRate.bind(this);
  }

  isDirty() {
    return !_.isEqual(this.state.originalSkill, this.state.skill);
  }

  onFavoriteChange() {
    const skill = Object.assign(
      {}, this.state.skill, { favorite: !this.state.skill.favorite }
    );
    this.setState({ skill });
  }

  onNoteChange(event) {
    const skill = Object.assign(
      {}, this.state.skill, { note: event.currentTarget.value }
    );
    this.setState({ skill });
  }

  onRateChange(newRate) {
    const skill = Object.assign(
      {}, this.state.skill, { rate: newRate }
    );
    this.setState({ skill });
  }

  userSkillRateSaved() {
    this.setState({ originalSkill: Object.assign({}, this.state.skill) });
    Messenger({theme: 'flat'}).success(`Your changes for: ${this.props.skill.name} are saved.`);
  }

  failedToSaveUserSkillRate() {
    Messenger({theme: 'flat'}).error(`Failed to save your changes for: ${this.props.skill.name}.`);
  }

  onSubmit() {
    UserSkillRateSource.update(
      this.state.skill
    ).done(
      this.userSkillRateSaved
    ).fail(
      this.failedToSaveUserSkillRate
    );
  }

  rateComponent() {
    return <RateScale key={this.state.skill.id} rate={this.state.skill.rate} rateType={this.state.skill.rate_type} onRateChange={this.onRateChange}/>;
  }

  componentDidMount() {
    $('[data-toggle="tooltip"]').tooltip();
  }

  render() {
    const saveDivClass = `btn ${this.isDirty() ? 'btn-info' : 'btn-primary disabled'}`;
    const favoriteCLass = `skill__favorite glyphicon btn-lg ${this.state.skill.favorite ? 'glyphicon-pushpin text-primary' : 'glyphicon-minus'}`;

    const rateStars = this.rateComponent();

    return(
      <tr className="skill__row">
        <td>{this.props.skill.name}</td>
        <td>{this.props.skill.description}</td>
        <td>
          {rateStars}
        </td>
        <td>
          <textarea className="skill__note form-control" rows="1" cols="30" onChange={this.onNoteChange} placeholder='Add note to your rate' value={this.state.skill.note}>
          </textarea>
        </td>
        <td onClick={this.onFavoriteChange}>
          <i
            className={favoriteCLass}
            data-toggle="tooltip"
            data-placement="top"
            title="Skill I want to get better at."
          ></i>
        </td>
        <td>
          <div
            className={saveDivClass}
            onClick={this.onSubmit}
            data-toggle="tooltip"
            data-placement="top"
            title="Save your changes."
          >
            <i className="glyphicon glyphicon-floppy-disk"></i>
          </div>
        </td>
      </tr>
    );
  }
}
